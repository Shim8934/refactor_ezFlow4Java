package egovframework.ezEKP.ezPMS.web;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Base64.Decoder;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Stream;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezPMS.service.EzPMSService;
import egovframework.ezEKP.ezPMS.vo.BoardViewerVO;
import egovframework.ezEKP.ezPMS.vo.CommentVO;
import egovframework.ezEKP.ezPMS.vo.DateVO;
import egovframework.ezEKP.ezPMS.vo.DeptViewVO;
import egovframework.ezEKP.ezPMS.vo.ProjectBoardVO;
import egovframework.ezEKP.ezPMS.vo.ProjectCompanyVO;
import egovframework.ezEKP.ezPMS.vo.ProjectGroupMemberVO;
import egovframework.ezEKP.ezPMS.vo.ProjectGroupVO;
import egovframework.ezEKP.ezPMS.vo.ProjectInfoVO;
import egovframework.ezEKP.ezPMS.vo.ProjectMainSettingVO;
import egovframework.ezEKP.ezPMS.vo.ProjectMemberScheduleVO;
import egovframework.ezEKP.ezPMS.vo.ProjectMemberVO;
import egovframework.ezEKP.ezPMS.vo.ProjectTaskTreeVO;
import egovframework.ezEKP.ezPMS.vo.ProjectTaskVO;
import egovframework.ezEKP.ezPMS.vo.ProjectUserVO;
import egovframework.ezEKP.ezPMS.vo.SearchVO;
import egovframework.ezEKP.ezPMS.vo.TaskLogListVO;
import egovframework.ezEKP.ezPMS.vo.TaskMemberVO;
import egovframework.ezEKP.ezSystem.service.EzSystemAdminService;
import egovframework.ezEKP.ezSystem.vo.SysParamVO;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@RestController
public class EzPMSGWController {

	private static final Logger LOGGER = LoggerFactory.getLogger(EzPMSGWController.class);

	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;

	@Autowired
	private EzCommonService ezCommonService;

	@Resource(name = "EzPMSService")
	private EzPMSService ezPMSService;

	@Resource(name = "MOptionService")
	private MOptionService mOptionService;

	@Resource(name = "EzSystemAdminService")
	private EzSystemAdminService ezSystemAdminService;

	@Autowired
	private EzOrganService ezOrganService;

	/**
	 * 프로젝트 리스트 호출
	 * 
	 * @param userId
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/userId/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getProjectList(@PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/userId/" + userId + "] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			String deptId = info.getDeptId();
			String searchByName = request.getParameter("searchByProjectName");
			String searchByUser = request.getParameter("searchByUser");
			String searchByOverview = request.getParameter("searchByOverview");
			String companyId = info.getCompanyId();
			
			if (searchByName != null && !searchByName.equals("")) {
				searchByName = searchByName.replace("\\", "\\\\");
				searchByName = searchByName.replace("%", "\\%");
				searchByName = searchByName.replace("_", "\\_");
			}

			if (searchByUser != null && !searchByUser.equals("")) {
				searchByUser = searchByUser.replace("\\", "\\\\");
				searchByUser = searchByUser.replace("%", "\\%");
				searchByUser = searchByUser.replace("_", "\\_");
			}

			if (searchByOverview != null && !searchByOverview.equals("")) {
				searchByOverview = searchByOverview.replace("\\", "\\\\");
				searchByOverview = searchByOverview.replace("%", "\\%");
				searchByOverview = searchByOverview.replace("_", "\\_");
			}

			// 검색 및 환경설정 세팅
			Map<String, Object> search = new HashMap<>();
			search.put("projectSort", request.getParameter("projectSort"));
			search.put("listNumber", request.getParameter("listNumber"));
			search.put("listProjectStatus", request.getParameter("listProjectStatus"));
			search.put("currentPage", request.getParameter("currentPage"));
			search.put("startCount", request.getParameter("startCount"));
			search.put("viewType", request.getParameter("viewType"));
			// 정렬
			search.put("orderWhat", request.getParameter("orderWhat"));
			search.put("orderHow", request.getParameter("orderHow"));
			// 검색
			search.put("searchByName", searchByName);
			search.put("searchByUser", request.getParameter("searchByUser"));
			search.put("searchByStartDate", request.getParameter("searchByStartDate"));
			search.put("searchByEndDate", request.getParameter("searchByEndDate"));
			search.put("searchByOverview", request.getParameter("searchByOverview"));

			List<ProjectInfoVO> projectList;

			// 프로젝트 리스트 가져오기
			// admin 파라미터는 관리자모드에서만 넘어온다. 이 때 userId를 ""로 넘겨서 모든 프로젝트 검색이 가능하도록
			// 한다.
			if (request.getParameter("admin") != null && request.getParameter("admin").equals("true")) {
				projectList = ezPMSService.getProjectList(info.getTenantId(), "", deptId, search, lang,
						request.getParameter("position"), companyId);
			} else {
				projectList = ezPMSService.getProjectList(info.getTenantId(), userId, deptId, search, lang,
						request.getParameter("position"), companyId);
			}

			LOGGER.debug("projectList Count : " + projectList.size());

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", projectList);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", e.getMessage());
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/userId/" + userId + "] ended.");
		return result;
	}

	/**
	 * 새 프로젝트 추가
	 * 
	 * @param json
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject addNewProject(@RequestBody JSONObject json, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/projects] started.");

		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();

		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			String companyId = info.getCompanyId();
			int tenantId = info.getTenantId();

			Map<String, Object> project = new HashMap<String, Object>();
			project.put("projectName",
					request.getParameter("projectName").replaceAll("\"", "&quot;").replaceAll("\'", "&#39;"));
			project.put("weightInput", request.getParameter("weightInput"));
			project.put("planStartDate", request.getParameter("planStartDate"));
			project.put("planEndDate", request.getParameter("planEndDate"));
			project.put("overview", request.getParameter("overview"));
			project.put("endAlamStatus", request.getParameter("endAlamStatus"));
			project.put("headManagerId", request.getParameter("headManagerId"));
			project.put("writerName", info.getUserName());
			project.put("creatorId", userId);
			project.put("creatorName", info.getUserName());
			project.put("creatorName2", info.getUserName2());
			project.put("creatorDeptname", info.getDeptName());
			project.put("creatorDeptname2", info.getDeptName2());
			project.put("createDate", request.getParameter("createDate"));
			project.put("tenantId", info.getTenantId());
			project.put("lang", lang);

			// 최상위 그룹 생성을 위한 파라미터
			project.put("treeDepth", 0);
			project.put("ancestorGroup", "0");
			project.put("sortOrder", -1);
			project.put("status", "W");
			project.put("upperGroupId", 0);
			project.put("companyId", companyId);

			Long projectId = ezPMSService.addNewProject(project);

			LOGGER.debug("addNewProject projectId : " + projectId);

			List<Map<String, Object>> projectMemberList = (List<Map<String, Object>>) json.get("managerList");
			projectMemberList.addAll((List<Map<String, Object>>) json.get("participantList"));
			projectMemberList.addAll((List<Map<String, Object>>) json.get("viewerList"));

			project.put("projectId", projectId);
			project.put("memberCount", projectMemberList.size());

			// 이슈리스트 그룹 생성
			project.put("groupName", "이슈 리스트");
			ezPMSService.addGroup(project, "Y", companyId, tenantId, lang);

			// 그룹 생성
			project.put("sortOrder", 0);
			project.put("groupName",
					request.getParameter("projectName").replaceAll("\"", "&quot;").replaceAll("\'", "&#39;"));
			long groupId = ezPMSService.addGroup(project, "N", companyId, tenantId, lang);
			LOGGER.debug("addNewProject groupId : " + groupId);

			data.put("projectId", projectId);
			data.put("groupId", groupId);

			// 프로젝트 멤버 테이블에 추가
			for (int i = 0; i < projectMemberList.size(); i++) {
				String memberId = projectMemberList.get(i).get("userId").toString();
				String userIdType = projectMemberList.get(i).get("userIdType").toString();

				ProjectMemberVO member = ezPMSService.getUserInfo(memberId, tenantId, userIdType);
				member.setMemberRoleId((int) projectMemberList.get(i).get("memberRoleId"));
				member.setProjectId(projectId);
				member.setUserIdType(userIdType);

				ezPMSService.addProjectMember(member, tenantId);
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/projects] ended.");
		return result;
	}

	/**
	 * 프로젝트 삭제 함수
	 * 
	 * @param projectId
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject deleteProject(@PathVariable String projectId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/projects/" + projectId + "] started.");

		JSONObject result = new JSONObject();

		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String status = request.getParameter("status");
			int tenantId = info.getTenantId();
			String deptId = info.getDeptId();

			LOGGER.debug("status : " + status + ", " + "userId : " + userId + ", tenantId : " + tenantId + ", deptId : "
					+ deptId);

			String[] projectIdList = projectId.split("_");
			String roleCheck = "";

			// admin 파라미터는 관리자모드에서만 넘어온다. 값이 넘어오지 않을 때만 roleCheck를 시행한다.
			if (request.getParameter("admin") == null || !request.getParameter("admin").equals("true")) {
				for (int i = 0; i < projectIdList.length; i++) {
					int userRole = ezPMSService.getUserProjectRole(userId, tenantId, Long.parseLong(projectIdList[i]),
							deptId);
					LOGGER.debug("projectId : " + projectIdList[i] + ", role : " + userRole);

					if (userRole != 1) {
						roleCheck = "rejected";
					}
				}
			}

			if (roleCheck.equals("")) {
				for (int i = 0; i < projectIdList.length; i++) {
					ezPMSService.deleteProject(tenantId, Long.parseLong(projectIdList[i]));
				}
				roleCheck = "permitted";
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", roleCheck);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/projects/" + projectId + "] ended.");
		return result;
	}

	/**
	 * 프로젝트관리 메인 화면 설정 정보 출력
	 * 
	 * @param userId
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/users/{userId}/setting", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getMainSetting(@PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/users/" + userId + "/setting] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = new MCommonVO();
			
			if (request.getParameter("userId") == null || request.getParameter("userId").equals("")) {
				info = mOptionService.commonInfoWeb(serverName, userId);
			} else {
				info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			}

			String userIdType = request.getParameter("userIdType");
			int tenantId = info.getTenantId();

			ProjectMainSettingVO projectSetting = ezPMSService.getProjectMainSetting(userId, tenantId, userIdType);

			LOGGER.debug("projectSetting : " + projectSetting.getViewType());
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", projectSetting);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/users/" + userId + "/setting] ended.");
		return result;
	}

	/**
	 * 프로젝트관리 메인 화면 설정 정보 수정
	 * 
	 * @param userId
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/users/{userId}/setting", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject updateMainSetting(@PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/users/" + userId + "/setting] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();

			ProjectMainSettingVO project = new ProjectMainSettingVO();
			project.setViewType(Integer.parseInt(request.getParameter("viewType")));
			project.setProgressColor(request.getParameter("progressColor"));
			project.setCompleteColor(request.getParameter("completeColor"));
			project.setOverdueColor(request.getParameter("overdueColor"));
			project.setHoldColor(request.getParameter("holdColor"));
			project.setProjectSort(Integer.parseInt(request.getParameter("projectSort")));
			project.setListNumber(Integer.parseInt(request.getParameter("listNumber")));
			project.setListProjectStatus(request.getParameter("listProjectStatus"));
			project.setUserId(userId);

			LOGGER.debug("[parameter] viewType : " + project.getViewType() + ", progressColor : "
					+ project.getProgressColor() + ", completeColor : " + project.getCompleteColor()
					+ ", overdueColor : " + project.getOverdueColor() + ", holdColor : " + project.getHoldColor()
					+ ", projectSort : " + project.getProjectSort() + ", listNumber : " + project.getListNumber()
					+ ", listProjectStatus : " + project.getListProjectStatus());

			ezPMSService.updateMainSetting(project, tenantId);

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/users/" + userId + "/setting] ended.");
		return result;
	}

	/**
	 * 프로젝트 상태 변경 실행
	 * 
	 * @param projectId
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/status", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject updateProjectStatus(@PathVariable String projectId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/projects/" + projectId + "/status] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			String deptId = info.getDeptId();
			String lang = commonUtil.getMultiData(info.getLang(), tenantId);
			String status = request.getParameter("status");
			String nowStatus = request.getParameter("nowStatus");
			String changeDate = request.getParameter("changeDate");
			String companyId = info.getCompanyId();

			LOGGER.debug("nowStatus : " + nowStatus + ", status : " + status + ", " + "userId : " + userId
					+ ", tenantId : " + tenantId + ", deptId : " + deptId);

			String[] projectIdList = projectId.split("_");
			String roleCheck = "";

			// admin 파라미터는 관리자모드에서만 넘어온다. 값이 넘어오지 않을 때만 roleCheck를 시행한다.
			if (request.getParameter("admin") == null || !request.getParameter("admin").equals("true")) {

				for (int i = 0; i < projectIdList.length; i++) {
					int userRole = ezPMSService.getUserProjectRole(userId, tenantId, Long.parseLong(projectIdList[i]),
							deptId);

					LOGGER.debug("projectId : " + projectIdList[i] + ", role : " + userRole);

					if (userRole != 1) {
						roleCheck = "rejected";
					}
				}
			} else {
				userId = ""; // 관리자 모드에서는 userId를 ""으로 넘겨야
								// ezPMSService.getProjectDetails()에서 값을 불러올 수
								// 있음
			}

			if (roleCheck.equals("")) {
				roleCheck = "permitted";

				for (int i = 0; i < projectIdList.length; i++) {
					ProjectInfoVO project = ezPMSService.getProjectDetails(Long.parseLong(projectIdList[i]), userId,
							info.getTenantId(), "new", lang, deptId, companyId);
					String planEndDate = project.getPlanEndDate();

					LOGGER.debug("planEndDate : " + planEndDate);

					ezPMSService.updateProjectStatus(Long.parseLong(projectIdList[i]), status, info.getTenantId(),
							changeDate, planEndDate);

					if (nowStatus.equals("W") && status.equals("P")) {
						ezPMSService.updateProjectRealDate(Long.parseLong(projectIdList[i]), info.getTenantId(),
								changeDate, status, planEndDate, companyId, lang);
					}

					if (status.equals("C")) {
						ezPMSService.updateProjectRealDate(Long.parseLong(projectIdList[i]), info.getTenantId(),
								changeDate, status, planEndDate, companyId, lang);
						ezPMSService.completeAllTasks(Long.parseLong(projectIdList[i]), info.getTenantId(), changeDate,
								planEndDate, companyId, lang);
					}
				}
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", roleCheck);
		} catch (Exception e) {
			LOGGER.debug("ERROR : " + e.getMessage());
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", e.getMessage());
		}

		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/projects/" + projectId + "/status] ended.");
		return result;
	}

	/**
	 * 프로젝트 개요 정보 호출
	 * 
	 * @param projectId
	 * @param userId
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/userId/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getProjectOverview(@PathVariable Long projectId, @PathVariable String userId,
			HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/userId/" + userId + "] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			String lang = commonUtil.getMultiData(info.getLang(), tenantId);
			String deptId = info.getDeptId();
			String mode = request.getParameter("mode");
			String companyId = info.getCompanyId();

			JSONObject data = new JSONObject();

			// admin 파라미터는 관리자모드에서만 넘어온다. 이 때 userId를 ""로 넘겨서 모든 프로젝트 검색이 가능하도록
			// 한다.
			if (request.getParameter("admin") != null && request.getParameter("admin").equals("true")) {
				ProjectInfoVO project = ezPMSService.getProjectDetails(projectId, "", tenantId, mode, lang, deptId,
						companyId);
				data.put("project", project);
			} else {
				ProjectInfoVO project = ezPMSService.getProjectDetails(projectId, userId, tenantId, mode, lang, deptId,
						companyId);
				String kanbanOrder = ezPMSService.getKanbanOrder(projectId, userId, tenantId);
				int userRole = ezPMSService.getUserProjectRole(userId, tenantId, projectId, deptId);
				ProjectMainSettingVO mainSetting = ezPMSService.getProjectMainSetting(userId, tenantId, "user");

				if (kanbanOrder == null || kanbanOrder.equals("")) {
					if (userRole == 3) {
						// 조회자 default : 나의 전체업무, 전체 진행중인업무, 전체 완료된업무, 게시판
						kanbanOrder = "A,P,C,B";
					} else {
						// default : 나의 전체업무, 전체 진행중인업무, 전체 완료된업무, 게시판
						kanbanOrder = "MA,P,C,B";
					}
				}

				LOGGER.debug("kanbanOrder : " + kanbanOrder + ", userRole : " + userRole);

				data.put("project", project);
				data.put("kanbanOrder", kanbanOrder);
				data.put("userRole", userRole);
				data.put("mainSetting", mainSetting);
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/userId/" + userId + "] ended.");
		return result;
	}

	/**
	 * 프로젝트 수정 실행
	 * 
	 * @param json
	 * @param projectId
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject updateProject(@RequestBody JSONObject json, @PathVariable Long projectId,
			HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/projects/" + projectId + "] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			int tenantId = info.getTenantId();
			String companyId = info.getCompanyId();

			ProjectInfoVO project = new ProjectInfoVO();
			project.setProjectId(projectId);
			project.setProjectName(request.getParameter("projectName"));
			project.setWeightInput(Integer.parseInt(request.getParameter("weightInput")));
			project.setPlanEndDate(request.getParameter("planEndDate"));
			project.setPlanStartDate(request.getParameter("planStartDate"));
			project.setOverview(request.getParameter("overview"));
			project.setAlamMailStatus(Integer.parseInt(request.getParameter("endAlamStatus")));
			project.setHeadManagerId(request.getParameter("headManagerId"));
			project.setCreateDate(request.getParameter("createDate"));

			ezPMSService.updateProject(project, tenantId, companyId, lang);

			// 멤버 삭제 후 다시 넣기
			ezPMSService.deleteProjectMember(projectId, tenantId);

			List<Map<String, Object>> projectMemberList = (List<Map<String, Object>>) json.get("managerList");
			projectMemberList.addAll((List<Map<String, Object>>) json.get("participantList"));
			projectMemberList.addAll((List<Map<String, Object>>) json.get("viewerList"));

			for (int i = 0; i < projectMemberList.size(); i++) {
				String userId = (String) projectMemberList.get(i).get("userId");
				String userIdType = (String) projectMemberList.get(i).get("userIdType");

				ProjectMemberVO member = ezPMSService.getUserInfo(userId, tenantId, userIdType);
				member.setMemberRoleId((int) projectMemberList.get(i).get("memberRoleId"));
				member.setProjectId(projectId);
				member.setUserIdType(userIdType);

				ezPMSService.addProjectMember(member, tenantId);
			}

			long groupId = Long.parseLong(request.getParameter("groupId"));
			// 프로젝트 정보를 프로젝트와 같은 이름의 최상위 그룹 정보도 바꿈
			ProjectGroupVO groupInfo = new ProjectGroupVO();
			groupInfo.setGroupName(request.getParameter("projectName"));
			groupInfo.setGroupId(groupId);
			groupInfo.setProjectId(Long.parseLong(request.getParameter("projectId")));
			groupInfo.setOverview(request.getParameter("overview"));
			groupInfo.setTenantId(info.getTenantId());
			groupInfo.setUpperGroupId(0L);
			groupInfo.setHeadManagerId(request.getParameter("headManagerId"));
			groupInfo.setPlanStartDate(request.getParameter("planStartDate"));
			groupInfo.setPlanEndDate(request.getParameter("planEndDate"));

			ezPMSService.updateGroup(groupInfo, lang);

			JSONObject data = new JSONObject();
			data.put("projectId", projectId);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/projects/" + projectId + "] ended.");
		return result;
	}

	/**
	 * 프로젝트 내 역할별 멤버 리스트 호출
	 * 
	 * @param projectId
	 * @param roleId
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "null" })
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/roles/{roleId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getProjectMember(@PathVariable Long projectId, @PathVariable int roleId,
			HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/roles/" + roleId + "] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			int tenantId = info.getTenantId();
			String lang = commonUtil.getMultiData(info.getLang(), tenantId);
			int isGantt = Integer.parseInt(request.getParameter("isGantt"));

			List<ProjectMemberVO> memberList = ezPMSService.getProjectMemberList(projectId, roleId, lang, tenantId,
					isGantt);

			// 사원 이미지 사진 불러오기
			for (ProjectMemberVO member : memberList) {
				String imagePath = ezOrganService.getPropertyValue(member.getUserId(), "extensionAttribute2", tenantId);

				if (imagePath != null && !imagePath.equals("")) {
					String realPath = commonUtil.getUploadPath("upload_personal.PHOTO", tenantId) + commonUtil.separator
							+ imagePath;
					String fullPath = request.getServletContext().getRealPath(realPath);

					if (fullPath != null || !fullPath.equals("")) {
						member.setUserImage("/ezCommon/downloadAttach.do?filePath=" + realPath);
					} else {
						member.setUserImage("/images/poll/default_pic_vote.gif");
					}

					if (member.getUserIdType().equals("dept")) {
						member.setUserImage("/images/poll/default_pic_vote.gif");
					}

				} else {
					member.setUserImage("/images/poll/default_pic_vote.gif");
				}
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", memberList);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/roles/" + roleId + "] ended.");
		return result;
	}

	/**
	 * 칸반 순서 변경
	 * 
	 * @param projectId
	 * @param userId
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/userId/{userId}/order", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject changeKanbanOrder(@PathVariable Long projectId, @PathVariable String userId,
			HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/projects/" + projectId + "/userId/" + userId + "/order] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			String orderStatus = request.getParameter("orderStatus");
			String kanbanOrder = ezPMSService.getKanbanOrder(projectId, userId, tenantId);

			if (kanbanOrder == null || kanbanOrder.equals("")) {
				// 기존 변경이 없었을 경우에는 DB에 추가
				ezPMSService.addKanbanOrder(projectId, userId, orderStatus, tenantId);
			} else if (!kanbanOrder.equals(orderStatus)) {
				// 기존 변경이 있었을 경우에는 DB에 수정
				ezPMSService.changeKanbanOrder(projectId, userId, orderStatus, tenantId);
			}

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/projects/" + projectId + "/userId/" + userId + "/order] ended.");
		return result;
	}

	/**
	 * 프로젝트 즐겨찾기 추가
	 * 
	 * @param userId
	 * @param projectId
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/userId/{userId}/favorites/{projectId}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject addFavoriteProject(@PathVariable String userId, @PathVariable String projectId,
			HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/userId/" + userId + "/favorites/" + projectId + "] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);

			String[] projectIdList = projectId.split("_");
			int addResult = 0;

			if (projectIdList.length == 1) {
				addResult = ezPMSService.addFavoriteProject(Long.parseLong(projectIdList[0]), userId,
						info.getTenantId());
			} else {
				for (int i = 0; i < projectIdList.length; i++) {
					ezPMSService.addFavoriteProject(Long.parseLong(projectIdList[i]), userId, info.getTenantId());
				}
				addResult = 0;
			}

			LOGGER.debug("addFavoriteResult : " + addResult);
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", addResult);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/userId/" + userId + "/favorites/" + projectId + "] ended.");
		return result;
	}

	/**
	 * 프로젝트 즐겨찾기 해제
	 * 
	 * @param userId
	 * @param projectId
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/userId/{userId}/favorites/{projectId}", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject deleteFavoriteProject(@PathVariable String userId, @PathVariable String projectId,
			HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/userId/" + userId + "/favorites/" + projectId + "] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);

			String[] projectIdList = projectId.split("_");

			for (int i = 0; i < projectIdList.length; i++) {
				ezPMSService.deleteFavoriteProject(Long.parseLong(projectIdList[i]), userId, info.getTenantId());
			}

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/userId/" + userId + "/favorites/" + projectId + "] ended.");
		return result;
	}

	/**
	 * 프로젝트 작업이력 추가
	 * 
	 * @param projectId
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/logs", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject addTaskLog(@PathVariable long projectId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/projects/" + projectId + "/logs] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			int tenantId = info.getTenantId();
			String userId = request.getParameter("userId");
			String userName = info.getUserName();
			String userName2 = info.getUserName2();
			String userDeptname = info.getDeptName();
			String userDeptname2 = info.getDeptName2();

			TaskLogListVO taskLog = new TaskLogListVO();
			taskLog.setUserId(userId);
			taskLog.setUserName(userName);
			taskLog.setUserName2(userName2);
			taskLog.setUserDeptname(userDeptname);
			taskLog.setUserDeptname2(userDeptname2);
			taskLog.setTenantId(tenantId);
			taskLog.setProjectId(projectId);
			taskLog.setLogStatus(Integer.parseInt(request.getParameter("logStatus")));
			taskLog.setLogContent(request.getParameter("logContent"));
			taskLog.setLogDate(request.getParameter("logDate"));

			if (!request.getParameter("groupId").equals("") && request.getParameter("groupId") != null) {
				taskLog.setGroupId(Long.parseLong(request.getParameter("groupId")));
			}

			if (!request.getParameter("taskId").equals("") && request.getParameter("taskId") != null) {
				taskLog.setTaskId(Long.parseLong(request.getParameter("taskId")));
			}

			ezPMSService.addTaskLog(taskLog, tenantId, userId);

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/projects/" + projectId + "/logs] ended.");
		return result;
	}

	/**
	 * 프로젝트 작업이력 리스트 호출
	 * 
	 * @param projectId
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/logs", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getTaskLogList(@PathVariable Long projectId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/logs] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			String searchByContent = request.getParameter("searchByContent");

			// 검색을 위한 search 파라미터
			Map<String, Object> search = new HashMap<>();
			search.put("location", request.getParameter("location"));
			search.put("startCount", request.getParameter("startCount"));
			search.put("listNumber", request.getParameter("listNumber"));
			search.put("taskId", request.getParameter("taskId"));
			search.put("groupId", request.getParameter("groupId"));
			search.put("searchByStatus", request.getParameter("searchByStatus"));

			//header 정렬 프로젝트 순서
			if (request.getParameter("orderWhat") == null || request.getParameter("orderWhat").equals("")) {
				search.put("orderWhat", "init");
			} else {
				search.put("orderWhat", request.getParameter("orderWhat"));
			}
			
			if (request.getParameter("orderHow") == null || request.getParameter("orderHow").equals("")) {
				search.put("orderHow", "asc");
			} else {
				search.put("orderHow", request.getParameter("orderHow"));
			}
			
			if (searchByContent != null) {
				searchByContent = searchByContent.replace("\\", "\\\\");
				searchByContent = searchByContent.replace("%", "\\%");
				searchByContent = searchByContent.replace("_", "\\_");
			}

			search.put("searchByContent", searchByContent);

			List<TaskLogListVO> taskLogList = ezPMSService.getTaskLogList(projectId, search, info.getOffSet(), lang,
					info.getTenantId());
			JSONObject data = new JSONObject();
			data.put("taskLogList", taskLogList);

			if (request.getParameter("taskId") != null) {
				if (request.getParameter("taskId").equals("0")) {
					long groupId = Long.parseLong(request.getParameter("groupId"));
					ProjectGroupVO groupDetails = ezPMSService.getGroupDetails(groupId, info.getTenantId(), projectId);
					data.put("groupDetails", groupDetails);
					data.put("taskDetails", "{}");
				} else {
					long taskId = Long.parseLong(request.getParameter("taskId"));
					ProjectTaskVO taskDetails = ezPMSService.getTaskDetails(taskId, info.getTenantId(), lang);
					data.put("taskDetails", taskDetails);
					data.put("groupDetails", "{}");
				}
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/logs] ended.");
		return result;
	}

	/**
	 * 프로젝트 리스트 개수 호출
	 * 
	 * @param userId
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/userId/{userId}/count", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getProjectListCount(@PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/userId/" + userId + "/count] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			String searchByName = request.getParameter("searchByProjectName").toString();
			String searchByUser = request.getParameter("searchByUser").toString();
			String searchByOverview = request.getParameter("searchByOverview").toString();

			if (searchByName != null && !searchByName.equals("")) {
				searchByName = request.getParameter("searchByProjectName").toString();
				searchByName = searchByName.replace("\\", "\\\\");
				searchByName = searchByName.replace("%", "\\%");
				searchByName = searchByName.replace("_", "\\_");
			}

			if (searchByUser != null && !searchByUser.equals("")) {
				searchByUser = searchByUser.replace("\\", "\\\\");
				searchByUser = searchByUser.replace("%", "\\%");
				searchByUser = searchByUser.replace("_", "\\_");
			}

			if (searchByOverview != null && !searchByOverview.equals("")) {
				searchByOverview = searchByOverview.replace("\\", "\\\\");
				searchByOverview = searchByOverview.replace("%", "\\%");
				searchByOverview = searchByOverview.replace("_", "\\_");
			}

			ProjectInfoVO project = new ProjectInfoVO();
			project.setStatus(request.getParameter("listProjectStatus"));
			project.setProjectName(searchByName);
			project.setPlanStartDate(request.getParameter("searchByStartDate"));
			project.setPlanEndDate(request.getParameter("searchByEndDate"));
			project.setOverview(searchByOverview);
			project.setHeadManagerName(searchByUser);

			String deptId = info.getDeptId();

			LOGGER.debug("status : " + project.getStatus() + ", deptId : " + deptId);
			int projectListCount;

			// admin 파라미터는 관리자모드에서만 넘어온다. 이 때 userId를 ""로 넘겨서 모든 프로젝트 검색이 가능하도록
			// 한다.
			if (request.getParameter("admin") != null && request.getParameter("admin").equals("true")) {
				projectListCount = ezPMSService.getProjectListCount(project, info.getTenantId(), "", deptId, lang,
						request.getParameter("position"));
			} else {
				projectListCount = ezPMSService.getProjectListCount(project, info.getTenantId(), userId, deptId, lang,
						request.getParameter("position"));
			}

			LOGGER.debug("projectListCount : " + projectListCount);

			JSONObject data = new JSONObject();
			data.put("projectListCount", projectListCount);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/userId/" + userId + "/count] ended.");
		return result;
	}

	/**
	 * 프로젝트 업무 개수 호출
	 * 
	 * @param projectId
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/tasks/count", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getTaskListCount(@PathVariable Long projectId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/tasks/count] started.");

		JSONObject result = new JSONObject();

		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String status = request.getParameter("status");
			String isMyTask = request.getParameter("isMyTask");
			String deptId = info.getDeptId();
			long groupId = 0;
			int roleId = 0;

			if (projectId != 0) {
				roleId = ezPMSService.getUserProjectRole(userId, info.getTenantId(), projectId, info.getDeptId());
			}

			LOGGER.debug("roleId : " + roleId);

			if (request.getParameter("groupId") != null) {
				groupId = Long.parseLong(request.getParameter("groupId"));
			}

			SearchVO search = new SearchVO();
			search.setTenantId(info.getTenantId());
			search.setStatus(status);
			search.setIsMyTask(isMyTask);
			search.setProjectId(projectId);
			search.setGroupId(groupId);
			search.setUpperGroupName(request.getParameter("searchByUpperGroupName"));
			search.setPlanStartDate(request.getParameter("searchByStartDate"));
			search.setPlanEndDate(request.getParameter("searchByEndDate"));
			search.setOverview(request.getParameter("searchByOverview"));
			search.setMemberName(request.getParameter("searchByUser"));
			search.setProjectName(request.getParameter("searchByProjectName"));
			search.setTaskName(request.getParameter("searchByTaskName"));

			int taskListCount = ezPMSService.getTaskListCount(search, userId, roleId, deptId);

			LOGGER.debug("taskListCount : " + taskListCount);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", taskListCount);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/tasks/count] ended.");
		return result;
	}

	/**
	 * 프로젝트 작업이력 개수 호출
	 * 
	 * @param projectId
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/logs/count", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getTaskLogListCount(@PathVariable long projectId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/tasks/count] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));

			TaskLogListVO taskLog = new TaskLogListVO();
			taskLog.setProjectId(projectId);

			String searchByContent = request.getParameter("searchByContent");

			if (searchByContent != null) {
				searchByContent = searchByContent.replace("\\", "\\\\");
				searchByContent = searchByContent.replace("%", "\\%");
				searchByContent = searchByContent.replace("_", "\\_");
			}

			taskLog.setLogContent(searchByContent);

			if (!request.getParameter("searchByStatus").equals("") && request.getParameter("searchByStatus") != null) {
				taskLog.setLogStatus(Integer.parseInt(request.getParameter("searchByStatus")));
			}

			if (!request.getParameter("groupId").equals("") && request.getParameter("groupId") != null) {
				taskLog.setGroupId(Long.parseLong(request.getParameter("groupId")));
			}

			if (!request.getParameter("taskId").equals("") && request.getParameter("taskId") != null) {
				taskLog.setTaskId(Long.parseLong(request.getParameter("taskId")));
			}

			int taskLogListCount = ezPMSService.getTaskLogListCount(taskLog, info.getTenantId());

			JSONObject data = new JSONObject();
			data.put("taskLogListCount", taskLogListCount);

			LOGGER.debug("taskLogListCount : " + taskLogListCount);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/logs/count] ended.");
		return result;
	}

	/**
	 * 역할별 멤버 수 호출
	 * 
	 * @param projectId
	 * @param roleId
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/roles/{roleId}/count", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getMemberCount(@PathVariable Long projectId, @PathVariable int roleId, HttpServletRequest request)
			throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/roles/" + roleId + "/count] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));

			int memberCount = ezPMSService.getMemberCount(projectId, roleId, info.getTenantId());

			JSONObject data = new JSONObject();
			data.put("memberCount", memberCount);

			LOGGER.debug("memberCount : " + memberCount);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/roles/" + roleId + "/count] ended.");
		return result;
	}

	/**
	 * 나의 업무 : 담당그룹 개수 호출
	 * 
	 * @param userId
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/users/{userId}/groups/count", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getGroupCount(@PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/users/" + userId + "/groups/count] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);

			SearchVO search = new SearchVO();
			search.setGroupName(request.getParameter("searchByGroupName"));
			search.setUpperGroupName(request.getParameter("searchByUpperGroupName"));
			search.setMemberName(request.getParameter("searchByUser"));
			search.setProjectName(request.getParameter("searchByProjectName"));
			search.setOverview(request.getParameter("searchByOverview"));
			search.setPlanStartDate(request.getParameter("searchByStartDate"));
			search.setPlanEndDate(request.getParameter("searchByEndDate"));

			int groupCount = ezPMSService.getGroupCount(search, info.getTenantId(), userId);

			LOGGER.debug("groupCount : " + groupCount);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", groupCount);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/users/" + userId + "/groups/count] ended.");
		return result;
	}

	// 공통 부분 API
	/**
	 * 프로젝트관리 G/W [GET] 회사리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/companies", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
	public JSONObject getCompanyList(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/companies] started.");

		JSONObject result = new JSONObject();

		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = request.getParameter("companyId");
			if (companyId == null || companyId.equals("")) {
				companyId = info.getCompanyId();
			}
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			List<ProjectCompanyVO> compList = ezPMSService.getCompanyList(userId, info.getTenantId(), companyId, lang);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", compList);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/companies] ended.");
		return result;
	}

	/**
	 * 프로젝트관리 G/W [GET] 부서리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/depts", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
	public JSONObject getDeptList(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/depts] started.");

		JSONObject result = new JSONObject();

		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);

			LOGGER.debug("userId : " + userId);
			String companyId = request.getParameter("companyId");

			if (companyId == null || companyId.equals("")) {
				companyId = info.getCompanyId();
			}
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			List<DeptViewVO> deptList = ezPMSService.getDeptViewList(userId, companyId, info.getTenantId(), lang);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", deptList);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/depts] started.");
		return result;
	}

	/**
	 * 프로젝트관리 G/W [GET] 사원리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/users", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
	public JSONObject getUserList(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/users] started.");

		JSONObject result = new JSONObject();

		try {
			String key = request.getParameter("key");
			String value = request.getParameter("value");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			int tenantId = info.getTenantId();

			List<ProjectUserVO> userList = ezPMSService.getDeptUserList(info.getTenantId(), key, value, lang);

			for (ProjectUserVO member : userList) {
				String imagePath = ezOrganService.getPropertyValue(member.getUserId(), "extensionAttribute2", tenantId);

				if (imagePath != null && !imagePath.equals("")) {
					String realPath = commonUtil.getUploadPath("upload_personal.PHOTO", tenantId) + commonUtil.separator
							+ imagePath;
					String fullPath = request.getServletContext().getRealPath(realPath);

					if (fullPath != null || !fullPath.equals("")) {
						member.setUserImg(imagePath);
					} else {
						member.setUserImg("/images/poll/default_pic_vote.gif");
					}
				} else {
					member.setUserImg("/images/poll/default_pic_vote.gif");
				}
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", userList);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/users] started.");
		return result;
	}

	/**
	 * 프로젝트관리 G/W [GET] 총괄담당자 후보 정보 호출 (부서까지)
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/list/users", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	public JSONObject getHeadManagerList(@RequestBody JSONObject json, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/list/users] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			int tenantId = info.getTenantId();
			List<Map<String, Object>> userList = (List<Map<String, Object>>) json.get("userList");

			List<ProjectUserVO> managerList = new ArrayList<ProjectUserVO>();

			for (int i = 0; i < userList.size(); i++) {
				if (userList.get(i).get("userIdType").equals("user")) {
					String userId = userList.get(i).get("userId").toString();
					List<ProjectUserVO> memberList = ezPMSService.getDeptUserList(tenantId, "CN", userId, lang);

					for (ProjectUserVO member : memberList) {
						if (!managerList.contains(member)) {
							managerList.add(member);
						}
					}
				} else {
					String userId = userList.get(i).get("userId").toString();
					List<ProjectUserVO> deptUserList = ezPMSService.getDeptUserList(tenantId, "DEPARTMENT", userId,
							lang);

					for (ProjectUserVO member : deptUserList) {
						if (!managerList.contains(member)) {
							managerList.add(member);
						}
					}
				}
			}

			for (ProjectUserVO member : managerList) {
				String imagePath = ezOrganService.getPropertyValue(member.getUserId(), "extensionAttribute2", tenantId);

				if (imagePath != null && !imagePath.equals("")) {
					String realPath = commonUtil.getUploadPath("upload_personal.PHOTO", tenantId) + commonUtil.separator
							+ imagePath;
					String fullPath = request.getServletContext().getRealPath(realPath);

					if (fullPath != null || !fullPath.equals("")) {
						member.setUserImg("/ezCommon/downloadAttach.do?filePath=" + realPath);
					} else {
						member.setUserImg("/images/poll/default_pic_vote.gif");
					}
				} else {
					member.setUserImg("/images/poll/default_pic_vote.gif");
				}
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", managerList);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/list/users] ended.");
		return result;
	}

	/**
	 * 프로젝트 업무 삭제
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/tasks/{taskId}/users/{userId}", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject deleteTask(@PathVariable String taskId, @PathVariable String userId, HttpServletRequest request)
			throws Exception {
		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/tasks/" + taskId + "/users/" + userId + "] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String[] taskIdList = taskId.split("_");
			int tenantId = info.getTenantId();
			String deptId = info.getDeptId();
			long projectId = Long.parseLong(request.getParameter("projectId"));
			String companyId = request.getParameter("companyId");
			String roleCheck = "";
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());

			// 권한 체크
			// 1. 프로젝트의 담당자인지 아닌지 확인 (여러개 있을 때, 하나라도 들어가있으면 return)
			int userProjectRole = ezPMSService.getUserProjectRole(userId, tenantId, projectId, deptId);
			if (userProjectRole == 1) {
				roleCheck = "permitted";
			} else if (userProjectRole == 3) {
				// 프로젝트 조회자는 열람권한밖에 없음
				roleCheck = "rejected";
			} else {
				// 2. task의 담당자인지 확인
				for (int i = 0; i < taskIdList.length; i++) {
					String userTaskRole = ezPMSService.getUserTaskRole(userId, tenantId, Long.parseLong(taskIdList[i]));

					if (userTaskRole == null) {
						roleCheck = "rejected";
						break;
					}
				}

				if (roleCheck.equals("")) {
					roleCheck = "permitted";
				}
			}

			LOGGER.debug("DELETETASK ROLECHECK : " + roleCheck);

			if (roleCheck.equals("permitted")) {
				for (int i = 0; i < taskIdList.length; i++) {
					// 삭제
					ezPMSService.deleteTask(Long.parseLong(taskIdList[i]), projectId, tenantId, companyId, lang);

					// 해당 task관련 삭제
//					ezPMSService.deleteMemberSchedule(null, projectId, tenantId, null, Long.parseLong(taskIdList[i]));
				}
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", roleCheck);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/tasks/" + taskId + "/users/" + userId + "] ended.");
		return result;
	}

	/**
	 * file path 불러오기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/items/{itemId}/files", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getFilePath(@PathVariable long itemId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/items/" + itemId + "/files] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String filePath = "";
			String imageFileType = "PNG,JPEG,BMP,GIF,JPG";

			List<Map<String, Object>> filePathList = ezPMSService.getFilePath(itemId, info.getTenantId());

			for (int i = 0; i < filePathList.size(); i++) {
				String fileName = filePathList.get(i).get("fileName").toString();
				fileName = fileName.substring(fileName.indexOf("."), fileName.length());

				if (fileName.contains(imageFileType)) {
					filePath = filePathList.get(i).get("filePath").toString();
					break;
				}
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", filePath);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/items/" + itemId + "/files] ended.");
		return result;
	}

	/**
	 * 현재 사용자의 프로젝트 관련 역할(권한) 호출
	 * 
	 * @param projectId
	 * @param userId
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/users/{userId}/role", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getUserProjectRole(@PathVariable Long projectId, @PathVariable String userId,
			HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/users/" + userId + "/role] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			int userRole = ezPMSService.getUserProjectRole(userId, tenantId, projectId, info.getDeptId());

			LOGGER.debug("userRole : " + userRole);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", userRole);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/users/" + userId + "/role] ended.");
		return result;
	}

	/**
	 * 간트차트 업무 선행작업 지정
	 * 
	 * @param taskId
	 * @param preTaskId
	 * @param type
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/tasks/{taskId}/preTasks/{preTaskId}/type/{type}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject addPreTaskRel(@PathVariable long taskId, @PathVariable int preTaskId, @PathVariable String type,
			HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/tasks/" + taskId + "/preTasks/" + preTaskId + "/type/" + type
				+ "] started.");

		JSONObject result = new JSONObject();

		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			int tenantId = info.getTenantId();
			String roleCheck = "";
			long projectId = Long.parseLong(request.getParameter("projectId"));
			String companyId = info.getCompanyId();

			// 권한 체크
			// 1. 프로젝트의 담당자인지 아닌지 확인 (여러개 있을 때, 하나라도 들어가있으면 return)
			int userProjectRole = ezPMSService.getUserProjectRole(userId, tenantId, projectId, info.getDeptId());
			if (userProjectRole == 1) {
				roleCheck = "permitted";
			} else {
				roleCheck = "rejected";
			}

			if (roleCheck.equals("permitted")) {
				// preTaskRel 테이블에 데이터 추가
				ezPMSService.addPreTaskRel(taskId, preTaskId, projectId, tenantId, type);
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", roleCheck);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug(
				"ezPMS G/W [GET /rest/ezPMS/tasks/" + taskId + "/preTasks/" + preTaskId + "/type/" + type + "] ended.");
		return result;
	}

	/**
	 * 간트차트 업무 순서 변경
	 * 
	 * @param projectId
	 * @param request
	 * @param json
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/project/{projectId}/gantt/order", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject changeGanttOrder(@PathVariable long projectId, HttpServletRequest request,
			@RequestBody JSONObject json) throws Exception {
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/project/" + projectId + "/gantt/order] started.");

		JSONObject result = new JSONObject();

		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			int tenantId = info.getTenantId();
			String roleCheck = "permitted";

			// 권한 체크
			// 1. 프로젝트의 담당자인지 아닌지 확인 (여러개 있을 때, 하나라도 들어가있으면 return)
			int userProjectRole = ezPMSService.getUserProjectRole(userId, tenantId, projectId, info.getDeptId());
			if (userProjectRole == 1) {
				roleCheck = "permitted";
			} else {
				// 프로젝트 조회자는 열람권한밖에 없음
				// 참여자는 간트 조정 불가
				roleCheck = "rejected";
			}

			LOGGER.debug("changeganttorder ROLECHECK : " + roleCheck);

			if (roleCheck.equals("permitted")) {
				// 순서 변경된 taskId의 groupId변경 (groupId가 -1이면 변경 X)
				long toGroupId = Long.parseLong(request.getParameter("toGroupId"));
				long fromGroupId = Long.parseLong(request.getParameter("fromGroupId"));

				if (toGroupId != -1) {
					long targetTaskId = Long.parseLong(request.getParameter("targetTaskId"));
					int treeDepth = Integer.parseInt(request.getParameter("treeDepth"));
					ezPMSService.updateTaskGroupId(projectId, targetTaskId, toGroupId, fromGroupId, tenantId,
							treeDepth, lang);
				}

				// 그룹 순서 변경
				List<Map<String, Object>> groupList = (List<Map<String, Object>>) json.get("groupList");

				for (int i = 0; i < groupList.size(); i++) {
					long groupId = Long.parseLong(groupList.get(i).get("groupId").toString());
					int sortOrder = Integer.parseInt(groupList.get(i).get("order").toString());

					ezPMSService.updateGroupSort(projectId, groupId, sortOrder, tenantId);
				}

				// task 순서 변경
				List<Map<String, Object>> taskList = (List<Map<String, Object>>) json.get("taskList");

				for (int i = 0; i < taskList.size(); i++) {
					long groupId = Long.parseLong(taskList.get(i).get("groupId").toString());
					int sortOrder = Integer.parseInt(taskList.get(i).get("order").toString());
					long taskId = Long.parseLong(taskList.get(i).get("taskId").toString());
					int preTaskIndex = Integer.parseInt(taskList.get(i).get("depends").toString());

					ezPMSService.updateTaskSort(groupId, taskId, sortOrder, tenantId);

					// if (preTaskIndex != -1) {
					// ezPMSService.updatePreTaskRel(taskId, preTaskIndex,
					// tenantId, projectId);
					// }
				}
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", roleCheck);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/project/" + projectId + "/gantt/order] ended.");
		return result;
	}

	/**
	 * 인력관리 관련 멤버별 스케쥴 호출
	 * 
	 * @param projectId
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/management/members", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getMemberSchedule(@PathVariable long projectId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/management/members] started.");

		JSONObject result = new JSONObject();

		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			String companyId = info.getCompanyId();

			ProjectInfoVO project = ezPMSService.getProjectDetails(projectId, userId, tenantId, "gantt", lang,
					info.getDeptId(), info.getCompanyId());
			String planStartDate = project.getPlanStartDate();
			String planEndDate = project.getPlanEndDate();
			List<ProjectMemberVO> memberList = project.getProjectMember();
			List<ProjectMemberScheduleVO> memberScheduleList = ezPMSService.getMemberSchedule(projectId, tenantId,
					lang, companyId, planStartDate, planEndDate);

			DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
			Date startDate = dateFormat.parse(planStartDate);
			Date endDate = dateFormat.parse(planEndDate);

			Calendar startCal = Calendar.getInstance();
			Calendar endCal = Calendar.getInstance();

			startCal.setTime(startDate);
			endCal.setTime(endDate);
			
			// 공휴일 리스트를 가져와서 Calendar클래스로 변환
			Set<String> holidayList = ezPMSService.getHolidayList(planStartDate, planEndDate, tenantId, companyId, lang);
			Set<Calendar> holidaySet = new HashSet<Calendar>();
			
			holidayList.forEach(holiday -> {
				try {
					Calendar cal = new GregorianCalendar();
					cal.setTime(dateFormat.parse(holiday));
					holidaySet.add(cal);
				} catch (Exception e) {
					e.printStackTrace();
				}
			});
			
			List<DateVO> dateList = new ArrayList<DateVO>();

			while (startCal.compareTo(endCal) < 1) {
				DateVO date = new DateVO();
				date.setDate(dateFormat.format(startCal.getTime()));
				
				// 휴일 여부를 판단
				if(startCal.get(Calendar.DAY_OF_WEEK) != 1 && startCal.get(Calendar.DAY_OF_WEEK) != 7 && !holidaySet.contains(startCal)) {
					date.setHolidayOrNot(false);
				} else {
					date.setHolidayOrNot(true);
				}
				
				dateList.add(date);
				startCal.add(Calendar.DATE, 1);
			}

			JSONObject data = new JSONObject();
			data.put("planStartDate", planStartDate);
			data.put("planEndDate", planEndDate);
			data.put("memberList", memberList);
			data.put("memberScheduleList", memberScheduleList);
			data.put("dateList", dateList);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/project/" + projectId + "/management/members] ended.");
		return result;
	}

	/**
	 * 날짜별 해당 사용자의 업무 리스트 호출
	 * 
	 * @param projectId
	 * @param date
	 * @param selUserId
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/dates/{date}/users/{selUserId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getDateTaskList(@PathVariable long projectId, @PathVariable String date,
			@PathVariable String selUserId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/project/" + projectId + "/dates/" + date + "/users/" + selUserId
				+ "] started.");

		JSONObject result = new JSONObject();

		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());

			List<String> taskList = ezPMSService.getDateTaskList(projectId, date, selUserId, lang, tenantId);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", taskList);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/project/" + projectId + "/dates/" + date + "/users/" + selUserId
				+ "] ended.");
		return result;
	}

	// 홍대표 작성
	/**
	 * 프로젝트관리 업무 리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/task-list/{projectId}/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getTaskList(@PathVariable long projectId, @PathVariable String userId, HttpServletRequest request)
			throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/task-list/" + projectId + "/users/" + userId + "] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			String isMyTask = request.getParameter("isMyTask") == null ? "A" : request.getParameter("isMyTask");
			int tenantId = info.getTenantId();
			int limit = 0;
			int startRow = 0;
			String orderWhat = request.getParameter("orderWhat");
			String orderHow = request.getParameter("orderHow");
			String position = request.getParameter("position");
			String companyId = info.getCompanyId();
			String deptId = info.getDeptId();
			int roleId = 0;
			long groupId = 0;

			if (projectId != 0) {
				roleId = ezPMSService.getUserProjectRole(userId, tenantId, projectId, info.getDeptId());
			}

			if (orderWhat == null) {
				orderWhat = "init";
			}

			if (request.getParameter("limit") != null) {
				limit = Integer.parseInt(request.getParameter("limit"));
			}

			if (request.getParameter("startRow") != null) {
				startRow = Integer.parseInt(request.getParameter("startRow"));
			}

			SearchVO search = new SearchVO();
			search.setTenantId(info.getTenantId());
			search.setProjectId(projectId);
			search.setStatus(request.getParameter("status"));

			if (request.getParameter("groupId") != null) {
				groupId = Long.parseLong(request.getParameter("groupId"));
				search.setGroupId(groupId);

			} else {
				groupId = 0;
				search.setGroupId(groupId);
			}

			search.setMemberId(request.getParameter("headManagerName"));
			search.setIsMyTask(isMyTask);
			search.setTenantId(tenantId);

			// 추가
			search.setTaskName(request.getParameter("searchByTaskName"));
			search.setMemberName(request.getParameter("searchByUser"));
			search.setPlanStartDate(request.getParameter("searchByStartDate"));
			search.setPlanEndDate(request.getParameter("searchByEndDate"));
			search.setUpperGroupName(request.getParameter("searchByUpperGroupName"));
			search.setOverview(request.getParameter("searchByOverview"));
			search.setProjectName(request.getParameter("searchByProjectName"));

			List<ProjectTaskVO> taskList = new ArrayList<ProjectTaskVO>();
			taskList = ezPMSService.getTaskList(search, userId, limit, startRow, orderWhat, orderHow, position, roleId,
					deptId);

			for (int i = 0; i < taskList.size(); i++) {
				Date startDate = new SimpleDateFormat("yyyy-MM-dd").parse(taskList.get(i).getPlanStartDate());
				Date endDate = new SimpleDateFormat("yyyy-MM-dd").parse(taskList.get(i).getPlanEndDate());
				Date today = new Date();
				String simpToday = new SimpleDateFormat("yyyy-MM-dd").format(today);
				Date now = new SimpleDateFormat("yyyy-MM-dd").parse(simpToday);

				int restDueday = ezPMSService.getWorkingDays(now, endDate, companyId, tenantId, lang);
				taskList.get(i).setRestDueday(restDueday);
				taskList.get(i).setPlanProgress(ezPMSService.getPlanProgress(startDate, endDate, companyId, tenantId, lang));
				taskList.get(i).setTaskMember(
						ezPMSService.getTaskMemberList(info.getTenantId(), taskList.get(i).getTaskId(), lang));
			}

			if (request.getParameter("position") == null || !request.getParameter("position").equals("gantt")) {
				if (roleId != 3 && roleId != 1 && roleId != 0 && groupId != 0) {
					// upperGroupId가 0이아닌 상위 그룹이 있다면 담당자인지
					long upperGroupId = ezPMSService.getUpperGroupId(groupId, projectId, tenantId);

					if (upperGroupId != 0) {
						// 해당 그룹의 담당자인지 해당 그룹에 해당이 안되면 roleId는 참여자(2)
						roleId = ezPMSService.getUserGroupRole(userId, tenantId, projectId, groupId);

						if (roleId != 1) {
							roleId = ezPMSService.getUserGroupRole(userId, tenantId, projectId, upperGroupId);
						}
					}
				}
			}

			JSONObject data = new JSONObject();
			data.put("taskList", taskList);
			data.put("userRoleId", roleId);

			if (groupId != 0) {
				// 그룹정보 불러오기
				ProjectGroupVO groupDetail = ezPMSService.getGroupDetails(groupId, tenantId, projectId);
				data.put("groupDetail", groupDetail);
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/task-list/" + projectId + "/users/" + userId + "] ended.");
		return result;
	}

	/**
	 * 프로젝트관리 업무 등록
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/tasks/{projectId}/users/{userId}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject addTask(@PathVariable String projectId, @PathVariable String userId, HttpServletRequest request,
			@RequestBody JSONObject jsonParam) throws Exception {
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/tasks/" + projectId + "/users/" + userId + "] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = info.getCompanyId();
			int tenantId = info.getTenantId();
			String planStartDate = request.getParameter("planStartDate");
			String planEndDate = request.getParameter("planEndDate");
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());

			List<Map<String, Object>> taskMemberList1 = (List<Map<String, Object>>) jsonParam.get("managerList");
			List<TaskMemberVO> taskMemberList2 = new ArrayList<TaskMemberVO>();

			for (int i = 0; i < taskMemberList1.size(); i++) {
				String taskMemberId = (String) taskMemberList1.get(i).get("userId");
				Float pctinput = Float.parseFloat((String) taskMemberList1.get(i).get("pctinput"));

				TaskMemberVO taskMemberVO = new TaskMemberVO();
				taskMemberVO.setTenantId(tenantId);
				taskMemberVO.setUserId(taskMemberId);
				taskMemberVO.setPctinput(pctinput);

				ProjectMemberVO member = ezPMSService.getUserInfo(taskMemberId, tenantId, "user");

				taskMemberVO.setUserName(member.getUserName());
				taskMemberVO.setUserName2(member.getUserName2());
				taskMemberVO.setUserDeptname(member.getUserDeptname());
				taskMemberVO.setUserDeptname2(member.getUserDeptname2());

				taskMemberList2.add(taskMemberVO);
			}

			ProjectTaskVO projectTaskVO = new ProjectTaskVO();
			projectTaskVO.setTenantId(Integer.parseInt(request.getParameter("tenantId")));
			projectTaskVO.setProjectId(Long.parseLong(projectId));
			projectTaskVO.setGroupId(Long.parseLong(request.getParameter("groupId")));
			projectTaskVO.setTaskName(request.getParameter("taskName"));
			projectTaskVO.setPlanStartDate(planStartDate);
			projectTaskVO.setPlanEndDate(planEndDate);
			projectTaskVO.setWeight(Float.parseFloat(request.getParameter("weight")));
			projectTaskVO.setOverview(request.getParameter("overview"));
			projectTaskVO.setHeadManagerId(request.getParameter("headManagerId"));
			projectTaskVO.setWriterId(request.getParameter("writerId"));
			projectTaskVO.setWriteDate(request.getParameter("writeDate"));
			projectTaskVO.setWriterName(request.getParameter("writerName"));
			projectTaskVO.setWriterName2(request.getParameter("writerName2"));
			projectTaskVO.setWriterDeptname(request.getParameter("writerDeptname"));
			projectTaskVO.setWriterDeptname2(request.getParameter("writerDeptname2"));
			projectTaskVO.setTreeDepth(Integer.parseInt(request.getParameter("treeDepth")));

			long taskId = ezPMSService.addTask(projectTaskVO, taskMemberList2, companyId, tenantId, lang);

//			DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
//			Date startDate = dateFormat.parse(planStartDate);
//			Date endDate = dateFormat.parse(planEndDate);
//
//			Calendar startCal = Calendar.getInstance();
//			Calendar endCal = Calendar.getInstance();
//
//			startCal.setTime(startDate);
//			endCal.setTime(endDate);
//
//			List<String> dateList = new ArrayList<String>();
//
//			while (startCal.compareTo(endCal) != 1) {
//				if (startCal.get(Calendar.DAY_OF_WEEK) == 1 || startCal.get(Calendar.DAY_OF_WEEK) == 7) {
//					startCal.add(Calendar.DATE, 1);
//				} else {
//					dateList.add(dateFormat.format(startCal.getTime()));
//					startCal.add(Calendar.DATE, 1);
//				}
//			}
			List<String> dateList = ezPMSService.getDateList(planStartDate, planEndDate);

//			for (int i = 0; i < taskMemberList2.size(); i++) {
//				String memberId = taskMemberList2.get(i).getUserId();
//				LOGGER.debug(memberId);
//				for (int j = 0; j < dateList.size(); j++) {
//					ezPMSService.addMemberSchedule(memberId, tenantId, dateList.get(j), Long.parseLong(projectId),
//							taskId);
//				}
//			}

			// 프로젝트 완료시 추가된 업무가 있으면 프로젝트 상태 수정
			if (!request.getParameter("projectChangeDate").equals("")) {
				String projectStatus = request.getParameter("projectStatus");
				String projectPlanEndDate = request.getParameter("projectPlanEndDate");
				String projectChangeDate = request.getParameter("projectChangeDate");

				ProjectInfoVO project = new ProjectInfoVO();
				project.setProjectId(Long.parseLong(projectId));
				project.setPlanEndDate(projectChangeDate);

				ProjectInfoVO projectDetails = ezPMSService.getProjectDetails(Long.parseLong(projectId), userId,
						tenantId, null, lang, info.getDeptId(), info.getCompanyId());
				ezPMSService.updateProjectStatus(Long.parseLong(projectId), projectStatus, tenantId, projectPlanEndDate,
						projectChangeDate);
				ezPMSService.updateProject(project, tenantId, companyId, lang);
				ezPMSService.updateProjectGroupEndDate(Long.parseLong(projectId), projectChangeDate, tenantId,
						projectDetails.getGroupId());

			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", taskId + "");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "fail");
		}

		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/tasks/" + projectId + "/users/" + userId + "] ended.");
		return result;
	}

	/**
	 * 프로젝트관리 업무 상세보기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/tasks/{taskId}/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getTaskDetail(@PathVariable String taskId, @PathVariable String userId,
			HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/tasks/" + taskId + "/users/" + userId + "] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			long projectId = Long.parseLong(request.getParameter("projectId"));

			ProjectTaskVO taskVO = ezPMSService.getTaskDetails(Long.parseLong(taskId), info.getTenantId(), lang);
			Date startDate = new SimpleDateFormat("yyyy-MM-dd").parse(taskVO.getPlanStartDate());
			Date endDate = new SimpleDateFormat("yyyy-MM-dd").parse(taskVO.getPlanEndDate());

			taskVO.setTaskMember(ezPMSService.getTaskMemberList(info.getTenantId(), Long.parseLong(taskId), lang));
			taskVO.setPlanProgress(
					ezPMSService.getPlanProgress(startDate, endDate, info.getCompanyId(), info.getTenantId(), lang));

			long groupId = taskVO.getGroupId();
			int roleId = 0;

			// 권한 가져오기
			if (projectId != 0) {
				roleId = ezPMSService.getUserProjectRole(userId, info.getTenantId(), projectId, info.getDeptId());
			}

			if (roleId != 3 && roleId != 1 && roleId != 0 && groupId != 0) {
				// upperGroupId가 0이아닌 상위 그룹이 있다면 담당자인지
				long upperGroupId = ezPMSService.getUpperGroupId(groupId, projectId, info.getTenantId());

				if (upperGroupId != 0) {
					// 해당 그룹의 담당자인지 해당 그룹에 해당이 안되면 roleId는 참여자(2)
					roleId = ezPMSService.getUserGroupRole(userId, info.getTenantId(), projectId, groupId);

					if (roleId != 1) {
						roleId = ezPMSService.getUserGroupRole(userId, info.getTenantId(), projectId, upperGroupId);
					}
				}
			}

			// 해당 task의 담당자인지 확인
			if (roleId == 2) {
				String taskRoleId = ezPMSService.getUserTaskRole(userId, info.getTenantId(), Long.parseLong(taskId));

				if (taskRoleId != null) {
					roleId = 1;
				}
			}

			JSONObject data = new JSONObject();
			data.put("taskDetails", taskVO);
			data.put("userRoleId", roleId);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			e.printStackTrace();
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/tasks/" + taskId + "/users/" + userId + "] ended.");
		return result;
	}

	/**
	 * 프로젝트관리 업무 수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/tasks/{taskId}/users/{userId}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject updateTask(@PathVariable String taskId, @PathVariable String userId, HttpServletRequest request,
			@RequestBody JSONObject jsonParam) throws Exception {
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/tasks/" + taskId + "/users/" + userId + "] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			int tenantId = info.getTenantId();
			String companyId = info.getCompanyId();
			Long groupId = Long.parseLong(request.getParameter("groupId"));
			String projectId = request.getParameter("projectId");

			List<Map<String, Object>> taskMemberList1 = (List<Map<String, Object>>) jsonParam.get("managerList");
			List<TaskMemberVO> taskMemberList2 = new ArrayList<TaskMemberVO>();

			// 권한 체크
			String roleCheck = "";

			// 권한 체크
			// 1. 프로젝트의 담당자인지 아닌지 확인 (여러개 있을 때, 하나라도 들어가있으면 return)
			int userProjectRole = ezPMSService.getUserProjectRole(userId, tenantId, Long.parseLong(projectId),
					info.getDeptId());
			if (userProjectRole == 1) {
				roleCheck = "permitted";
			} else if (userProjectRole == 3) {
				// 프로젝트 조회자는 열람권한밖에 없음
				roleCheck = "rejected";
			} else {
				int userGroupRole = 0;

				// upperGroupId가 0이아닌 상위 그룹이 있다면 담당자인지
				long upperGroupId = ezPMSService.getUpperGroupId(groupId, Long.parseLong(projectId), tenantId);

				if (upperGroupId != 0) {
					// 해당 그룹의 담당자인지 해당 그룹에 해당이 안되면 roleId는 참여자(2)
					userGroupRole = ezPMSService.getUserGroupRole(userId, tenantId, Long.parseLong(projectId), groupId);

					if (userGroupRole != 1) {
						userGroupRole = ezPMSService.getUserGroupRole(userId, tenantId, Long.parseLong(projectId),
								upperGroupId);
					}
				}

				// userGroupRole이 2일때 업무 담당자인지도 확인
				if (userGroupRole == 2) {
					String taskRole = ezPMSService.getUserTaskRole(userId, tenantId, Long.parseLong(taskId));

					if (taskRole != null) {
						userGroupRole = 1;
					}
				}

				if (userGroupRole != 1) {
					roleCheck = "rejected";
				} else {
					roleCheck = "permitted";
				}
			}

			if (roleCheck.equals("permitted")) {

				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

				for (int i = 0; i < taskMemberList1.size(); i++) {
					String taskMemberId = (String) taskMemberList1.get(i).get("userId");
					Float pctinput = Float.parseFloat(taskMemberList1.get(i).get("pctinput").toString());

					TaskMemberVO taskMemberVO = new TaskMemberVO();
					taskMemberVO.setTenantId(tenantId);
					taskMemberVO.setUserId(taskMemberId);
					taskMemberVO.setPctinput(pctinput);

					ProjectMemberVO member = ezPMSService.getUserInfo(taskMemberId, tenantId, "user");

					taskMemberVO.setUserName(member.getUserName());
					taskMemberVO.setUserName2(member.getUserName2());
					taskMemberVO.setUserDeptname(member.getUserDeptname());
					taskMemberVO.setUserDeptname2(member.getUserDeptname2());

					taskMemberList2.add(taskMemberVO);
				}

				String pretaskType = request.getParameter("type");
				String pretaskId = request.getParameter("pretaskId");
				String planStartDate = request.getParameter("planStartDate");
				String planEndDate = request.getParameter("planEndDate");

				// 선행작업 수정 시 DB에 반영
				if (pretaskType != null && !pretaskType.equals("")) {

					Map<String, Object> map = new HashMap<String, Object>();
					map.put("tenantId", tenantId);
					map.put("taskId", taskId);
					map.put("pretaskId", pretaskId);
					map.put("type", pretaskType);

					if (pretaskType.equals("initPretask")) {
						ezPMSService.deletePreTaskRelInTask(map);
					} else {

						int pretaskRelCNT = ezPMSService.checkIfHasPreTaskRel(map);

						if (pretaskRelCNT > 0) {
							ezPMSService.updatePreTaskRel(map);
						} else {
							ezPMSService.addPreTaskRel(Long.parseLong(taskId), Integer.parseInt(pretaskId),
									Long.parseLong(projectId), tenantId, pretaskType);
						}

						int workingday = Integer.parseInt(request.getParameter("workingday"));

						if (pretaskType.equals("task2task")) {
							map.put("taskId", pretaskId);
							ProjectTaskVO pretaskVO = ezPMSService.getTaskSchedule(map);

							Date pretaskEndate = sdf.parse(pretaskVO.getPlanEndDate());
							Date newStartDate = ezPMSService.addWorkingDays(pretaskEndate, 1, companyId, tenantId);
							Date newEndDate = ezPMSService.addWorkingDays(newStartDate, workingday - 1, companyId,
									tenantId);

							planStartDate = sdf.format(newStartDate);
							planEndDate = sdf.format(newEndDate);
						} else if (pretaskType.equals("group2task")) {
							map.put("groupId", pretaskId);
							ProjectGroupVO pregroupVO = ezPMSService.getGroupSchedule(map);

							Date pregroupEndate = sdf.parse(pregroupVO.getPlanEndDate());
							Date newStartDate = ezPMSService.addWorkingDays(pregroupEndate, 1, companyId, tenantId);
							Date newEndDate = ezPMSService.addWorkingDays(newStartDate, workingday - 1, companyId,
									tenantId);

							planStartDate = sdf.format(newStartDate);
							planEndDate = sdf.format(newEndDate);
						}

						LOGGER.debug("By Pretask Change => planStartDate : " + planStartDate + ", planEndDate : "
								+ planEndDate);
					}
				}

				ProjectTaskVO projectTaskVO = new ProjectTaskVO();
				projectTaskVO.setTenantId(tenantId);
				projectTaskVO.setTaskId(Long.parseLong(request.getParameter("taskId")));
				projectTaskVO.setProjectId(Long.parseLong(request.getParameter("projectId")));
				projectTaskVO.setGroupId(Long.parseLong(request.getParameter("groupId")));
				projectTaskVO.setTaskName(request.getParameter("taskName"));
				projectTaskVO.setWeight(Float.parseFloat(request.getParameter("weight")));
				projectTaskVO.setOverview(request.getParameter("overview"));
				projectTaskVO.setHeadManagerId(request.getParameter("headManagerId"));
				projectTaskVO.setPlanStartDate(planStartDate);
				projectTaskVO.setPlanEndDate(planEndDate);
				projectTaskVO.setWriterId(request.getParameter("writerId"));
				projectTaskVO.setWriteDate(request.getParameter("writeDate"));
				projectTaskVO.setWriterName(request.getParameter("writerName"));
				projectTaskVO.setWriterName2(request.getParameter("writerName2"));
				projectTaskVO.setWriterDeptname(request.getParameter("writerDeptname"));
				projectTaskVO.setWriterDeptname2(request.getParameter("writerDeptname2"));
				projectTaskVO.setTaskMember(taskMemberList2);
				
				if(request.getParameter("treeDepth") != null) {
					projectTaskVO.setUpperTreeDepth(Integer.parseInt(request.getParameter("treeDepth")));
				}
				
				ezPMSService.updateTaskInfo(projectTaskVO, companyId, tenantId, lang);

				// taskId로 해당 date 삭제 후, 추가
//				ezPMSService.deleteMemberSchedule(null, Long.parseLong(projectId), tenantId, null,
//						Long.parseLong(taskId));

				Date startDate = sdf.parse(planStartDate);
				Date endDate = sdf.parse(planEndDate);

				Calendar startCal = Calendar.getInstance();
				Calendar endCal = Calendar.getInstance();

				startCal.setTime(startDate);
				endCal.setTime(endDate);

				List<String> dateList = new ArrayList<String>();

				while (startCal.compareTo(endCal) != 1) {
					if (startCal.get(Calendar.DAY_OF_WEEK) == 1 || startCal.get(Calendar.DAY_OF_WEEK) == 7) {
						startCal.add(Calendar.DATE, 1);
					} else {
						dateList.add(sdf.format(startCal.getTime()));
						startCal.add(Calendar.DATE, 1);
					}
				}

//				for (int i = 0; i < taskMemberList2.size(); i++) {
//					String memberId = taskMemberList2.get(i).getUserId();
//					LOGGER.debug(memberId);
//					for (int j = 0; j < dateList.size(); j++) {
//						ezPMSService.addMemberSchedule(memberId, tenantId, dateList.get(j), Long.parseLong(projectId),
//								Long.parseLong(taskId));
//					}
//				}

			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", roleCheck);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/tasks/" + taskId + "/users/" + userId + "] ended.");
		return result;
	}

	/**
	 * 프로젝트관리 그룹 리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/groups/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getGroupList(@PathVariable String projectId, @PathVariable String userId,
			HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/groups/users/" + userId + "] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);

			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			String orderWhat = request.getParameter("orderWhat");
			String orderHow = request.getParameter("orderHow");
			int startRow = Integer
					.parseInt(request.getParameter("startRow") != null ? request.getParameter("startRow") : "-1");
			int limit = Integer.parseInt(request.getParameter("limit") != null ? request.getParameter("limit") : "-1");
			String location = "general";

			if (orderWhat == null || orderWhat.equals("")) {
				orderWhat = "init";
			}

			SearchVO search = new SearchVO();
			search.setTenantId(info.getTenantId());
			search.setProjectId(Long.parseLong(projectId));
			search.setUpperGroupName(request.getParameter("searchByUpperGroupName"));
			search.setMemberName(request.getParameter("searchByUser"));
			search.setPlanStartDate(request.getParameter("searchByStartDate"));
			search.setPlanEndDate(request.getParameter("searchByEndDate"));
			search.setGroupName(request.getParameter("searchByGroupName"));
			search.setOverview(request.getParameter("searchByOverview"));
			search.setProjectName(request.getParameter("searchByProjectName"));
			search.setMemberId(userId);

			List<ProjectGroupVO> groupList = ezPMSService.getGroupList(search, orderWhat, orderHow, startRow, limit,
					lang, location);
			
			for(ProjectGroupVO vo : groupList) {
				vo.setGroupMember(ezPMSService.getGroupMemberList(vo.getProjectId(), info.getTenantId(), vo.getGroupId()));
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", groupList);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/groups/users/" + userId + "] ended.");
		return result;
	}

	/**
	 * 프로젝트관리 그룹 추가
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/groups/{projectId}/users/{userId}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject addGroup(@PathVariable String projectId, @PathVariable String userId, HttpServletRequest request,
			@RequestBody JSONObject jsonParam) throws Exception {
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/groups/" + projectId + "/users/" + userId + "] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = info.getCompanyId();
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			int tenantId = info.getTenantId();

			Map<String, Object> project = new HashMap<String, Object>();
			project.put("planStartDate", request.getParameter("planStartDate"));
			project.put("planEndDate", request.getParameter("planEndDate"));
			project.put("overview", request.getParameter("overview"));
			project.put("headManagerId", request.getParameter("headManagerId"));
			project.put("creatorId", userId);
			project.put("creatorName", info.getUserName());
			project.put("creatorName2", info.getUserName2());
			project.put("creatorDeptname", info.getDeptName());
			project.put("creatorDeptname2", info.getDeptName2());
			project.put("createDate", request.getParameter("createDate"));
			project.put("tenantId", info.getTenantId());

			project.put("treeDepth", request.getParameter("treeDepth"));
			project.put("ancesterGroup", "0");
			project.put("sortOrder", request.getParameter("sortOrder"));
			project.put("status", "W");

			if (request.getParameter("upperGroupId") == null) {
				project.put("upperGroupId", 0);
			} else {
				project.put("upperGroupId", request.getParameter("upperGroupId"));
			}

			// 수정해야함.
			project.put("progress", "0");

			List<Map<String, Object>> projectMemberList = (List<Map<String, Object>>) jsonParam.get("managerList");

			if (jsonParam.get("participantList") != null) {
				projectMemberList.addAll((List<Map<String, Object>>) jsonParam.get("participantList"));
			}

			// projectMemberList.addAll((List<Map<String, Object>>)
			// jsonParam.get("viewerList"));

			project.put("projectId", projectId);
			project.put("memberCount", projectMemberList.size());

			// 그룹 생성
			project.put("groupName",
					request.getParameter("groupName").replaceAll("\"", "&quot;").replaceAll("\'", "&#39;"));
			Long groupId = ezPMSService.addGroup(project, "N", companyId, tenantId, lang);

			// 프로젝트 멤버 테이블에 추가
			HashMap<String, Object> managerMap = new HashMap<String, Object>();
			HashMap<String, Object> participantMap = new HashMap<String, Object>();
			List<String> userIdArr = new ArrayList<String>();
			List<String> deptIdArr = new ArrayList<String>();
			managerMap.put("tenantId", info.getTenantId());
			managerMap.put("groupId", groupId);
			participantMap.put("tenantId", info.getTenantId());
			participantMap.put("groupId", groupId);

			for (int i = 0; i < projectMemberList.size(); i++) {
				if (projectMemberList.get(i).get("memberRoleId").toString().equals("1")) {
					managerMap.put("memberRoleId", projectMemberList.get(i).get("memberRoleId").toString());
					userIdArr.add(projectMemberList.get(i).get("userId").toString());
				} else {
					participantMap.put("memberRoleId", projectMemberList.get(i).get("memberRoleId").toString());
					deptIdArr.add(projectMemberList.get(i).get("userId").toString());
				}
			}
			managerMap.put("userId", userIdArr);
			participantMap.put("userId", deptIdArr);

			List<ProjectGroupMemberVO> member = new ArrayList<ProjectGroupMemberVO>();
			// 개인으로 추가된 사용자가 있는지 확인 후 추가.
			if (userIdArr.size() > 0) {
				member = ezPMSService.getUserInfoForGroup(managerMap);
			}

			// 부서로 추가된 사용자가 있는지 확인 후 추가.
			if (deptIdArr.size() > 0) {
				member.addAll(ezPMSService.getUserInfoForGroup(participantMap));
			}

			ezPMSService.addGroupMember(member);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "success");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "fail");
		}

		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/groups/" + projectId + "/users/" + userId + "] ended.");
		return result;
	}

	/**
	 * 프로젝트관리 그룹 상세보기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/groups/{groupId}/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getGroupDetails(@PathVariable long groupId, @PathVariable String userId,
			HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/groups/" + groupId + "/users/" + userId + "] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			long projectId = Long.parseLong(request.getParameter("projectId"));

			ProjectGroupVO groupVO = ezPMSService.getGroupDetails(groupId, tenantId, projectId);
			groupVO.setGroupMember(ezPMSService.getGroupMemberList(projectId, tenantId, groupId));

			// 권한 체크
			// 프로젝트의 담당자인지 아닌지 확인 (여러개 있을 때, 하나라도 들어가있으면 return)
			int userProjectRole = ezPMSService.getUserProjectRole(userId, tenantId, projectId, info.getDeptId());

			if (userProjectRole == 2) {
				// upperGroupId가 0이아닌 상위 그룹이 있다면 담당자인지
				long upperGroupId = ezPMSService.getUpperGroupId(groupId, projectId, info.getTenantId());

				if (upperGroupId != 0) {
					// 해당 그룹의 담당자인지 해당 그룹에 해당이 안되면 roleId는 참여자(2)
					userProjectRole = ezPMSService.getUserGroupRole(userId, info.getTenantId(), projectId, groupId);

					if (userProjectRole != 1) {
						userProjectRole = ezPMSService.getUserGroupRole(userId, info.getTenantId(), projectId,
								upperGroupId);
					}
				}
			}

			LOGGER.debug("User Group Role Id : " + userProjectRole);

			JSONObject data = new JSONObject();
			data.put("groupDetails", groupVO);
			data.put("userRoleId", userProjectRole);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/groups/" + groupId + "/users/" + userId + "] ended.");
		return result;
	}

	/**
	 * 프로젝트관리 그룹 수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/groups/{groupId}/users/{userId}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject updateGroup(@PathVariable long groupId, @PathVariable String userId, HttpServletRequest request,
			@RequestBody JSONObject jsonParam) throws Exception {
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/groups/" + groupId + "/users/" + userId + "] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			int tenantId = info.getTenantId();
			String companyId = info.getCompanyId();

			Long projectId = Long.parseLong(request.getParameter("projectId"));

			// 권한 체크
			String roleCheck = "";

			// 권한 체크
			// 1. 프로젝트의 담당자인지 아닌지 확인 (여러개 있을 때, 하나라도 들어가있으면 return)
			int userProjectRole = ezPMSService.getUserProjectRole(userId, tenantId, projectId, info.getDeptId());
			if (userProjectRole == 1) {
				roleCheck = "permitted";
			} else if (userProjectRole == 3) {
				// 프로젝트 조회자는 열람권한밖에 없음
				roleCheck = "rejected";
			} else {
				int userGroupRole = 0;

				// upperGroupId가 0이아닌 상위 그룹이 있다면 담당자인지
				long upperGroupId = ezPMSService.getUpperGroupId(groupId, projectId, tenantId);

				if (upperGroupId != 0) {
					// 해당 그룹의 담당자인지 해당 그룹에 해당이 안되면 roleId는 참여자(2)
					userGroupRole = ezPMSService.getUserGroupRole(userId, tenantId, projectId, groupId);

					if (userGroupRole != 1) {
						userGroupRole = ezPMSService.getUserGroupRole(userId, tenantId, projectId, upperGroupId);
					}
				}

				if (userGroupRole != 1) {
					roleCheck = "rejected";
				} else {
					roleCheck = "permitted";
				}
			}

			if (roleCheck.equals("permitted")) {
				List<Map<String, Object>> groupMembers = (List<Map<String, Object>>) jsonParam.get("managerList");

				if (jsonParam.get("participantList") != null) {
					groupMembers.addAll((List<Map<String, Object>>) jsonParam.get("participantList"));
				}

				List<ProjectGroupMemberVO> groupMemberList = new ArrayList<ProjectGroupMemberVO>();

				for (int i = 0; i < groupMembers.size(); i++) {
					String groupMemberId = (String) groupMembers.get(i).get("userId");

					ProjectGroupMemberVO groupMember = new ProjectGroupMemberVO();
					groupMember.setTenantId(tenantId);
					groupMember.setUserId(groupMemberId);

					ProjectMemberVO member = ezPMSService.getUserInfo(groupMemberId, tenantId, "user");

					groupMember.setUserName(member.getUserName());
					groupMember.setUserName2(member.getUserName2());
					groupMember.setUserDeptname(member.getUserDeptname());
					groupMember.setUserDeptname2(member.getUserDeptname2());
					groupMember.setMemberRoleId(Integer.parseInt(groupMembers.get(i).get("memberRoleId").toString()));
					groupMember.setGroupId(Long.parseLong(groupMembers.get(i).get("groupId").toString()));

					groupMemberList.add(groupMember);
				}

				String pretaskType = request.getParameter("type");
				String pretaskId = request.getParameter("pretaskId");
				String planStartDate = request.getParameter("planStartDate");

				// 선행작업 수정 시 DB에 반영
				if (pretaskType != null && !pretaskType.equals("")) {

					Map<String, Object> map = new HashMap<String, Object>();
					map.put("tenantId", tenantId);
					map.put("taskId", groupId);
					map.put("pretaskId", pretaskId);
					map.put("type", pretaskType);

					if (pretaskType.equals("initPretask")) {
						ezPMSService.deletePreTaskRelInGroup(map);
					} else {
						int pretaskRelCNT = ezPMSService.checkIfHasPreTaskRel(map);

						if (pretaskRelCNT > 0) {
							ezPMSService.updatePreTaskRel(map);
						} else {
							ezPMSService.addPreTaskRel(groupId, Integer.parseInt(pretaskId), projectId, tenantId,
									pretaskType);
						}
					}

					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
					Date oldGroupStartDate = sdf.parse(planStartDate);
					Date newGroupStartDate = null;

					if (pretaskType.equals("task2group")) {
						map.put("taskId", pretaskId);
						ProjectTaskVO pretaskVO = ezPMSService.getTaskSchedule(map);

						Date pretaskEndate = sdf.parse(pretaskVO.getPlanEndDate());
						newGroupStartDate = ezPMSService.addWorkingDays(pretaskEndate, 1, companyId, tenantId);

					} else if (pretaskType.equals("group2group")) {
						map.put("groupId", pretaskId);
						ProjectGroupVO pregroupVO = ezPMSService.getGroupSchedule(map);

						Date pregroupEndate = sdf.parse(pregroupVO.getPlanEndDate());
						newGroupStartDate = ezPMSService.addWorkingDays(pregroupEndate, 1, companyId, tenantId);
					}

					LOGGER.debug("oldGroupStartDate : " + sdf.format(oldGroupStartDate) + ", newGroupStartDate : "
							+ sdf.format(newGroupStartDate));

					int offset = ezPMSService.getWorkingDays(oldGroupStartDate, newGroupStartDate, companyId, tenantId, lang)
							- 1;
					LOGGER.debug("offset : " + offset);

					List<ProjectTaskVO> tasksInGroup = ezPMSService.getTaskListByGroupId(tenantId, groupId);

					// 프로젝트 group내의 모든 task의 시작날짜와 끝날짜 update
					for (ProjectTaskVO taskVO : tasksInGroup) {

						// offset만큼 workingday기준으로 날짜를 증가시킴
						Date oldStartDate = sdf.parse(taskVO.getPlanStartDate());
						String newStartDate = sdf
								.format(ezPMSService.addWorkingDays(oldStartDate, offset, companyId, tenantId));
						Date oldEndDate = sdf.parse(taskVO.getPlanEndDate());
						String newEndDate = sdf
								.format(ezPMSService.addWorkingDays(oldEndDate, offset, companyId, tenantId));

						LOGGER.debug("oldStartDate : " + sdf.format(oldStartDate) + ", newStartDate : " + newStartDate);
						LOGGER.debug("oldEndDate   : " + sdf.format(oldEndDate) + ", newEndDate   : " + newEndDate);

						taskVO.setTenantId(tenantId);
						taskVO.setProjectId(projectId);
						taskVO.setPlanStartDate(newStartDate);
						taskVO.setPlanEndDate(newEndDate);
						taskVO.setRealProgress(Float.parseFloat(request.getParameter("realProgress")));

						ezPMSService.updateTaskStatus(taskVO, companyId, tenantId, lang);

						ezPMSService.updateGroupDate(groupId, tenantId, companyId, lang);
					}
				}

				ProjectGroupVO groupInfo = new ProjectGroupVO();
				groupInfo.setGroupName(request.getParameter("groupName"));
				groupInfo.setGroupId(groupId);
				groupInfo.setProjectId(Long.parseLong(request.getParameter("projectId")));
				groupInfo.setGroupMember(groupMemberList);
				groupInfo.setOverview(request.getParameter("overview"));
				groupInfo.setTenantId(info.getTenantId());
				groupInfo.setUpperGroupId(Long.parseLong(request.getParameter("upperGroupId")));
				groupInfo.setHeadManagerId(request.getParameter("headManagerId"));

				ezPMSService.updateGroup(groupInfo, lang);
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", roleCheck);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/groups/" + groupId + "/users/" + userId + "] ended.");
		return result;
	}

	/**
	 * 프로젝트관리 그룹 삭제
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/groups/{groupId}", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject deleteGroup(@PathVariable long projectId, @PathVariable long groupId, HttpServletRequest request)
			throws Exception {
		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/projects/" + projectId + "/groups/" + groupId + "] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();

			// 권한 체크
			String roleCheck = "";

			// 권한 체크
			// 1. 프로젝트의 담당자인지 아닌지 확인 (여러개 있을 때, 하나라도 들어가있으면 return)
			int userProjectRole = ezPMSService.getUserProjectRole(userId, tenantId, projectId, info.getDeptId());
			if (userProjectRole == 1) {
				roleCheck = "permitted";
			} else if (userProjectRole == 3) {
				// 프로젝트 조회자는 열람권한밖에 없음
				roleCheck = "rejected";
			} else {
				// 2. group의 담당자인지 확인
				int userGroupRole = ezPMSService.getUserGroupRole(userId, tenantId, projectId, groupId);

				if (userGroupRole != 1) {
					roleCheck = "rejected";
				} else {
					roleCheck = "permitted";
				}
			}

			LOGGER.debug("DELETEGROUP ROLECHECK : " + roleCheck);

			if (roleCheck.equals("permitted")) {
				ezPMSService.deleteGroup(projectId, groupId, tenantId);
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/projects/" + projectId + "/groups/" + groupId + "] ended.");
		return result;
	}

	/**
	 * 프로젝트관리 업무/그룹 트리
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/tree/{projectId}/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getProjectTaskTree(@PathVariable String projectId, @PathVariable String userId,
			HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/tree/" + projectId + "/users/" + userId + "] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String location = request.getParameter("location");
			int tenantId = info.getTenantId();

			List<ProjectTaskTreeVO> list = ezPMSService.getProjectTaskTree(Long.parseLong(projectId),
					request.getParameter("onlyGroup"), location, tenantId, userId);

			LOGGER.debug(list.get(0).getText());

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", list);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/tree/" + projectId + "/users/" + userId + "] ended.");
		return result;
	}

	/**
	 * 프로젝트관리 잔여 가중치 및 시작일/종료일 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/weight/{projectId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getRemainingWeight(@PathVariable String projectId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/weight/" + projectId + "] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			int tenantId = Integer.parseInt(request.getParameter("tenantId"));

			Map<String, Object> data = ezPMSService.getRemainingWeight(projectId, tenantId);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/weight/" + projectId + "] ended.");
		return result;
	}

	/**
	 * 프로젝트관리 프로젝트 세부 정보 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/users/{userId}/gantt", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getProjectDetailsforGantt(@PathVariable Long projectId, @PathVariable String userId,
			HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/users/" + userId + "/gantt] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			int isGantt = 0;
			String companyId = info.getCompanyId();
			String deptId = info.getDeptId();

			ProjectInfoVO project = ezPMSService.getProjectDetails(projectId, userId, info.getTenantId(), info.getOffSet(),
					lang, deptId, companyId);
			project.setProjectMember(ezPMSService.getProjectMemberList(projectId, 4, lang, info.getTenantId(), isGantt));
			project.setWeight(ezPMSService.getProjectWeight(projectId, info.getTenantId()));
			
			HashSet<String> holidayList = ezPMSService.getHolidayList(project.getPlanStartDate(), project.getPlanEndDate(), info.getTenantId(), info.getCompanyId(), lang);
			
			LOGGER.debug("holidayList : " + holidayList);
			JSONObject data = new JSONObject();
			data.put("project", project);
			data.put("holidayList", holidayList);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/users/" + userId + "/gantt] ended.");
		return result;
	}

	/**
	 * 프로젝트관리 업무 상태 수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/tasks/{taskId}/users/{userId}/status", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject updateTaskStatus(@PathVariable long taskId, @PathVariable String userId,
			HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/tasks/" + taskId + "/users/" + userId + "] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			String roleCheck = "";
			long projectId = Long.parseLong(request.getParameter("projectId"));
			String lang = commonUtil.getMultiData(info.getLang(), tenantId);
			JSONObject data = new JSONObject();
			String companyId = info.getCompanyId();

			// 권한 체크
			// 1. 프로젝트의 담당자인지 아닌지 확인 (여러개 있을 때, 하나라도 들어가있으면 return)
			int userProjectRole = ezPMSService.getUserProjectRole(userId, tenantId, projectId, info.getDeptId());
			if (userProjectRole == 1) {
				roleCheck = "permitted";
			} else if (userProjectRole == 3) {
				// 프로젝트 조회자는 열람권한밖에 없음
				roleCheck = "rejected";
			} else {
				// 2. task의 담당자인지 확인
				String userTaskRole = ezPMSService.getUserTaskRole(userId, tenantId, taskId);

				if (userTaskRole == null) {
					roleCheck = "rejected";
				} else {
					roleCheck = "permitted";
				}
			}

			data.put("roleCheck", roleCheck);

			if (roleCheck.equals("permitted")) {
				ProjectTaskVO projectTaskVO = new ProjectTaskVO();

				String planStartDate = request.getParameter("planStartDate");
				String planEndDate = request.getParameter("planEndDate");
				Date start = new SimpleDateFormat("yyyy-MM-dd").parse(planStartDate);
				Date end = new SimpleDateFormat("yyyy-MM-dd").parse(planEndDate);

				projectTaskVO.setTenantId(tenantId);
				projectTaskVO.setTaskId(taskId);
				projectTaskVO.setProjectId(projectId);
				projectTaskVO.setPlanStartDate(planStartDate);
				projectTaskVO.setPlanEndDate(planEndDate);
				projectTaskVO.setRealStartDate(request.getParameter("realStartDate"));
				projectTaskVO.setRealEndDate(request.getParameter("realEndDate"));
				projectTaskVO.setRealProgress(Float.parseFloat(request.getParameter("realProgress")));
				projectTaskVO.setStatus(request.getParameter("status"));
				projectTaskVO.setGroupId(Long.parseLong(request.getParameter("groupId")));

				int workingday = ezPMSService.getWorkingDays(start, end, companyId, tenantId, lang);
				projectTaskVO.setWorkingday(workingday);

				ezPMSService.updateTaskStatus(projectTaskVO, companyId, tenantId, lang);
				
				// taskId로 해당 date 삭제 후, 추가
//				ezPMSService.deleteMemberSchedule(null, projectId, tenantId, null,taskId);
				List<TaskMemberVO> taskMemberList = ezPMSService.getTaskMemberList(tenantId, taskId, lang);
				
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				Date startDate = sdf.parse(planStartDate);
				Date endDate = sdf.parse(planEndDate);

				Calendar startCal = Calendar.getInstance();
				Calendar endCal = Calendar.getInstance();

				startCal.setTime(startDate);
				endCal.setTime(endDate);

				List<String> dateList = new ArrayList<String>();

				while (startCal.compareTo(endCal) != 1) {
					if (startCal.get(Calendar.DAY_OF_WEEK) == 1 || startCal.get(Calendar.DAY_OF_WEEK) == 7) {
						startCal.add(Calendar.DATE, 1);
					} else {
						dateList.add(sdf.format(startCal.getTime()));
						startCal.add(Calendar.DATE, 1);
					}
				}

//				for (int i = 0; i < taskMemberList.size(); i++) {
//					String memberId = taskMemberList.get(i).getUserId();
//					LOGGER.debug(memberId);
//					for (int j = 0; j < dateList.size(); j++) {
//						ezPMSService.addMemberSchedule(memberId, tenantId, dateList.get(j), projectId, taskId);
//					}
//				}
				
//				if (request.getParameter("endTime") != null) {
//					long endTime = Long.parseLong(request.getParameter("endTime"));
//					int rowIndex = Integer.parseInt(request.getParameter("rowIndex"));
//
//					data.put("endDate", endTime);
//
//					List<Long> preTaskList = ezPMSService.getPreTaskRel(rowIndex, tenantId, projectId);
//
//					if (preTaskList != null && preTaskList.size() != 0) {
//						Date postTaskEndTime = new Date(endTime);
//						DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
//
//						for (int i = 0; i < preTaskList.size(); i++) {
//							ProjectTaskVO postTask = ezPMSService.getTaskDetails(preTaskList.get(i), tenantId, lang);
//							Date postPlanStartDate = dateFormat.parse(postTask.getPlanStartDate());
//							Date postPlanEndDate = dateFormat.parse(postTask.getPlanEndDate());
//							
//							long diff = postPlanEndDate.getTime() - postPlanStartDate.getTime();
//							int diffDays = (int) diff / (24 * 60 * 60 * 1000);
//
//							Calendar cal = Calendar.getInstance();
//							cal.setTime(postTaskEndTime);
//							cal.add(Calendar.DATE, 1); // 다음날 지정
//
//							int dayNum = cal.get(Calendar.DAY_OF_WEEK);
//
//							if (dayNum == 7) {
//								cal.add(Calendar.DATE, 2);
//							} else if (dayNum == 1) {
//								cal.add(Calendar.DATE, 1);
//							}
//
//							Calendar cal2 = Calendar.getInstance();
//							cal2.setTime(cal.getTime());
//							cal2.add(Calendar.DATE, diffDays);
//							int dayNum2 = cal2.get(Calendar.DAY_OF_WEEK);
//
//							if (dayNum2 == 7) {
//								cal2.add(Calendar.DATE, -1);
//							} else if (dayNum2 == 1) {
//								cal2.add(Calendar.DATE, -2);
//							}
//
//							String calStartStr = dateFormat.format(cal.getTime());
//							String calEndStr = dateFormat.format(cal2.getTime());
//							Date calStart = new SimpleDateFormat("yyyy-MM-dd").parse(calStartStr);
//							Date calEnd = new SimpleDateFormat("yyyy-MM-dd").parse(calEndStr);
//
//							int workingdayPT = ezPMSService.getWorkingDays(calStart, calEnd, companyId, tenantId);
//
//							LOGGER.debug("workingdayPT : " + workingdayPT);
//
//							postTask.setPlanStartDate(calStartStr);
//							postTask.setPlanEndDate(calEndStr);
//							postTask.setWorkingday(workingdayPT);
//							ezPMSService.updateTaskStatus(postTask, companyId, tenantId);
//							
//							// taskId로 해당 date 삭제 후, 추가
//							ezPMSService.deleteMemberSchedule(null, projectId, tenantId, null, preTaskList.get(i));
//							List<TaskMemberVO> postTaskMemberList = ezPMSService.getTaskMemberList(tenantId, preTaskList.get(i), lang);
//							
//							Date postStartDate = sdf.parse(calStartStr);
//							Date postEndDate = sdf.parse(calEndStr);
//
//							Calendar postStartCal = Calendar.getInstance();
//							Calendar postEndCal = Calendar.getInstance();
//
//							postStartCal.setTime(postStartDate);
//							postEndCal.setTime(postEndDate);
//
//							List<String> postDateList = new ArrayList<String>();
//
//							while (postStartCal.compareTo(postEndCal) != 1) {
//								if (postStartCal.get(Calendar.DAY_OF_WEEK) == 1 || postStartCal.get(Calendar.DAY_OF_WEEK) == 7) {
//									postStartCal.add(Calendar.DATE, 1);
//								} else {
//									postDateList.add(sdf.format(postStartCal.getTime()));
//									postStartCal.add(Calendar.DATE, 1);
//								}
//							}
//
//							for (int k = 0; k < postTaskMemberList.size(); k++) {
//								String memberId = postTaskMemberList.get(k).getUserId();
//								LOGGER.debug(memberId);
//								for (int j = 0; j < postDateList.size(); j++) {
//									ezPMSService.addMemberSchedule(memberId, tenantId, postDateList.get(j), projectId, preTaskList.get(i));
//								}
//							}
//						}
//
//					}
//
//				}
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/tasks/" + taskId + "/users/" + userId + "] ended.");
		return result;
	}

	/**
	 * 프로젝트관리 그룹 리스트(간트차트 용)
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/{projectId}/groups/users/{userId}/gantt", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getGroupListForGantt(@PathVariable String projectId, @PathVariable String userId,
			HttpServletRequest request) throws Exception {
		LOGGER.debug(
				"ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/groups/users/" + userId + "/gantt] started.");

		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);

			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			String orderWhat = request.getParameter("orderWhat");
			String orderHow = request.getParameter("orderHow");
			int startRow = Integer
					.parseInt(request.getParameter("startRow") != null ? request.getParameter("startRow") : "-1");
			int limit = Integer.parseInt(request.getParameter("limit") != null ? request.getParameter("limit") : "-1");
			String companyId = info.getCompanyId();
			int tenantId = info.getTenantId();
			String location = "gantt";

			if (orderWhat == null || orderWhat.equals("")) {
				orderWhat = "init";
			}

			SearchVO search = new SearchVO();
			search.setTenantId(info.getTenantId());
			search.setProjectId(Long.parseLong(projectId));
			search.setUpperGroupName(request.getParameter("searchByUpperGroupName"));
			search.setMemberName(request.getParameter("searchByUser"));
			search.setPlanStartDate(request.getParameter("searchByStartDate"));
			search.setPlanEndDate(request.getParameter("searchByEndDate"));
			search.setGroupName(request.getParameter("searchByGroupName"));
			search.setOverview(request.getParameter("searchByOverview"));
			search.setProjectName(request.getParameter("searchByProjectName"));
			search.setMemberId(userId);

			List<ProjectGroupVO> groupList = ezPMSService.getGroupList(search, orderWhat, orderHow, startRow, limit,
					lang, location);
			List<ProjectGroupMemberVO> groupMemberList = ezPMSService.getGroupMemberList(Long.parseLong(projectId),
					info.getTenantId(), null);

			for (int i = 0; i < groupList.size(); i++) {
				Long groupId = groupList.get(i).getGroupId();

				// 그룹 가중치를 얻어옴.
				Float weight = ezPMSService.getGroupWeight(groupId, info.getTenantId());
				groupList.get(i).setWeight(weight);

				// 그룹 멤버를 얻어옴.
				Iterator<ProjectGroupMemberVO> iter = groupMemberList.iterator();
				List<ProjectGroupMemberVO> groupMemberListTemp = new ArrayList<ProjectGroupMemberVO>();
				while (iter.hasNext()) {
					ProjectGroupMemberVO groupMember = iter.next();
					if (groupId.equals(groupMember.getGroupId())) {
						groupMemberListTemp.add(groupMember);
						iter.remove();
					}
				}

				Date startDate = new SimpleDateFormat("yyyy-MM-dd").parse(groupList.get(i).getPlanStartDate());
				Date endDate = new SimpleDateFormat("yyyy-MM-dd").parse(groupList.get(i).getPlanEndDate());
				Date today = new Date();
				String simpToday = new SimpleDateFormat("yyyy-MM-dd").format(today);
				Date now = new SimpleDateFormat("yyyy-MM-dd").parse(simpToday);

				int restDueday = ezPMSService.getWorkingDays(now, endDate, companyId, tenantId, lang);
				groupList.get(i).setRestDueday(restDueday);
				// groupList.get(i).setPlanProgress(ezPMSService.getPlanProgress(startDate,
				// endDate, companyId, tenantId));

				groupList.get(i).setGroupMember(groupMemberListTemp);
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", groupList);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/" + projectId + "/groups/users/" + userId + "] ended.");
		return result;
	}

	/**
	 * 프로젝트관리 업무 가중치 수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/tasks/{taskId}/weight", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject updateTaskWeight(@PathVariable String taskId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/tasks/" + taskId + "/weight] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));

			ProjectTaskVO taskVO = new ProjectTaskVO();
			taskVO.setTaskId(Long.parseLong(taskId));
			taskVO.setTenantId(info.getTenantId());
			taskVO.setProjectId(Long.parseLong(request.getParameter("projectId")));
			taskVO.setWeight(Float.parseFloat(request.getParameter("weight")));

			String groupId = request.getParameter("groupId") != "" ? request.getParameter("groupId") : "";
			if (!groupId.equals("")) {
				taskVO.setGroupId(Long.parseLong(request.getParameter("groupId")));
			} else {
				taskVO.setGroupId(0L);
			}

			ezPMSService.updateTaskWeight(taskVO);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/tasks/" + taskId + "/weight] ended.");
		return result;
	}

	/**
	 * 프로젝트관리 업무 진행률 수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/tasks/{taskId}/progress", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject updateTaskProgress(@PathVariable String taskId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/tasks/" + taskId + "/progress] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));

			ProjectTaskVO taskVO = new ProjectTaskVO();

			float realProgress = Float.parseFloat(request.getParameter("progress"));
			taskVO.setTaskId(Long.parseLong(taskId));
			taskVO.setProjectId(Long.parseLong(request.getParameter("projectId")));

			String groupId = request.getParameter("groupId") != "" ? request.getParameter("groupId") : "";
			if (!groupId.equals("")) {
				taskVO.setGroupId(Long.parseLong(request.getParameter("groupId")));
			} else {
				taskVO.setGroupId(0L);
			}

			taskVO.setTenantId(info.getTenantId());
			taskVO.setRealProgress(realProgress);

			// 실제 진행률이 100 이상이면 해당 업무의 상태를 완료로 반영.
			if (realProgress >= 100) {
				taskVO.setStatus("C");
				taskVO.setRealProgress(100.0F);
			} else {
				taskVO.setStatus(request.getParameter("status"));
			}

			ezPMSService.updateTaskProgress(taskVO);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/tasks/" + taskId + "/progress] ended.");
		return result;
	}

	/**
	 * 프로젝트관리 그룹 하위 업무 담당자 보기.
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/tasks/member-list/group/{groupId}/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getTaskMemberListInGroup(@PathVariable Long groupId, @PathVariable String userId,
			HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/tasks/member-list/group/" + groupId + "/users/" + userId + "] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());

			List<TaskMemberVO> taskMemberList = ezPMSService.getTaskMemberListInGroup(info.getTenantId(), groupId,
					lang);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", taskMemberList);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/tasks/member-list/group/" + groupId + "/users/" + userId + "] ended.");
		return result;
	}

	// 임민석 작성
	/**
	 * 게시물 추가
	 * 
	 * @param request
	 * @param jsonParam
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/boards", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject addBoard(HttpServletRequest request, @RequestBody JSONObject jsonParam) {
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/boards] started");

		JSONObject result = new JSONObject();

		try {
			String realPath = commonUtil.getRealPath(request);
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, (String) jsonParam.get("userId"));
			
			jsonParam.put("tenantId", info.getTenantId());
			
			ezPMSService.addBoard(jsonParam, realPath);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			e.printStackTrace();
		}

		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/boards] ended");
		return result;
	}

	/**
	 * 게시물 수정
	 * 
	 * @param request
	 * @param jsonParam
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/boards", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject modifyBoard(HttpServletRequest request, @RequestBody JSONObject jsonParam) {
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/boards] started");

		JSONObject result = new JSONObject();

		try {
			String realPath = commonUtil.getRealPath(request);
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, (String) jsonParam.get("userId"));
			
			jsonParam.put("tenantId", info.getTenantId());
			
			ezPMSService.modifyBoard(jsonParam, realPath);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			e.printStackTrace();
		}

		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/boards] ended");
		return result;
	}
	
	/**
	 * 게시물 이동
	 * 
	 * @param request
	 * @param jsonParam
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/moveBoards", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject moveBoards(HttpServletRequest request, @RequestBody JSONObject jsonParam) {
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/moveBoards] started");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, (String) jsonParam.get("userId"));
			
			jsonParam.put("tenantId", info.getTenantId());
			
			ezPMSService.moveBoard(jsonParam);
		
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			e.printStackTrace();
		}

		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/moveBoards] ended");
		return result;
	}
	
	/**
	 * 게시물 삭제
	 * 
	 * @param request
	 * @param jsonParam
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/boards", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject deleteBoard(HttpServletRequest request, @RequestBody JSONObject jsonParam) {
		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/boards] started");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, (String) jsonParam.get("userId"));
			ezPMSService.deleteBoard(info.getTenantId(), jsonParam);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			e.printStackTrace();
		}

		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/boards] ended");
		return result;
	}

	/**
	 * 게시물 목록 리스트 호출
	 * 
	 * @param projectId
	 * @param userId
	 * @param request
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/boards/list/{projectId}/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getBoardList(@PathVariable String projectId, @PathVariable String userId,
			HttpServletRequest request) {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/boards/list/" + projectId + "/users/" + userId + "] started");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			String lang = commonUtil.getMultiData(info.getLang(), tenantId);
			String uploadPathName = "uploadFile";

			Long groupId = 0L;
			Long taskId = 0L;

			if (request.getParameter("groupId") != null && !request.getParameter("groupId").equals("")) {
				groupId = Long.parseLong(request.getParameter("groupId"));
			}

			if (request.getParameter("taskId") != null && !request.getParameter("taskId").equals("")
					&& !request.getParameter("taskId").equals("null")) {
				taskId = Long.parseLong(request.getParameter("taskId"));
			}

			int startRow = Integer.parseInt(request.getParameter("startRow"));
			int listCnt = Integer.parseInt(request.getParameter("limit"));
			String position = request.getParameter("position");
			String orderWhat = request.getParameter("orderWhat");
			String orderHow = request.getParameter("orderHow");
			String searchByTaskName = request.getParameter("searchByTaskName");
			String searchByUser = request.getParameter("searchByUser");
			String searchByStartDate = request.getParameter("searchByStartDate");
			String searchByEndDate = request.getParameter("searchByEndDate");
			String searchByTitle = request.getParameter("searchByTitle");
			String searchByOverview = request.getParameter("searchByOverview");
			String searchByContent = request.getParameter("searchByContent");
			String searchOrNot = request.getParameter("searchOrNot");

//			Enumeration<String> parameterNames = request.getParameterNames();
//
//			while (parameterNames.hasMoreElements()) {
//				String parameterName = parameterNames.nextElement();
//				LOGGER.debug(parameterName + " : " + request.getParameter(parameterName));
//			}
			
			if (searchByTaskName != null && !searchByTaskName.equals("")) {
				searchByTaskName = searchByTaskName.replace("\\", "\\\\");
				searchByTaskName = searchByTaskName.replace("%", "\\%");
				searchByTaskName = searchByTaskName.replace("_", "\\_");
			}

			if (searchByUser != null && !searchByUser.equals("")) {
				searchByUser = searchByUser.replace("\\", "\\\\");
				searchByUser = searchByUser.replace("%", "\\%");
				searchByUser = searchByUser.replace("_", "\\_");
			}

			if (searchByTitle != null && !searchByTitle.equals("")) {
				searchByTitle = searchByTitle.replace("\\", "\\\\");
				searchByTitle = searchByTitle.replace("%", "\\%");
				searchByTitle = searchByTitle.replace("_", "\\_");
			}

			if (searchByOverview != null && !searchByOverview.equals("")) {
				searchByOverview = searchByOverview.replace("\\", "\\\\");
				searchByOverview = searchByOverview.replace("%", "\\%");
				searchByOverview = searchByOverview.replace("_", "\\_");
			}

			if (searchByContent != null && !searchByContent.equals("")) {
				searchByContent = searchByContent.replace("\\", "\\\\");
				searchByContent = searchByContent.replace("%", "\\%");
				searchByContent = searchByContent.replace("_", "\\_");
			}

			int noticeCNT = ezPMSService.getBoardNoticeListCount(tenantId, Long.parseLong(projectId), groupId, taskId);
			List<ProjectBoardVO> boardList = null;

			// 프로젝트 개요/게시판 검색 시에는 공지사항을 제외한 게시물만 출력
			if ((position != null && position.equals("overview")) || searchOrNot.equals("true")) {
				boardList = ezPMSService.getBoardList(tenantId, Long.parseLong(projectId), groupId, taskId, userId,
						startRow, listCnt, lang, position, orderWhat, orderHow, searchByTaskName, searchByUser,
						searchByStartDate, searchByEndDate, searchByTitle, searchByOverview, searchByContent);
			} else if (position != null && (position.equals("tab") || position.equals("boardMain"))) {

				if (noticeCNT > startRow) {
					boardList = ezPMSService.getBoardNoticeList(tenantId, Long.parseLong(projectId), groupId, taskId,
							startRow, listCnt, lang);

					boardList.forEach(boardVO -> boardVO.setNotice(true));

					if (noticeCNT < startRow + listCnt) {
						listCnt = (startRow + listCnt) - noticeCNT;
						startRow = 0;
						boardList.addAll(ezPMSService.getBoardList(tenantId, Long.parseLong(projectId), groupId, taskId,
								userId, startRow, listCnt, lang, position, orderWhat, orderHow, searchByTaskName,
								searchByUser, searchByStartDate, searchByEndDate, searchByTitle, searchByOverview,
								searchByContent));
					}
				} else {
					startRow = startRow - noticeCNT;
					boardList = ezPMSService.getBoardList(tenantId, Long.parseLong(projectId), groupId, taskId, userId,
							startRow, listCnt, lang, position, orderWhat, orderHow, searchByTaskName, searchByUser,
							searchByStartDate, searchByEndDate, searchByTitle, searchByOverview, searchByContent);
				}
			}

			String imageFileType = "PNG,JPEG,BMP,GIF,JPG";

			for (int i = 0; i < boardList.size(); i++) {
				int fileCount = boardList.get(i).getFileCNT();
				if (fileCount > 0) {
					String filePath = "";

					List<Map<String, Object>> filePathList = ezPMSService.getFilePath(boardList.get(i).getItemId(),
							info.getTenantId());

					for (int j = 0; j < filePathList.size(); j++) {
						String fileName = filePathList.get(j).get("fileName").toString();

						if (fileName.indexOf(".") != -1) {
							fileName = fileName.substring(fileName.indexOf(".") + 1, fileName.length()).toUpperCase();

							if (imageFileType.contains(fileName)) {
								filePath = filePathList.get(j).get("filePath").toString().substring(1);
								String realPath = commonUtil.getUploadPath("upload_project.ROOT", info.getTenantId())
										+ commonUtil.separator + uploadPathName + commonUtil.separator + filePath;

								boardList.get(i).setImageFilePath("/ezCommon/downloadAttach.do?filePath=" + realPath);
							}
						}
					}
				}
			}

			String taskName = "";

			if (taskId != 0) {
				ProjectTaskVO taskVO = ezPMSService.getTaskDetails(taskId, tenantId, lang);
				taskName = taskVO.getTaskName();
			} else if (groupId != 0) {
				ProjectGroupVO groupVO = ezPMSService.getGroupDetails(groupId, tenantId, Long.parseLong(projectId));
				taskName = groupVO.getGroupName();
			}

			LOGGER.debug("taskName : " + taskName);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", boardList);
			result.put("taskName", taskName);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			result.put("taskName", "");
			e.printStackTrace();
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/boards/list/" + projectId + "/users/" + userId + "] ended");
		return result;
	}

	/**
	 * 게시물 개수 출력
	 * 
	 * @param projectId
	 * @param userId
	 * @param request
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/boards/list-count/{projectId}/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getBoardListCount(@PathVariable String projectId, @PathVariable String userId,
			HttpServletRequest request) {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/boards/list-count/" + projectId + "/users/" + userId + "] started");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();

			Long groupId = 0L;
			Long taskId = 0L;

			if (request.getParameter("groupId") != null && !request.getParameter("groupId").equals("")) {
				groupId = Long.parseLong(request.getParameter("groupId"));
			}

			if (request.getParameter("taskId") != null && !request.getParameter("taskId").equals("")) {
				taskId = Long.parseLong(request.getParameter("taskId"));
			}

			String searchByTaskName = request.getParameter("searchByTaskName");
			String searchByUser = request.getParameter("searchByUser");
			String searchByStartDate = request.getParameter("searchByStartDate");
			String searchByEndDate = request.getParameter("searchByEndDate");
			String searchByTitle = request.getParameter("searchByTitle");
			String searchByOverview = request.getParameter("searchByOverview");
			String searchByContent = request.getParameter("searchByContent");

			if (searchByTaskName != null && !searchByTaskName.equals("")) {
				searchByTaskName = searchByTaskName.replace("\\", "\\\\");
				searchByTaskName = searchByTaskName.replace("%", "\\%");
				searchByTaskName = searchByTaskName.replace("_", "\\_");
			}

			if (searchByUser != null && !searchByUser.equals("")) {
				searchByUser = searchByUser.replace("\\", "\\\\");
				searchByUser = searchByUser.replace("%", "\\%");
				searchByUser = searchByUser.replace("_", "\\_");
			}

			if (searchByTitle != null && !searchByTitle.equals("")) {
				searchByTitle = searchByTitle.replace("\\", "\\\\");
				searchByTitle = searchByTitle.replace("%", "\\%");
				searchByTitle = searchByTitle.replace("_", "\\_");
			}

			if (searchByOverview != null && !searchByOverview.equals("")) {
				searchByOverview = searchByOverview.replace("\\", "\\\\");
				searchByOverview = searchByOverview.replace("%", "\\%");
				searchByOverview = searchByOverview.replace("_", "\\_");
			}

			if (searchByContent != null && !searchByContent.equals("")) {
				searchByContent = searchByContent.replace("\\", "\\\\");
				searchByContent = searchByContent.replace("%", "\\%");
				searchByContent = searchByContent.replace("_", "\\_");
			}

			int noticeCount = ezPMSService.getBoardNoticeListCount(tenantId, Long.parseLong(projectId), groupId,
					taskId);
			int boardCount = ezPMSService.getBoardListCount(tenantId, Long.parseLong(projectId), groupId, taskId,
					searchByTaskName, searchByUser, searchByStartDate, searchByEndDate, searchByTitle, searchByOverview,
					searchByContent);
			int totalCount = noticeCount + boardCount;

			result.put("data", boardCount + "");
			result.put("data2", totalCount + ""); // JSON으로 넘기면 숫자가 Long으로 바뀌는데
													// Long에서 int로 cast할 때의 오류를
													// 피하기 위해서 String으로 바꾼 후에
													// 파싱한다
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("data", "");
			result.put("data2", "");
			result.put("status", "error");
			result.put("code", 1);
			e.printStackTrace();
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/boards/list-count/" + projectId + "/users/" + userId + "] ended");
		return result;
	}

	/**
	 * 첨부파일 업로드
	 * 
	 * @param request
	 * @param jsonParam
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/attachfiles", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	public JSONObject uploadFile(HttpServletRequest request, @RequestBody JSONObject jsonParam) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/attachfiles] started");

		JSONObject result = new JSONObject();

		JSONParser jp = new JSONParser();
		jsonParam = (JSONObject) jp.parse(jsonParam.toJSONString());

		String uploadPathName = "uploadFile";
		String tempUploadPathName = "tempUploadFile";

		try {
			JSONArray fileArray = new JSONArray();
			String userId = "";
			int cnt = 0;
			int maxSize = 0;

			if (jsonParam.get("fileArray") != null) {
				fileArray = (JSONArray) jsonParam.get("fileArray");
			}

			if (jsonParam.get("cnt") != null) {
				cnt = ((Long) jsonParam.get("cnt")).intValue();
			}

			if (jsonParam.get("maxSize") != null) {
				maxSize = ((Long) jsonParam.get("maxSize")).intValue();
			}

			if (jsonParam.get("userId") != null) {
				userId = (String) jsonParam.get("userId");
			}

			LOGGER.debug("####cnt:" + cnt + ", maxSize:" + maxSize + ", userId:" + userId);

			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);

			String realPath = commonUtil.getRealPath(request);
			String[] pFileName = new String[cnt];
			Long[] fileSize = new Long[cnt];
			String[] fileLocation = new String[cnt];
			String[] resultUpload = new String[cnt];
			String[] sGUID = new String[cnt];
			String[] pUploadSN = new String[cnt];

			String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", info.getTenantId());

			for (int i = 0; i < cnt; i++) {
				resultUpload[i] = "false";
				sGUID[i] = UUID.randomUUID().toString();
				pUploadSN[i] = "{" + sGUID[i] + "}";
			}

			if (useExtension == null) {
				useExtension = "";
			}

			if (((JSONObject) fileArray.get(0)).get("originalFilename") != null
					&& StringUtils.isNotBlank((String) ((JSONObject) fileArray.get(0)).get("originalFilename"))) {
				String _pFileName = "";

				for (int i = 0; i < cnt; i++) {
					_pFileName = (String) ((JSONObject) fileArray.get(i)).get("originalFilename");

					// 폴더패스를 제외한 파일명을 구한다.
					if (_pFileName.indexOf(commonUtil.separator) > 0) {
						_pFileName = _pFileName.split("/")[_pFileName.split("/").length - 1];
					}

					pFileName[i] = _pFileName;
				}
			}

			String pDirPath = commonUtil.getUploadPath("upload_project.ROOT", info.getTenantId());
			pDirPath = realPath + pDirPath;

			if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
				pDirPath = pDirPath + commonUtil.separator;
			}

			File file = new File(pDirPath + uploadPathName);
			File tempFile = new File(pDirPath + tempUploadPathName);

			if (!file.exists()) {
				file.mkdirs();
			}

			if (!tempFile.exists()) {
				tempFile.mkdir();
			}

			for (int i = 0; i < cnt; i++) {
				fileSize[i] = (Long) ((JSONObject) fileArray.get(i)).get("fileSize");
				String extend = pFileName[i].substring(pFileName[i].lastIndexOf(".") + 1);
				String newFileName = pUploadSN[i] + "." + extend;

				// maxsize를 넘어가는 파일은 저장하지 않는다.
				if (fileSize[i] > maxSize && maxSize != 0) {
					resultUpload[i] = "overflow";
				} else {
					// 허용하는 확장자가 아닌경우 저장하지 않는다.
					if (useExtension.toLowerCase().indexOf(extend.toLowerCase()) == -1 && !useExtension.equals("*")) {
						resultUpload[i] = "denied";
					} else {
						String pAttachPath = pDirPath + tempUploadPathName + commonUtil.separator;

						// 업로드된 파일 데이터를 파일로 저장한다.
						uploadFile((String) ((JSONObject) fileArray.get(i)).get("bytes"), newFileName, pAttachPath);

						fileLocation[i] = commonUtil.getUploadPath("upload_project.ROOT", info.getTenantId())
								+ commonUtil.separator + tempUploadPathName + commonUtil.separator + pUploadSN[i];
						resultUpload[i] = "true";
					}
				}
			}

			List<JSONObject> filelist = new ArrayList<JSONObject>();

			for (int i = 0; i < cnt; i++) {
				JSONObject fileInfo = new JSONObject();
				fileInfo.put("pUploadSN", pUploadSN[i]);
				fileInfo.put("pFileName", pFileName[i]);
				fileInfo.put("fileSize", fileSize[i]);
				fileInfo.put("fileLocation", fileLocation[i]);
				fileInfo.put("resultUpload", resultUpload[i]);
				filelist.add(i, fileInfo);
			}
			result.put("data", filelist);
			result.put("status", "ok");
			result.put("code", 0);

		} catch (Exception e) {
			result.put("data", "");
			result.put("status", "error");
			result.put("code", 0);
			e.printStackTrace();
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/attachfiles] ended.");
		return result;
	}

	/**
	 * 첨부파일 삭제
	 * 
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/attachfiles", method = RequestMethod.DELETE, produces = "application/json;charset=UTF-8")
	public JSONObject deleteFile(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/attachfiles] started.");

		JSONObject result = new JSONObject();

		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);

			String pDirPath = commonUtil.getRealPath(request)
					+ commonUtil.getUploadPath("upload_project.ROOT", info.getTenantId());
			String filePath = request.getParameter("filePath");
			String fileList = request.getParameter("fileList");

			LOGGER.debug("pDirPath : " + pDirPath + " | filePath : " + filePath + " | fileList : " + fileList);

			if (fileList.length() != 0) {
				String[] data = fileList.split("/");

				for (int i = 0; i < data.length; i++) {
					String sGUID = data[i].split(":")[0];
					String fileName = data[i].split(":")[1];
					String extension = fileName.substring(fileName.lastIndexOf(".") + 1);
					LOGGER.debug("sGUID:" + sGUID + ",fileName:" + fileName);

					File file = new File(pDirPath + commonUtil.separator + filePath + commonUtil.separator + sGUID + "."
							+ extension);

					file.delete();
				}
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			e.printStackTrace();
		}
		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/attachfiles] ended.");
		return result;
	}

	/**
	 * 첨부파일 다운로드
	 * 
	 * @param request
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/attachfiles", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
	public JSONObject downloadFile(HttpServletRequest request) {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/attachfiles] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, request.getParameter("userId"));
			String realPath = commonUtil.getRealPath(request);
			String uploadFilePath = commonUtil.getUploadPath("upload_project.ROOT", info.getTenantId());
			String filePath = request.getParameter("filePath");
			realPath += uploadFilePath + commonUtil.separator + "uploadFile" + filePath;

			LOGGER.debug("filePath on download : " + realPath);

			File file = new File(realPath);

			if (!file.exists() || !file.isFile()) {
				throw new FileNotFoundException(realPath);
			}

			int fileSize = (int) file.length();

			if (fileSize > 0) {
				byte[] bytes = Files.readAllBytes(Paths.get(realPath));

				JSONObject data = new JSONObject();

				data.put("bytes", bytes);
				data.put("fileSize", fileSize + "");

				result.put("status", "ok");
				result.put("code", 0);
				result.put("data", data);
			}
		} catch (FileNotFoundException e) {
			result.put("status", "fileNotFound");
			result.put("code", 1);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/attachfiles] ended.");
		return result;
	}

	/**
	 * 게시물 읽기
	 * 
	 * @param itemId
	 * @param request
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/boards/{itemId}", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
	public JSONObject getBoardDetail(@PathVariable int itemId, HttpServletRequest request) {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/boards/" + itemId + "] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			Long projectId = Long.parseLong(request.getParameter("projectId"));
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());

			Map<String, Object> param = new HashMap<String, Object>();

			param.put("itemId", itemId);
			param.put("lang", lang);
			
			Enumeration<String> parameterNames = request.getParameterNames();
			
			while (parameterNames.hasMoreElements()) {
				String parameterName = parameterNames.nextElement();
				param.put(parameterName, request.getParameter(parameterName));
			}
			
			ProjectBoardVO boardVO = ezPMSService.getBoardDetail(info.getTenantId(), param);

			int authority = ezPMSService.getUserProjectRole(userId, info.getTenantId(), projectId,
					info.getDeptId());

			LOGGER.debug("authority : " + authority);

			result.put("authority", authority);
			result.put("data", boardVO);
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("data", "");
			result.put("status", "error");
			result.put("code", 1);
			e.printStackTrace();
		}
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/boards/" + itemId + "] ended.");
		return result;
	}

	/**
	 * 첨부파일을 서버에 저장한다.
	 *
	 * @param file
	 * @param newName
	 * @param stordFilePath
	 * @throws Exception
	 */
	public void uploadFile(String byteArray, String newName, String storedFilePath) throws Exception {
		LOGGER.debug("ezPMS uploadFile started.");

		OutputStream bos = null;
		String storedFilePathReal = (storedFilePath == null ? "" : storedFilePath);

		try {
			File cFile = new File(storedFilePathReal);

			if (!cFile.isDirectory()) {
				boolean _flag = cFile.mkdirs();

				if (!_flag) {
					throw new IOException("Directory creation Failed ");
				}
			}

			bos = new FileOutputStream(storedFilePathReal + File.separator + newName);
			LOGGER.debug("###" + storedFilePathReal + File.separator + newName + "###");
			Decoder decoder = Base64.getDecoder();

			bos.write(decoder.decode(byteArray));
		} catch (FileNotFoundException fnfe) {
			LOGGER.debug("fnfe: {}", fnfe);
		} catch (IOException ioe) {
			LOGGER.debug("ioe: {}", ioe);
		} catch (Exception e) {
			LOGGER.debug("e: {}", e);
		} finally {

			if (bos != null) {

				try {
					bos.close();
				} catch (Exception ignore) {
					LOGGER.debug("IGNORED: {}", ignore.getMessage());
				}
			}
		}
		LOGGER.debug("ezPMS uploadFile ended.");
	}

	/**
	 * 게시판 조회자 목록 개수 출력
	 * 
	 * @param itemId
	 * @param request
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/boards/{itemId}/viewer-count", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getBoardViewerCount(@PathVariable String itemId, HttpServletRequest request) {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/boards/" + itemId + "/viewer-count] started.");

		JSONObject result = new JSONObject();

		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);

			int viewerCount = ezPMSService.getBoardViewerCount(info.getTenantId(), itemId);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", viewerCount + "");
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/boards/" + itemId + "/viewer-count] ended.");

		return result;
	}

	/**
	 * 게시물 조회자 리스트 출력
	 * 
	 * @param itemId
	 * @param request
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/boards/{itemId}/viewers", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getBoardViewerList(@PathVariable String itemId, HttpServletRequest request) {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/boards/" + itemId + "/viewers] started.");

		JSONObject result = new JSONObject();

		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());

			Map<String, Object> param = new HashMap<String, Object>();

			param.put("lang", lang);
			param.put("itemId", itemId);

			Enumeration<String> parameterNames = request.getParameterNames();

			while (parameterNames.hasMoreElements()) {
				String parameterName = parameterNames.nextElement();
				param.put(parameterName, request.getParameter(parameterName));
//				LOGGER.debug(parameterName + " : " + request.getParameter(parameterName));
			}

			List<BoardViewerVO> viewerList = ezPMSService.getBoardViewerList(info.getTenantId(), param);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", viewerList);
		} catch (Exception e) {
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/boards/" + itemId + "/viewers] ended.");

		return result;
	}

	/**
	 * 프로젝트 의견 리스트 출력
	 * 
	 * @param projectId
	 * @param userId
	 * @param request
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/comments/list/{projectId}/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getCommentList(@PathVariable String projectId, @PathVariable String userId,
			HttpServletRequest request) {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/comments/list/" + projectId + "/users/" + userId + "] started");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			String lang = commonUtil.getMultiData(info.getLang(), tenantId);

			String searchByUser = request.getParameter("searchByUser");
			String searchByContent = request.getParameter("searchByContent");

			Map<String, Object> param = new HashMap<String, Object>();

			param.put("lang", lang);
			param.put("tenantId", tenantId);
			param.put("projectId", projectId);
			
			Enumeration<String> parameterNames = request.getParameterNames();

			while (parameterNames.hasMoreElements()) {
				String parameterName = parameterNames.nextElement();
				param.put(parameterName, request.getParameter(parameterName));
//				LOGGER.debug(parameterName + " : " + request.getParameter(parameterName));
			}
			
			if (searchByUser != null && !searchByUser.equals("")) {
				searchByUser = searchByUser.replace("\\", "\\\\");
				searchByUser = searchByUser.replace("%", "\\%");
				searchByUser = searchByUser.replace("_", "\\_");
				param.put("searchByUser", searchByUser);
			}

			if (searchByContent != null && !searchByContent.equals("")) {
				searchByContent = searchByContent.replace("\\", "\\\\");
				searchByContent = searchByContent.replace("%", "\\%");
				searchByContent = searchByContent.replace("_", "\\_");
				param.put("searchByContent", searchByContent);
			}

			List<CommentVO> commentList = ezPMSService.getCommentList(param);

			String taskName = "";
			String taskId = request.getParameter("taskId");
			String groupId = request.getParameter("groupId");

			LOGGER.debug("taskId : " + taskId + ", groupId : " + groupId);

			if (taskId != null && groupId != null) {

				if (!taskId.equals("") && !taskId.equals("0")) {
					ProjectTaskVO taskVO = ezPMSService.getTaskDetails(Long.parseLong(taskId), tenantId, lang);
					taskName = taskVO.getTaskName();
				} else if (!groupId.equals("") && !groupId.equals("0")) {
					ProjectGroupVO groupVO = ezPMSService.getGroupDetails(Long.parseLong(groupId), tenantId,
							Long.parseLong(projectId));
					taskName = groupVO.getGroupName();
				}

			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", commentList);
			result.put("taskName", taskName);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			e.printStackTrace();
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/comments/list/" + projectId + "/users/" + userId + "] ended");
		return result;
	}

	/**
	 * 프로젝트 의견 개수 출력
	 * 
	 * @param projectId
	 * @param userId
	 * @param request
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/comments/list-count/{projectId}/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getCommentListCount(@PathVariable String projectId, @PathVariable String userId,
			HttpServletRequest request) {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/comments/list-count/" + projectId + "/users/" + userId + "] started");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);

			String searchByUser = request.getParameter("searchByUser");
			String searchByContent = request.getParameter("searchByContent");

			Map<String, Object> param = new HashMap<String, Object>();

			param.put("tenantId", info.getTenantId());

			Enumeration<String> parameterNames = request.getParameterNames();

			while (parameterNames.hasMoreElements()) {
				String parameterName = parameterNames.nextElement();
				param.put(parameterName, request.getParameter(parameterName));
//				LOGGER.debug(parameterName + " : " + request.getParameter(parameterName));
			}

			if (searchByUser != null && !searchByUser.equals("")) {
				searchByUser = searchByUser.replace("\\", "\\\\");
				searchByUser = searchByUser.replace("%", "\\%");
				searchByUser = searchByUser.replace("_", "\\_");
				param.put("searchByUser", searchByUser);
			}

			if (searchByContent != null && !searchByContent.equals("")) {
				searchByContent = searchByContent.replace("\\", "\\\\");
				searchByContent = searchByContent.replace("%", "\\%");
				searchByContent = searchByContent.replace("_", "\\_");
				param.put("searchByContent", searchByContent);
			}

			int totalCount = ezPMSService.getCommentListCount(param);

			result.put("data", totalCount + ""); // JSON으로 넘기면 숫자가 Long으로 바뀌는데
													// Long에서 int로 cast할 때의 오류를
													// 피하기 위해서 String으로 바꾼 후에
													// 파싱한다
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("data", "");
			result.put("status", "error");
			result.put("code", 1);
			e.printStackTrace();
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/comments/list-count/" + projectId + "/users/" + userId + "] ended");
		return result;
	}

	/**
	 * 프로젝트 의견 추가
	 * 
	 * @param request
	 * @param jsonParam
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/comments", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject addComment(HttpServletRequest request, @RequestBody JSONObject jsonParam) {
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/comments] started");

		JSONObject result = new JSONObject();
		
//		Stream keyStream = jsonParam.keySet().stream().sorted();
//		keyStream.forEach(key -> LOGGER.debug(key + " : " + jsonParam.get(key)));
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, (String)jsonParam.get("writerId"));
			jsonParam.put("tenantId", info.getTenantId());
			
			ezPMSService.addComment(jsonParam);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			e.printStackTrace();
		}

		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/comments] ended");
		return result;
	}

	/**
	 * 프로젝트 의견 삭제
	 * 
	 * @param request
	 * @param jsonParam
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/comments", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject deleteComment(HttpServletRequest request, @RequestBody JSONObject jsonParam) {
		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/comments] started");

		JSONObject result = new JSONObject();

//		Stream keyStream = jsonParam.keySet().stream().sorted();
//		keyStream.forEach(key -> LOGGER.debug(key + " : " + jsonParam.get(key)));
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, (String) jsonParam.get("userId"));
			ezPMSService.deleteComment(info.getTenantId(), jsonParam);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			e.printStackTrace();
		}

		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/comments] ended");
		return result;
	}

	/**
	 * 프로젝트 의견 수정
	 * 
	 * @param request
	 * @param jsonParam
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/comments", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject modifyComment(HttpServletRequest request, @RequestBody JSONObject jsonParam) {
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/comments] started");

		JSONObject result = new JSONObject();

//		Stream keyStream = jsonParam.keySet().stream().sorted();
//		keyStream.forEach(key -> LOGGER.debug(key + " : " + jsonParam.get(key)));
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, (String) jsonParam.get("userId"));
			jsonParam.put("tenantId", info.getTenantId());
			ezPMSService.modifyComment(jsonParam);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/comments] ended");
		return result;
	}

	/**
	 * 시스템 파라미터 출력
	 * 
	 * @param userId
	 * @param request
	 * @return
	 */
	// tbl_tenant_config에서 SysParam을 가져오는 함수. 사실 이 패키지가 아닌 ezSystem에 있어야할 듯
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/sysParams/{userId}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject getSysParam(@PathVariable String userId, HttpServletRequest request) {
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/sysParams/" + userId + "] started");

		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);

			List<SysParamVO> configList = ezSystemAdminService.getSysParam(info.getTenantId());

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", configList);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			e.printStackTrace();
		}

		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/sysParams/" + userId + "] ended");

		return result;
	}

	/**
	 * 게시물 답변 존재 여부 출력
	 * 
	 * @param request
	 * @param jsonParam
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/boards/checkIfHasReplies", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject checkIfBoardHasReplies(HttpServletRequest request, @RequestBody JSONObject jsonParam) {
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/boards/checkIfHasReplies] started");

		JSONObject result = new JSONObject();

//		Stream keyStream = jsonParam.keySet().stream().sorted();
//		keyStream.forEach(key -> LOGGER.debug(key + " : " + jsonParam.get(key)));
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, (String) jsonParam.remove("userId"));
			jsonParam.put("tenantId", info.getTenantId());

			boolean ifBoardHasReplies = ezPMSService.checkIfBoardHasReplies(jsonParam);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", ifBoardHasReplies);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			e.printStackTrace();
		}

		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/boards/checkIfHasReplies] ended");
		return result;
	}

	/**
	 * 업무 선행작업 존재 유무 출력
	 * 
	 * @param request
	 * @param jsonParam
	 * @param pretaskId
	 * @return
	 */
//	@SuppressWarnings("unchecked")
//	@RequestMapping(value = "/rest/ezPMS/tasks/checkIfExistPreTaskRel/{pretaskId}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
//	public JSONObject checkIfPreTaskRelExist(HttpServletRequest request, @RequestBody JSONObject jsonParam,
//			@PathVariable int pretaskId) {
//		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/tasks/checkIfExistPreTaskRel/" + pretaskId + "] started");
//
//		JSONObject result = new JSONObject();
//
//		try {
//			String serverName = request.getHeader("x-user-host");
//			MCommonVO info = mOptionService.commonInfoWeb(serverName, (String) jsonParam.remove("userId"));
//			jsonParam.put("tenantId", info.getTenantId());
//
//			boolean ifExistPreTaskRel = ezPMSService.checkIfPreTaskRelExist(jsonParam);
//
//			result.put("status", "ok");
//			result.put("code", 0);
//			result.put("data", ifExistPreTaskRel);
//		} catch (Exception e) {
//			result.put("status", "error");
//			result.put("code", 1);
//			result.put("data", "");
//			e.printStackTrace();
//		}
//
//		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/tasks/checkIfExistPreTaskRel/" + pretaskId + "] ended");
//		return result;
//	}

	/**
	 * 업무 선행작업 삭제
	 * 
	 * @param taskId
	 * @param preTaskId
	 * @param jsonParam
	 * @param request
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/tasks/{taskId}/preTasks/{pretaskId}", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject deletePreTaskRel(@PathVariable long taskId, @PathVariable int pretaskId,
			@RequestBody JSONObject jsonParam, HttpServletRequest request) {
		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/tasks/" + taskId + "/pretasks/" + pretaskId + "] started");

		JSONObject result = new JSONObject();

//		Stream keyStream = jsonParam.keySet().stream().sorted();
//		keyStream.forEach(key -> LOGGER.debug(key + " : " + jsonParam.get(key)));
		
		try {
			String serverName = request.getHeader("x-user-host");
			String userId = (String) jsonParam.remove("userId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			Long projectId = Long.parseLong((String) jsonParam.remove("projectId"));

			String roleCheck = "";

			jsonParam.put("tenantId", tenantId);
			jsonParam.put("pretaskId", pretaskId);
			jsonParam.put("taskId", taskId);
			
			// 권한 체크
			// 1. 프로젝트의 담당자인지 아닌지 확인 (여러개 있을 때, 하나라도 들어가있으면 return)
			int userProjectRole = ezPMSService.getUserProjectRole(userId, tenantId, projectId, info.getDeptId());
			if (userProjectRole == 1) {
				roleCheck = "permitted";
			} else {
				roleCheck = "rejected";
			}
			
			if (roleCheck.equals("permitted")) {
				ezPMSService.deletePreTaskRelInTask(jsonParam);
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", roleCheck);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			e.printStackTrace();
		}

		LOGGER.debug("ezPMS G/W [DELETE /rest/ezPMS/tasks/" + taskId + "/pretasks/" + pretaskId + "] ended");
		return result;
	}

	/**
	 * 간트차트 모든 그룹/업무 일정 업데이트
	 * 
	 * @param userId
	 * @param jsonParam
	 * @param request
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/rest/ezPMS/allSchedules/users/{userId}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject updateAllSchedules(@PathVariable String userId, @RequestBody JSONObject jsonParam,
			HttpServletRequest request) {
		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/allSchedules/users/" + userId + "] started");

		JSONObject result = new JSONObject();
		
//		Stream keyStream = jsonParam.keySet().stream().sorted();
//		keyStream.forEach(key -> LOGGER.debug(key + " : " + jsonParam.get(key)));

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();

			Long projectId = Long.parseLong((String) jsonParam.get("projectId"));

			List<LinkedHashMap> taskSchedules = (List<LinkedHashMap>) jsonParam.get("allTasks");
			List<LinkedHashMap> groupSchedules = (List<LinkedHashMap>) jsonParam.get("allGroups");
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("tenantId", tenantId);
			map.put("projectId", projectId);
			map.put("taskSchedules", taskSchedules);

			ezPMSService.updateAllTaskDatesInPrj(map);

			map.remove("taskSchedules");
			map.put("groupSchedules", groupSchedules);

			ezPMSService.updateAllGroupDatesInPrj(map);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			e.printStackTrace();
		}

		LOGGER.debug("ezPMS G/W [PUT /rest/ezPMS/allSchedules/users/" + userId + "] ended");
		return result;
	}

	/**
	 * 업무 그룹 멤버 리스트 출력
	 * 
	 * @param projectId
	 * @param groupId
	 * @param request
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/member-list/{projectId}/groupId/{groupId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getGroupMemberList(@PathVariable Long projectId, @PathVariable Long groupId,
			HttpServletRequest request) {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/member-list/" + projectId + "/groupId/" + groupId + "] started");

		JSONObject result = new JSONObject();
	
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));

			int tenantId = info.getTenantId();
			String lang = commonUtil.getMultiData(info.getLang(), tenantId);

			List<ProjectGroupMemberVO> memberList = ezPMSService.getGroupMemberList(projectId, tenantId, groupId);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", memberList);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/member-list/" + projectId + "/groupId/" + groupId + "] ended");
		return result;
	}
}
