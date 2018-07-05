package egovframework.ezEKP.ezPMS.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.internet.InternetAddress;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.tomcat.jni.Status;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezBoard.vo.BoardListHeaderVO;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezPMS.vo.ProjectPagination;
import egovframework.ezMobile.ezCommon.web.MCommonGWController;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzPMSController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(EzPMSController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EgovFileScrty egovFileScrty;
	
	@Autowired
	private Properties config;

	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name = "EzEmailService")
	private EzEmailService ezEmailService;

	@Autowired
	private EzOrganService ezOrganService;	
	/**
	 * 프로젝트 관리 메인화면 호출함수
	 */
	@RequestMapping(value="/ezPMS/pmsMain.do")
	public String main() {
		return "ezPMS/pmsMain";
	}
	
	/**
	 * 프로젝트관리 왼쪽화면 호출함수
	 * @return
	 */
	@RequestMapping(value="/ezPMS/pmsLeft.do")
	public String left(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		model.addAttribute("mode", request.getParameter("mode"));
		return "ezPMS/pmsLeft";
	}
	
	/**
	 * 메인페이지화면 호출 함수
	 */
	@RequestMapping(value = "/ezPMS/pmsProjectListMain.do")
	public String projectList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		
		LOGGER.debug("ezPMS projectList started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		
		String settingUrl = "/rest/ezPMS/users/" + userId + "/setting";
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userIdType", "user");
		
		JSONObject settingResult = commonUtil.getJsonFromRestApi(settingUrl, param, request, "get", null);
		String settingStatus = settingResult.get("status").toString();
	
		if(settingStatus.equals("ok")) {
			JSONObject listSetting = (JSONObject) settingResult.get("data");
			model.addAttribute("listSetting", listSetting);
		}
		
		LOGGER.debug("ezPMS projectList ended");
		return "ezPMS/pmsProjectListMain";
	}
	
	@RequestMapping(value = "/ezPMS/getProjectList.do")
	public String getProjectList(@CookieValue("loginCookie") String loginCookie,@RequestBody Map<String, Object> param, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
	
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String viewType = param.get("viewType").toString();
		int currentPage = (int) param.remove("currentPage");
		int listNumber = Integer.parseInt(param.get("listNumber").toString());
		String projectSort = param.get("projectSort").toString();
		String listProjectStatus = param.get("listProjectStatus").toString();
		String deptId = userInfo.getDeptID();
		
		if(projectSort == null || projectSort.equals("")) {
			projectSort = "0";
		}
		
		String url = "/rest/ezPMS/projects/userId/"+userId;
		String countUrl = "/rest/ezPMS/projects/userId/" + userId + "/count";
		
		param.put("userIdType", "user");
		param.put("projectSort", projectSort);
		param.put("deptId", deptId);
		
		JSONObject countResult = commonUtil.getJsonFromRestApi(countUrl, param, request, "get", null);
		String countStatus = countResult.get("status").toString();
		
		int projectListCount = 0;
		JSONArray projectList = new JSONArray();
		
		if (countStatus.equals("ok")) {
			JSONObject countJson = (JSONObject) countResult.get("data");
			
			if (countJson.get("projectListCount").toString() != null) {
				projectListCount = Integer.parseInt(countJson.get("projectListCount").toString());
				model.addAttribute("projectListCount", projectListCount);
				
				ProjectPagination paging = new ProjectPagination(projectListCount, listNumber, 10, currentPage);
				model.addAttribute("paging", paging);
				
				if (projectListCount != 0) {
					//현재 페이지
					param.put("currentPage", currentPage);
					//프로젝트 총 개수
					param.put("listCount", projectListCount);
					
					if (viewType.equals("1")) {
						param.put("startCount", paging.getStartCount());
					} else {
						param.put("startCount", param.get("startRow"));
					}
					
					//header 정렬 프로젝트 순서
					if (param.get("orderWhat") == null || param.get("orderWhat").equals("")) {
						param.put("orderWhat", "init");
					}
					
					JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "get", null);
					String status = result.get("status").toString();
					
					if (status.equals("ok")) {		
						projectList = (JSONArray) result.get("data");
						
						model.addAttribute("viewType", viewType);
					}
				}
			}
			
			model.addAttribute("listProjectStatus", listProjectStatus);
			model.addAttribute("projectList", projectList);
			model.addAttribute("projectListCount", projectListCount);
			
			if(viewType.equals("1")) {
				viewType = "Board";
			} else {
				viewType = "Memo";
			}
		}
		
		LOGGER.debug("[result] projectSort : " + projectSort + ", projectLsitCount : " + projectListCount + ", currentPage : " + currentPage + ", listNumber : " + listNumber);
		return "ezPMS/pmsProjectList" + viewType;
	}
	/**
	 * 나의 업무 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPMS/pmsMyTask.do")
	public String myTaskPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS MyTask page started");
		LOGGER.debug("ezPMS MyTask page ended");
		return "ezPMS/pmsMyTask";
	}
	
	/**
	 * 프로젝트관리 환경설정 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPMS/pmsSetting.do")
	public String pmsSetting(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS Setting started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		
		String url = "/rest/ezPMS/users/" + userId + "/setting";
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userIdType", "user");
		
		JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "get", null);
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONObject setting = (JSONObject) result.get("data");
			
			model.addAttribute("setting", setting);
		}
		
		LOGGER.debug("ezPMS Setting started");
		return "ezPMS/pmsSetting";
	}
	
	/**
	 * 프로젝트 상세 조회 화면 호출
	 */
	@RequestMapping(value = "/ezPMS/getProjectDetails.do")
	public String getProjectDetails(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS getProjectDetails started");	
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String projectId = request.getParameter("projectId");
		String userId = userInfo.getId();
		
		String url = "/rest/ezPMS/projects/" + projectId + "/userId/" + userId;
		JSONObject result = commonUtil.getJsonFromRestApi(url, null, request, "get", null);
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONObject json = (JSONObject) result.get("data");
			JSONObject project = (JSONObject) json.get("project");
			
			model.addAttribute("project", project);
		}
		
		LOGGER.debug("ezPMS getProjectDetails ended");		
		return "ezPMS/pmsProjectDetails";
	}
	
	/**
	 * 프로젝트 등록/수정 화면 호출
	 */
	@RequestMapping(value = "/ezPMS/newProject.do")
	public String newProject(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS addNewProject started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userName = userInfo.getDisplayName1();
		String userId = userInfo.getId();
		String mode = request.getParameter("mode");
		
		String planStartDate = "";
		String planEndDate = "";
		long projectId = 0;
		
		if (mode.equals("new")) {
			String nowDate = commonUtil.getTodayUTCTime("yyyy-MM-dd");
			planStartDate = nowDate;
			planEndDate = nowDate;
		} else if (mode.equals("edit")) {
			projectId = Long.parseLong(request.getParameter("projectId"));
			long groupId = Long.parseLong(request.getParameter("groupId"));
			
			String url = "/rest/ezPMS/projects/" + projectId + "/userId/" + userId; 

			Map<String, Object> param = new HashMap<String, Object>();
			param.put("mode", mode);
			
			JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "get", null);
			String status = result.get("status").toString();
			
			if (status.equals("ok")) {
				JSONObject resultJson = (JSONObject) result.get("data");
				JSONObject project = (JSONObject) resultJson.get("project");
				
				model.addAttribute("project", project);
				model.addAttribute("groupId", groupId);
			}
			
		}
		
		model.addAttribute("mode", mode);
		model.addAttribute("userName", userName);
		model.addAttribute("planStartDate", planStartDate);
		model.addAttribute("planEndDate", planEndDate);
		
		LOGGER.debug("ezPMS addNewProject ended");
		return "ezPMS/newProject";
	}
	
	/**
	 * 새로운 프로젝트 추가
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezPMS/addNewProject.do")
	@ResponseBody
	public JSONObject addNewProject(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> param, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS addNewProject started");

		long projectId = 0;
		long groupId = 0;
		JSONObject json = new JSONObject();
		
		try{
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			String url = "/rest/ezPMS/projects";
			String today = commonUtil.getTodayUTCTime("yyyy-MM-dd");
			
			param.put("createDate", today);
			param.put("userId", userInfo.getId());
			
			JSONObject jsonList = new JSONObject();
			jsonList.put("managerList", param.get("managerList"));
			jsonList.put("participantList", param.get("participantList"));
			jsonList.put("viewerList", param.get("viewerList"));
			
			param.remove("managerList");
			param.remove("participantList");
			param.remove("viewerList");
			
			JSONObject result = new JSONObject(); 
			
			if (param.get("mode").equals("new")) {
				result = commonUtil.getJsonFromRestApi(url, param, request, "post", jsonList);
				JSONObject resultValue = (JSONObject) result.get("data");
				projectId = Long.parseLong(resultValue.get("projectId").toString());
				groupId = Long.parseLong(resultValue.get("groupId").toString());
				
			} else if (param.get("mode").equals("edit")) {
				projectId = Long.parseLong(param.get("projectId").toString());
				groupId = Long.parseLong(param.get("groupId").toString());
				url += "/" + projectId;
				result = commonUtil.getJsonFromRestApi(url, param, request, "put", jsonList);
			}
			
			json.put("projectId", projectId);
			json.put("groupId", groupId);
			
			LOGGER.debug("projectId : " + projectId + ", groupId : " + groupId);
		} catch(Exception e) {
			e.printStackTrace();
			LOGGER.debug("ERROR : " + e.getMessage());
		}
		
		LOGGER.debug("ezPMS addNewProject ended");
		return json;
	}
	
	/**
	 * 프로젝트 삭제
	 * @param loginCookie
	 * @param request
	 * @param resp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezPMS/deleteProject.do")
	@ResponseBody
	public String deleteProject(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> param, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS deleteProject started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		
		String projectId = param.get("projectList").toString();
		String url = "/rest/ezPMS/projects/" + projectId;
		
		param.put("userId", userId);
		
		JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "delete", null);
		String data = result.get("data").toString();	
		
		LOGGER.debug("ezPMS deleteProject ended");
		return data;
	}
	
	/**
	 * 프로젝트관리 메인 화면 환경설정
	 * @param loginCookie
	 * @param request
	 * @param resp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezPMS/updateMainSetting.do")
	@ResponseBody
	public String updateMainSetting(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> param, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS updateMainSetting started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String url = "/rest/ezPMS/users/" + userId + "/setting";
		
		JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "put", null);
		String status = result.get("status").toString();
		
		LOGGER.debug("ezPMS updateMainSetting ended");
		return status;
	}
	
	/**
	 * 프로젝트 상태변경 화면 호출
	 */
	@RequestMapping(value = "/ezPMS/changeProjectStatus.do")
	public String changeProjectStatus(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS changeProjectStatus started");
		LOGGER.debug("ezPMS changeProjectStatus ended");
		return "ezPMS/changeProjectStatus";
	}
	
	/**
	 * 프로젝트 상태 변경 실행
	 * @param loginCookie
	 * @param request
	 * @param resp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezPMS/updateProjectStatus.do")
	@ResponseBody
	public String updateProjectStatus(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> param, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS updateProjectStatus started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String changeDate = commonUtil.getTodayUTCTime("yyyy-MM-dd");
		
		String projectIdList = param.get("projectList").toString();
		String url = "/rest/ezPMS/projects/" + projectIdList + "/status";
		
		param.put("userId", userId);
		param.put("changeDate", changeDate);
		
		JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "put", null);
		String status = result.get("status").toString();
		String data = "";
		
		if (status.equals("ok")) {
			data = result.get("data").toString();
		}			
		
		LOGGER.debug("ezPMS updateProjectStatus ended");
		return data;
	}
	
	/**
	 * 프로젝트 개요 정보 출력
	 * @param loginCookie
	 * @param request
	 * @param resp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezPMS/getProjectOverview.do")
	public String getProjectOverview(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS getProjectOverview started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String projectId = request.getParameter("projectId");
		
		String url = "/rest/ezPMS/projects/" + projectId + "/userId/" + userId;
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		
		JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "get", null);
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONObject resultJson = (JSONObject) result.get("data");
			JSONObject project = (JSONObject) resultJson.get("project");
			JSONObject mainSetting = (JSONObject) resultJson.get("mainSetting");
			
			String kanbanOrder = resultJson.get("kanbanOrder").toString();
			int userRole = Integer.parseInt(resultJson.get("userRole").toString());
			
			model.addAttribute("project", project);
			model.addAttribute("kanbanOrder", kanbanOrder);
			model.addAttribute("userRole", userRole);
			model.addAttribute("mainSetting", mainSetting);
		}
		
		LOGGER.debug("ezPMS getProjectOverview ended");		
		return "ezPMS/pmsProjectOverview";
	}
	
	/**
	 * 프로젝트 참여 멤버 조회
	 * @param loginCookie
	 * @param request
	 * @param resp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezPMS/getProjectMember.do")
	public String getProjectMember(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS getProjectMember started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String projectId = request.getParameter("projectId");
		String roleId = request.getParameter("roleId");
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		
		String url = "/rest/ezPMS/projects/" + projectId + "/roles/" + roleId;
		
		JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "get", null);
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONObject json = (JSONObject) result.get("data");
			JSONArray memberList = (JSONArray) json.get("memberList");
			int memberCount = memberList.size();
			
			model.addAttribute("roleId", roleId);
			model.addAttribute("memberList", memberList);
			model.addAttribute("memberCount", memberCount);
		}
		
		LOGGER.debug("ezPMS getProjectMember ended");			
		return "ezPMS/pmsProjectMember";
	}
	
	/**
	 * 업무 목록 조회
	 * @param loginCookie
	 * @param request
	 * @param resp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezPMS/getTaskList.do")
	@ResponseBody
	public JSONObject getTaskList(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> param, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS getTaskList started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		long projectId = Long.parseLong(param.get("projectId").toString());
		String userId = userInfo.getId();
		String kanbanOrder = param.get("kanbanOrder").toString();	
		
		String url = "/rest/ezPMS/task-list/" + projectId + "/users/" + userId;
		String countUrl = "/rest/ezPMS/projects/" + projectId + "/tasks/count";
		
		JSONObject json = new JSONObject();
		if (!kanbanOrder.equals("") || kanbanOrder != null) {
			String[] kanbanStatus = kanbanOrder.split(",");
			for (int i = 0; i < kanbanStatus.length; i++) {
				if (kanbanStatus[i].contains("M")) {
					kanbanStatus[i] = kanbanStatus[i].substring(kanbanStatus[i].length()-1);
					param.put("isMyTask", "M");
				} else {
					param.put("isMyTask", "A");
				}
				
				param.put("userId", userId);
				param.put("status", kanbanStatus[i]);
				
				if (kanbanStatus[i].equals("B")) {
					String boardCountUrl = "/rest/ezPMS/boards/list-count/" + projectId + "/users/" + userId;
					JSONObject boardCountResult = commonUtil.getJsonFromRestApi(boardCountUrl, param, request, "get", null);
					String boardCountStatus = boardCountResult.get("status").toString();
					
					if (boardCountStatus.equals("ok")) {
						String boardCount = boardCountResult.get("data").toString();
						
						json.put("kanbanTaskCount" + (i + 1), boardCount);
						
						if (!boardCount.equals("0")) {
							String boardUrl = "/rest/ezPMS/boards/list/" + projectId + "/users/" + userId;
							JSONObject boardResult = commonUtil.getJsonFromRestApi(boardUrl, param, request, "get", null);
							String boardStatus = boardResult.get("status").toString();
							
							if (boardStatus.equals("ok")) {
								JSONArray boardList = (JSONArray) boardResult.get("data");
								json.put("kanbanTask" + (i + 1), boardList);
							}
						}
					}
				}  else {
					JSONObject countResult = commonUtil.getJsonFromRestApi(countUrl, param, request, "get", null);
					String countStatus = countResult.get("status").toString();
					
					if (countStatus.equals("ok")) {
						long taskCount = (Long) countResult.get("data");
						
						json.put("kanbanTaskCount" + (i + 1), taskCount);
						
						if (taskCount != 0) {
							JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "get", null);
							String status = result.get("status").toString();
							
							if (status.equals("ok")) {
								JSONObject data = (JSONObject) result.get("data");
								json.put("kanbanTask" + (i + 1), data.get("taskList"));
							}
						}
					}
				}
			}
		}
		LOGGER.debug("ezPMS getTaskList ended");			
		return json;
	}
	
	/**
	 * 칸반 환경설정 화면 호출
	 */
	@RequestMapping(value = "/ezPMS/kanbanSetting.do")
	public String kanbanSetting(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp, Model mode) throws Exception {
		LOGGER.debug("ezPMS kanbanSetting started");	
		
		LOGGER.debug("ezPMS kanbanSetting ended");
		return "ezPMS/pmsKanbanSetting";
	}
	
	/**
	 * 칸반 순서 변경
	 * @param loginCookie
	 * @param request
	 * @param resp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezPMS/changeKanbanOrder.do")
	@ResponseBody
	public String changeKanbanOrder(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> param, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS changeKanbanOrder started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String projectId = param.get("projectId").toString();
		String userId = userInfo.getId();
		String url = "/rest/ezPMS/projects/" + projectId + "/userId/" + userId + "/order";
		
		commonUtil.getJsonFromRestApi(url, param, request, "put", null);
		
		LOGGER.debug("ezPMS changeKanbanOrder ended");		
		return null;
	}
	
	/**
	 * 즐겨찾기 추가
	 * @param loginCookie
	 * @param request
	 * @param resp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezPMS/addFavoriteProject.do")
	@ResponseBody
	public String addFavoriteProject(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> param, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS addFavoriteProject started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String projectIdList = param.get("projectList").toString();
		String userId = userInfo.getId();
		String url = "/rest/ezPMS/userId/" + userId + "/favorites/" + projectIdList;
		
		JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "post", null);
		
		String status = result.get("status").toString();
		String addResult = "";
		
		if (status.equals("ok")) {
			addResult = result.get("data").toString();
		}
		
		LOGGER.debug("ezPMS addFavoriteProject ended");			
		return addResult;
	}
	
	/**
	 * 즐겨찾기 해제
	 * @param loginCookie
	 * @param request
	 * @param resp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezPMS/deleteFavoriteProject.do")
	public String deleteFavoriteProject(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> param, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS deleteFavoriteProject started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String projectId = param.get("projectList").toString();
		String userId = userInfo.getId();
		
		String url = "/rest/ezPMS/userId/" + userId + "/favorites/" + projectId;
		
		commonUtil.getJsonFromRestApi(url, param, request, "delete", null);
		
		LOGGER.debug("ezPMS deleteFavoriteProject ended");				
		return null;
	}
	
	/**
	 * 작업 이력 추가
	 * @param loginCookie
	 * @param request
	 * @param resp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezPMS/addTaskLog.do")
	public String addTaskLog(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> param, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS addTaskLog started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		long projectId = Long.parseLong(param.get("projectId").toString());
		String userId = userInfo.getId();
		
		param.put("userId", userId);
		String logDate = commonUtil.getTodayUTCTime("");
		param.put("logDate", logDate);
		
		String url = "/rest/ezPMS/projects/" + projectId + "/logs";
		
		commonUtil.getJsonFromRestApi(url, param, request, "post", null);
		
		LOGGER.debug("ezPMS addTaskLog ended");
		
		return null;
	}
	
	/**
	 * 작업이력 리스트 페이지 호출
	 * @param loginCookie
	 * @param request
	 * @param resp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezPMS/getTaskLogMain.do")
	public String getTaskLogMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS getTaskLogMain started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String projectId = request.getParameter("projectId");
		String onlyGroup = request.getParameter("onlyGroup");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		param.put("onlyGroup", onlyGroup);
		param.put("location", "taskLog");
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/tree/" + projectId + "/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			JSONArray treeData = (JSONArray) resultBody.get("data");
			model.addAttribute("data", treeData);
		}
		
		model.addAttribute("projectId", request.getParameter("projectId"));
		
		LOGGER.debug("ezPMS getTaskLogMain ended");				
		return "ezPMS/pmsTaskLogMain";
	}
	
	/**
	 * 작업이력 리스트
	 * @param loginCookie
	 * @param request
	 * @param resp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezPMS/getTaskLogList.do")
	public String getTaskLogList(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> param, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS getTaskLogList started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		long projectId = Long.parseLong(param.get("projectId").toString());
		String userId = userInfo.getId();
		param.put("userId", userId);

		String url = "/rest/ezPMS/projects/" + projectId + "/logs";
		String countUrl = "/rest/ezPMS/projects/" + projectId + "/logs/count";
		
		JSONObject countResult = commonUtil.getJsonFromRestApi(countUrl, param, request, "get", null);
		String countStatus = countResult.get("status").toString();
		int logListCount = 0;
		int listNumber = Integer.parseInt(param.get("listNumber").toString());
		int currentPage = Integer.parseInt(param.get("currentPage").toString());
		
		if (countStatus.equals("ok")) {
			JSONObject countJson = (JSONObject) countResult.get("data");
			System.out.println(countJson.get("taskLogListCount").toString());
			if (countJson.get("taskLogListCount").toString() != null) {
				logListCount = Integer.parseInt(countJson.get("taskLogListCount").toString());
				model.addAttribute("taskLogListCount", logListCount);
				model.addAttribute("contentTitle", projectId);
				ProjectPagination paging = new ProjectPagination(logListCount, listNumber, 10, currentPage);
				model.addAttribute("paging", paging);
				
				if (logListCount != 0) {
					//현재 페이지
					param.put("currentPage", currentPage);
					//한 페이지에 보여질 개수
					param.put("listNumber", listNumber);
					//프로젝트 총 개수
					param.put("listCount", logListCount);
					param.put("startCount", paging.getStartCount());
					
					//header 정렬 프로젝트 순서
					if (param.get("orderWhat") == null || param.get("orderWhat").equals("")) {
						param.put("orderWhat", "init");
					}
					
					if (param.get("orderHow") == null || param.get("orderHow").equals("")) {
						param.put("orderHow", "asc");
					}
					
					JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "get", null);
					String status = result.get("status").toString();
		
					if (status.equals("ok")) {
						JSONObject data = (JSONObject) result.get("data");
						model.addAttribute("logList", data.get("taskLogList"));
						model.addAttribute("groupDetails", data.get("groupDetails"));
						model.addAttribute("taskDetails", data.get("taskDetails"));
					}
				} else {
					if (param.get("taskId").toString().equals("0")) {
						long groupId = Long.parseLong(param.get("groupId").toString());
						String groupUrl = "/rest/ezPMS/groups/" + groupId + "/users/" + userId;
						
						param.put("projectId", projectId);
						
						JSONObject result = commonUtil.getJsonFromRestApi(groupUrl, param, request, "get", null);
						String status = result.get("status").toString();
						
						if (status.equals("ok")) {
							JSONObject groupDetails = (JSONObject) result.get("data");
							model.addAttribute("groupDetails", groupDetails);
							model.addAttribute("taskDetails", "{}");
						}
					} else {
						long taskId = Long.parseLong(param.get("taskId").toString());
						String taskUrl = "/rest/ezPMS/tasks/" + taskId + "/users/" + userInfo.getId();
						
						param.put("projectId", projectId);
						
						JSONObject result = commonUtil.getJsonFromRestApi(taskUrl, param, request, "get", null);
						String status = result.get("status").toString();
						
						if (status.equals("ok")) {
							JSONObject taskDetails = (JSONObject) result.get("data");
							model.addAttribute("taskDetails", taskDetails);
							model.addAttribute("groupDetails", "{}");
						}
					}
				}
			}
		}
		LOGGER.debug("ezPMS getTaskLogList ended");				
		return "ezPMS/pmsTaskLogList";
	}
	
	/**
	 * 담당자, 참여자, 조회자 선택화면 호출
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezPMS/pmsSelectAuth.do")
	public String selectAuth(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		LOGGER.debug("selectAuth started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		JSONObject result = commonUtil.getJsonFromRestApi("/rest/ezPMS/depts", param, request, "get", null);
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray deptList = (JSONArray) result.get("data");
			
			for (int i = 0; i < deptList.size(); i++) {
				JSONObject dept = (JSONObject) deptList.get(i);
				
				if (dept.get("isComp").equals("comp")) {
					dept.put("icon", "icon-company");
				} else {
					dept.put("icon", "icon-dept");
				}
				
				if (dept.get("myDept").equals("yes")) {
					JSONObject state = new JSONObject();
					state.put("selected", "true");
					state.put("opened", "true");
					dept.put("state", state);
				}
			}
			
			model.addAttribute("type", request.getParameter("type"));
			model.addAttribute("deptList", deptList);
			model.addAttribute("userId", userInfo.getId());
			model.addAttribute("userName", userInfo.getDisplayName1());
			model.addAttribute("userDept", userInfo.getDeptName1());
		}		
		LOGGER.debug("selectAuth ended");
		return "/ezPMS/pmsSelectAuth";
	}
	
	/**
	 * 사원리스트
	 */
	@RequestMapping(value = "/ezPMS/userList.do")
	public String userList(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie){
		LOGGER.debug("userList started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		String key = request.getParameter("key");
		param.put("key",key );
		param.put("value", request.getParameter("value"));
		param.put("userId", userInfo.getId());
		
		LOGGER.debug(request.getParameter("key"));
		LOGGER.debug(request.getParameter("value"));
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/users", param, request,"get",null);
		String status = resultBody.get("status").toString();
		if (status.equals("ok")) {		
			JSONArray userList = (JSONArray) resultBody.get("data");
			
			model.addAttribute("userList", userList);
			
			String keyword = "";
			if (key.equals("DEPARTMENT")) {
//				keyword = (String) ((JSONObject)userList.get(0)).get("deptName");
				keyword = request.getParameter("deptName");
			} else{
				keyword = egovMessageSource.getMessage("ezPMS.t1", userInfo.getLocale());
			}
			int userCount = 0;
			if (userList.size() == 0 && !key.equals("DEPARTMENT")) {
				keyword = egovMessageSource.getMessage("ezPMS.t2", userInfo.getLocale());
			} else {
				userCount = userList.size();
			}
			model.addAttribute("keyword",keyword);
			model.addAttribute("userCount",userCount);
		}
		
		LOGGER.debug("userList ended");
		return "ezPMS/userList";
	}
	
	/**
	 * 프로젝트 총괄 책임자 선택 화면 호출
	 */
	@RequestMapping(value="/ezPMS/selectHeadManager.do")
	public String selectHeadManager(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {
		LOGGER.debug("selectHeadManager started");
		LOGGER.debug("selectHeadManager ended");
		return "ezPMS/selectHeadManager";
	}
	
	/**
	 * 프로젝트 총괄 책임자 선택 화면 호출
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezPMS/getDeptUserList.do")
	@ResponseBody
	public JSONObject getDeptUserList(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {
		LOGGER.debug("getDeptUserList started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		Map<String, Object> param = new HashMap<String, Object>();
		String key = request.getParameter("key");
		param.put("key",key );
		param.put("value", request.getParameter("value"));
		param.put("userId", userInfo.getId());
		param.put("lang", userInfo.getLang());
		
		LOGGER.debug(request.getParameter("key"));
		LOGGER.debug(request.getParameter("value"));
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/users", param, request,"get",null);
		String status = resultBody.get("status").toString();
		
		JSONObject result = new JSONObject();
		
		if (status.equals("ok")) {		
			JSONArray userList = (JSONArray) resultBody.get("data");
			
			result.put("userList", userList);
			
		}
		
		LOGGER.debug("getDeptUserList ended");
		return result;
	}
	
	// 알림메일 발송
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezPMS/sendNotiMail.do")
	@ResponseBody
	public String sendNotiMail(@RequestBody Map<String, Object> param, HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {
		LOGGER.debug("sendNotiMail Started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String mode = param.get("mode").toString();
		String projectName = (String) param.get("projectName");
		long projectId = Long.parseLong(param.get("projectId").toString());
		List<Map<String, Object>> managerList = null;
		List<Map<String, Object>> participantList = null;
		List<Map<String, Object>> viewerList = null;
		List<Map<String, Object>> beforeManagerList = null;
		List<Map<String, Object>> beforeParticipantList = null;
		List<Map<String, Object>> beforeViewerList = null;
		
		param.put("tenantId", userInfo.getTenantId());
		
		try{
			//프로젝트 담당자
			if (param.get("managerList") != null) {
				managerList = (List<Map<String, Object>>) param.get("managerList");
				
				//이전 member의 집합
				if (mode.equals("edit")) {
					if (param.get("beforeManagerList") != null) {
						beforeManagerList = (List<Map<String, Object>>) param.get("beforeManagerList");
						
						if (managerList.size() > 0 || managerList != null) {
							Iterator<Map<String, Object>> managerIter = managerList.iterator();
								
							while (managerIter.hasNext()) {
								Map<String, Object> manager = managerIter.next();
								
								if (beforeManagerList.contains(manager)) {
									managerIter.remove();
								}
							}	
						}
					}
				}			
				getToArrMailList(managerList, param, request, projectName, projectId, "관리자", loginCookie);
			}
			
			//프로젝트 참여자
			if (param.get("participantList") != null) {
				participantList = (List<Map<String, Object>>) param.get("participantList");
				
				//이전 member의 집합
				if (mode.equals("edit")) {
					if (param.get("beforeParticipantList") != null) {
						beforeParticipantList = (List<Map<String, Object>>) param.get("beforeParticipantList");
						
						if (participantList.size() > 0 || participantList != null) {
							Iterator<Map<String, Object>> participantIter = participantList.iterator();
								
							while (participantIter.hasNext()) {
								Map<String, Object> participant = participantIter.next();
								
								if (beforeParticipantList.contains(participant)) {
									participantIter.remove();
								}
							}	
						}
					}
				}
				
				getToArrMailList(participantList, param, request, projectName, projectId, "참여자", loginCookie);
			}
			
			//프로젝트 조회자
			if (param.get("viewerList") != null) {
				viewerList = (List<Map<String, Object>>) param.get("viewerList");
				
				//이전 member의 집합
				if (mode.equals("edit")) {
					if (param.get("beforeViewerList") != null) {
						beforeViewerList = (List<Map<String, Object>>) param.get("beforeViewerList");
						
						if (viewerList.size() > 0 || viewerList != null) {
							Iterator<Map<String, Object>> viewerIter = viewerList.iterator();
								
							while (viewerIter.hasNext()) {
								Map<String, Object> viewer = viewerIter.next();
								
								if (beforeViewerList.contains(viewer)) {
									viewerIter.remove();
								}
							}	
						}
					}
				}
				
				getToArrMailList(viewerList, param, request, projectName, projectId, "조회자", loginCookie);
			}
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			LOGGER.debug("sendNotiMail ERROR : " + e.getMessage());
			e.printStackTrace();
		}
		
		return "";
	}
	
	public InternetAddress[] getToArrMailList (List<Map<String, Object>> nameList, Map<String, Object> param, HttpServletRequest request, String projectName, long projectId, String authName, @CookieValue("loginCookie") String loginCookie) {
		LOGGER.debug("getToArrMailList started");
		
		ArrayList<InternetAddress> toArrList = new ArrayList<InternetAddress>();
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		try {
			if (nameList.size() == 0) {
				return null;
			}
			
			for (int i = 0; i < nameList.size(); i++) {
				String userId = (String)nameList.get(i).get("userId");
				
				param.put("userIdType", (String)nameList.get(i).get("userIdType"));
				
				JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/users/"+userId+"/setting", param, request, "get", null);
				String status = resultBody.get("status").toString();
				
				if(status.equals("ok")) {
					JSONObject manager = (JSONObject) resultBody.get("data");
					InternetAddress toManager = new InternetAddress();
					toManager.setAddress((String) manager.get("userMail"));
					toManager.setPersonal((String)manager.get("userName"));
					
					LOGGER.debug("userMail : " + (String)manager.get("userMail") + ", userName : " + (String)manager.get("userName"));
					toArrList.add(toManager);
				}
			}
			
			InternetAddress[] toArr = new InternetAddress[toArrList.size()];
			
			for (int i = 0; i < toArrList.size(); i++) {
				toArr[i] = toArrList.get(i);
			}
			
			String subject = "[" + projectName + "] 프로젝트 " + authName + "로 지정되었습니다."; 
				
			String content = "<p>" + "[" + projectName + "] 프로젝트 " + authName + "로 지정되었습니다." + "</p>";
			content += "<p></p>";
			content += "<a href='#' target='' onclick='goProjectDetails(\"" + projectId + "\")'>[" + projectName + "] 프로젝트로 이동</a>";
			
			InternetAddress from;
			from = new InternetAddress(userInfo.getEmail());
			from.setPersonal(userInfo.getDisplayName());
			
			ezEmailService.sendMail(loginCookie, from, toArr, null, null, subject, content, false);
			
			LOGGER.debug("getToArrMailList ended");
			return toArr;
		} catch (Exception e) {
			LOGGER.debug("getToArrMailList ERROR : " + e.getMessage());
			return null;
		}
	}
	
	@RequestMapping(value = "/ezPMS/getProjectNameList.do")
	public String getProjectNameList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		LOGGER.debug("Controller getProjectNameList Started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String url = "/rest/ezPMS/projects/userId/" + userId;
		String status = "A";
		String viewType = "0";
		String projectSort = "0";		
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("listProjectStatus", status);
		param.put("viewType", viewType);
		param.put("projectSort", projectSort);
		param.put("orderWhat", "init");
		
		JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "get", null);
		String jsonStatus = result.get("status").toString();
		
		if (jsonStatus.equals("ok")) {
			JSONArray nameList = (JSONArray) result.get("data");
			model.addAttribute("projectNameList", nameList);
		}
		
		LOGGER.debug("Controller getProjectNameList Ended.");
		return "ezPMS/projectNameList";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezPMS/getHeadManagerList.do")
	@ResponseBody
	public JSONObject getHeadManagerList(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> param, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception{
		LOGGER.debug("getDeptUserList started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		
		String url = "/rest/ezPMS/list/users";
		param.put("userId", userId);
		
		List<Map<String, Object>> managerList = null;
		
		try {
			managerList = (List<Map<String, Object>>) param.get("userList");
		// IE에서는 LinkedHashMap으로만 cast할 수 있게 값이 넘어옴
		} catch(ClassCastException e) {
			Map<Integer, Map<String, Object>> tempMap = (Map<Integer, Map<String, Object>>) param.get("userList");
			managerList = new ArrayList<Map<String,Object>>(tempMap.values());
		}
		
		JSONObject listJson = new JSONObject();
		listJson.put("userList", managerList);
		param.remove("userList");
		
		JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "post", listJson);
		String status = result.get("status").toString();
		
		JSONObject userList = new JSONObject();
		if (status.equals("ok")) {
			userList.put("userList", result.get("data"));
		}
		
		LOGGER.debug("getDeptUserList ended");
		return userList;
	}
	
	//Overview에서 의견과 작업이력 불러오기
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezPMS/getOverviewContent.do")
	@ResponseBody
	public JSONObject getOverviewContent(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> param, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception{
		LOGGER.debug("getOverviewContent started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		long projectId = Long.parseLong(param.get("projectId").toString());
		
		JSONObject overviewContent = new JSONObject();
		
		//작업이력 불러오기
		String logUrl = "/rest/ezPMS/projects/" + projectId + "/logs";
		param.put("userId", userId);
		
		JSONObject logResult = commonUtil.getJsonFromRestApi(logUrl, param, request, "get", null);
		String logStatus = logResult.get("status").toString();
		
		if (logStatus.equals("ok")) {
			JSONObject data = (JSONObject) logResult.get("data");
			overviewContent.put("logList", data.get("taskLogList"));
		}
		
		
		//의견 불러오기
		String commentUrl = "/rest/ezPMS/comments/list/" + projectId + "/users/" + userId;
		JSONObject commentResult = commonUtil.getJsonFromRestApi(commentUrl, param, request, "get", null);
		String commentStatus = commentResult.get("status").toString();
		
		if (commentStatus.equals("ok")) {
			JSONArray commentData = (JSONArray) commentResult.get("data");
			overviewContent.put("commentList", commentData);
		}
		
		LOGGER.debug("getOverviewContent ended");
		return overviewContent;
		
	}
	
	/**
	 * 프로젝트관리 업무 리스트 호출함수
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezPMS/getProjectTaskList.do")
	public String getProjectTaskList(HttpServletRequest request, Model model,@RequestBody Map<String, Object> param, @CookieValue("loginCookie") String loginCookie) {
		
		LOGGER.debug("ezPMS projectTaskList started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		long projectId = Long.parseLong(param.get("projectId").toString());
		String userId = userInfo.getId();
		
		param.put("userId", userId);
		
		String countUrl = "/rest/ezPMS/projects/" + projectId + "/tasks/count";
		String url = "/rest/ezPMS/task-list/" + projectId + "/users/" + userId;
		
		JSONObject countResult = commonUtil.getJsonFromRestApi(countUrl, param, request, "get", null);
		String countStatus = countResult.get("status").toString();
		
		int taskListCount = 0;
		int listNumber = Integer.parseInt(param.get("listNumber").toString());
		int currentPage = Integer.parseInt(param.get("currentPage").toString());
		
		if (countStatus.equals("ok")) {
			if (!countResult.get("data").equals("")){
				taskListCount = Integer.parseInt(countResult.get("data").toString());
				model.addAttribute("taskListCount", taskListCount);
				
				ProjectPagination paging = new ProjectPagination(taskListCount, listNumber, 10, currentPage);
				model.addAttribute("paging", paging);
				
				if (taskListCount != 0) {
					//현재 페이지
					param.put("currentPage", currentPage);
					//한 페이지에 보여질 개수
					param.put("limit", listNumber);
					//프로젝트 총 개수
					param.put("listCount", taskListCount);
					param.put("startRow", paging.getStartCount());
					
					//header 정렬 프로젝트 순서
					if (param.get("orderWhat") == null || param.get("orderWhat").equals("")) {
						param.put("orderWhat", "init");
					}
					
					if (param.get("orderHow") == null || param.get("orderHow").equals("")) {
						param.put("orderHow", "asc");
					}
					
					JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "get", null);
					String status = result.get("status").toString();
		
					if (status.equals("ok")) {
						JSONObject data = (JSONObject) result.get("data");
						model.addAttribute("taskList", data.get("taskList"));
						model.addAttribute("userRoleId", data.get("userRoleId"));
						model.addAttribute("position", param.get("position"));
						
						if (data.get("groupDetail") == null) {
							model.addAttribute("groupDetail", "{}");
						} else {
							model.addAttribute("groupDetail", data.get("groupDetail"));
						}
					}
				} else {
					if (param.get("groupId") != null) {
						long groupId = Long.parseLong(param.get("groupId").toString());
						String groupUrl = "/rest/ezPMS/groups/" + groupId + "/users/" + userId;
						
						param.put("projectId", projectId);
						
						JSONObject result = commonUtil.getJsonFromRestApi(groupUrl, param, request, "get", null);
						String status = result.get("status").toString();
						
						if (status.equals("ok")) {
							JSONObject groupDetails = (JSONObject) result.get("data");
							model.addAttribute("groupDetail", groupDetails);
						}
					} else {
						model.addAttribute("groupDetail", "{}");
						model.addAttribute("position", param.get("position"));
					}
				}
			}
		}
		
		LOGGER.debug("ezPMS projectTaskList ended");
		
		return "/ezPMS/pmsTaskList";
	}
	
	
	/**
	 * 프로젝트관리 업무 리스트 메인 화면 호출함수
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezPMS/getTaskListMain.do")
	public String getTaskListMain(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		
		LOGGER.debug("ezPMS taskListMain started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		
		String projectId = request.getParameter("projectId");
		String onlyGroup = request.getParameter("onlyGroup");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		param.put("onlyGroup", onlyGroup);
		param.put("location", "taskList");
		param.put("userId", userId);
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/tree/" + projectId + "/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			JSONArray treeData = (JSONArray) resultBody.get("data");
			model.addAttribute("data", treeData);
		}
		
		String countUrl = "/rest/ezPMS/projects/" + projectId + "/tasks/count";
		JSONObject countResult = commonUtil.getJsonFromRestApi(countUrl, param, request, "get", null);
		String countStatus = countResult.get("status").toString();
		
		int taskListCount = 0;
		
		if (countStatus.equals("ok")) {
			if (!countResult.get("data").equals("")){
				taskListCount = Integer.parseInt(countResult.get("data").toString());
				model.addAttribute("taskListCount", taskListCount);
			}
		}
		
		String roleUrl = "/rest/ezPMS/projects/" + projectId + "/users/" + userId + "/role";
		JSONObject roleResult = commonUtil.getJsonFromRestApi(roleUrl, param, request, "get", null);
		String roleStatus = roleResult.get("status").toString();
		
		if (roleStatus.equals("ok")) {
			int userRole = Integer.parseInt(roleResult.get("data").toString());
			model.addAttribute("userRole", userRole);
		}
		
		
		model.addAttribute("projectId", request.getParameter("projectId"));
		
		LOGGER.debug("ezPMS taskListMain ended");
		
		return "/ezPMS/pmsTaskListMain";
	}
	
	/**
	 * 프로젝트 관리 업무 삭제 실행
	 */
	@RequestMapping(value="/ezPMS/deleteTask.do")
	@ResponseBody
	public String deleteTask(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		LOGGER.debug("ezPMS deleteTask started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String taskId = request.getParameter("taskId");
		long projectId = Long.parseLong(request.getParameter("projectId"));
		String companyId = userInfo.getCompanyID();
		
		String url = "/rest/ezPMS/tasks/" + taskId + "/users/" + userId;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("projectId", projectId);
		param.put("companyId", companyId);
		
		
		JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "delete", null);
		String status = result.get("status").toString();
		String checkPermission = "";
		
		if (status.equals("ok")) {
			checkPermission = result.get("data").toString();
		}
		
		
		LOGGER.debug("ezPMS deleteTask ended");
		
		return checkPermission;
	}
	
	/**
	 * 나의 업무 : 담당 그룹 리스트 호출
	 */

	@RequestMapping(value="/ezPMS/getGroupList.do")
	public String getMyGroupList(@RequestBody Map<String, Object> param, HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {
		LOGGER.debug("ezPMS getMyGroupList started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String projectId = param.get("projectId").toString(); 
		
		String countUrl = "/rest/ezPMS/users/" + userId + "/groups/count";
		String url = "/rest/ezPMS/projects/" + projectId + "/groups/users/" + userId;
		
		JSONObject countResult = commonUtil.getJsonFromRestApi(countUrl, param, request, "get", null);
		String countStatus = countResult.get("status").toString();
		int groupCount = 0;
		
		int listNumber = Integer.parseInt(param.get("listNumber").toString());
		int currentPage = Integer.parseInt(param.get("currentPage").toString());
		
		if (countStatus.equals("ok")) {
			if (!countResult.get("data").equals("")){
				groupCount = Integer.parseInt(countResult.get("data").toString());
				model.addAttribute("taskListCount", groupCount);
				
				ProjectPagination paging = new ProjectPagination(groupCount, listNumber, 10, currentPage);
				model.addAttribute("paging", paging);
				
				if (groupCount != 0) {
					//현재 페이지
					param.put("currentPage", currentPage);
					//한 페이지에 보여질 개수
					param.put("limit", listNumber);
					//프로젝트 총 개수
					param.put("listCount", groupCount);
					param.put("startRow", paging.getStartCount());
					
					JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "get", null);
					String status = result.get("status").toString();
					
					if (status.equals("ok")) {
						JSONArray groupList = (JSONArray) result.get("data");
						model.addAttribute("taskList", groupList);
					}
				}
				
				model.addAttribute("position", param.get("position"));
				model.addAttribute("groupDetail", "{}");
			}
		}
		
		LOGGER.debug("ezPMS getMyGroupList ended");
		return "ezPMS/pmsTaskList";
	}
	
	/**
	 * 나의 업무 : 담당프로젝트 리스트 호출
	 * @param param
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezPMS/getMyProjectList.do")
	public String getMyProjectList(@RequestBody Map<String, Object> param, HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {
		LOGGER.debug("ezPMS getMyProjectList started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		
		int currentPage = (int) param.remove("currentPage");
		int listNumber = Integer.parseInt(param.get("listNumber").toString());
		String deptId = userInfo.getDeptID();

		String countUrl = "/rest/ezPMS/projects/userId/" + userId + "/count";
		String url = "/rest/ezPMS/projects/userId/" + userId;
		
		param.put("viewType", 1);
		param.put("userIdType", "user");
		param.put("deptId", deptId);
		param.put("projectSort", "0");
		param.put("listProjectStatus", param.get("status"));
		
		JSONObject countResult = commonUtil.getJsonFromRestApi(countUrl, param, request, "get", null);
		String countStatus = countResult.get("status").toString();
		
		int projectListCount = 0;
		JSONArray projectList = new JSONArray();
		
		if (countStatus.equals("ok")) {
			JSONObject countJson = (JSONObject) countResult.get("data");
			
			if (countJson.get("projectListCount").toString() != null) {
				projectListCount = Integer.parseInt(countJson.get("projectListCount").toString());
				model.addAttribute("projectListCount", projectListCount);
				
				ProjectPagination paging = new ProjectPagination(projectListCount,listNumber, 10, currentPage);
				model.addAttribute("paging", paging);
				
				if (projectListCount != 0) {
					//현재 페이지
					param.put("currentPage", currentPage);
					//한 페이지에 보여질 개수
					param.put("listNumber", listNumber);
					//프로젝트 총 개수
					param.put("listCount", projectListCount);
					param.put("startCount", paging.getStartCount());
					
					//header 정렬 프로젝트 순서
					if (param.get("orderWhat") == null || param.get("orderWhat").equals("")) {
						param.put("orderWhat", "init");
					}
					
					JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "get", null);
					String status = result.get("status").toString();
					
					if (status.equals("ok")) {		
						projectList = (JSONArray) result.get("data");
					}
				}
			}
			
			model.addAttribute("position", param.get("position"));
			model.addAttribute("projectList", projectList);
			model.addAttribute("projectListCount", projectListCount);
		}
		
		LOGGER.debug("ezPMS getMyProjectList ended");
		return "ezPMS/pmsMyProjectList";
	}
	
	/**
	 * 프로젝트 관리 상태 색상변경 팝업 호출
	 */
	@RequestMapping(value="/ezPMS/getColorPicker.do")
	public String getColorPicker() {
		return "ezPMS/pmsStatusColor";
	}
	
	/**
	 * 간트차트에서의 날짜 변경
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezPMS/updateTaskDate.do")
	@ResponseBody
	public JSONObject updateTaskDate(@RequestBody Map<String, Object> param, HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {
		LOGGER.debug("ezPMS updateTaskDate started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		
		String url = "/rest/ezPMS/tasks/" + param.get("taskId") + "/users/" + userId + "/status";
		
		JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "put", null);
		String status = result.get("status").toString();
		JSONObject json = new JSONObject();
		
		if (status.equals("ok")) {
			JSONObject data = (JSONObject) result.get("data");
			String roleCheck = data.get("roleCheck").toString();
			String endDate = data.get("endDate").toString();
			
			json.put("roleCheck", roleCheck);
			json.put("endDate", endDate);
		}
		
		LOGGER.debug("ezPMS updateTaskDate ended");
		return json;
	}
	
	/**
	 * 간트차트에서의 상태 변경
	 */
	@RequestMapping(value="/ezPMS/addPreTaskRel.do")
	@ResponseBody
	public String addPreTaskRel(@RequestBody Map<String, Object> param, HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {
		LOGGER.debug("ezPMS addPreTaskRel started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		
		String url = "/rest/ezPMS/tasks/" + param.get("taskId") + "/preTasks/" + param.get("preTaskId") + "/type/" + param.get("type");
		param.put("userId", userId);
		
		JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "post", null);
		String status = result.get("status").toString();
		String roleCheck = "";
		
		if (status.equals("ok")) {
			roleCheck = result.get("data").toString();
		}
		
		LOGGER.debug("ezPMS addPreTaskRel ended");
		return roleCheck;
	}
	
	/**
	 * 간트차트 그룹 및 업무 순서 변경
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezPMS/changeGanttOrder.do")
	@ResponseBody
	public String changeGanttOrder(@RequestBody Map<String, Object> param, HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {
		LOGGER.debug("ezPMS changeGanttOrder started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		long projectId = Long.parseLong(param.get("projectId").toString());
		
		String url = "/rest/ezPMS/project/" + projectId + "/gantt/order";
		param.put("userId", userId);
		
		JSONObject jsonList = new JSONObject();
		jsonList.put("groupList", param.get("groupArr"));
		jsonList.put("taskList", param.get("taskArr"));
		
		JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "put", jsonList);
		String status = result.get("status").toString();
		String roleCheck = "";
		
		if (status.equals("ok")) {
			roleCheck = result.get("data").toString();
		}
		
		LOGGER.debug("ezPMS changeGanttOrder ended");
		return roleCheck;
	}
	
	/**
	 * 그룹 자세히 보기
	 */
	@RequestMapping(value="/ezPMS/getGroupDetails.do")
	public String getGroupDetails(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {
		LOGGER.debug("ezPMS getGroupDetails started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		long projectId = Long.parseLong(request.getParameter("projectId"));
		long groupId = Long.parseLong(request.getParameter("groupId"));
		
		String url = "/rest/ezPMS/groups/" + groupId + "/users/" + userId;
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("projectId", projectId);
		
		JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "get", null);
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONObject taskDetails = (JSONObject) result.get("data");
			model.addAttribute("taskDetails", taskDetails);
		}
		
		param.put("userIdType", "user");
		JSONObject resultMS = commonUtil.getJsonFromRestApi("/rest/ezPMS/users/"+ userInfo.getId() +"/setting", param, request, "get", null);
		status = resultMS.get("status").toString();
		
		if(status.equals("ok")) {
			JSONObject mainSetting = (JSONObject) resultMS.get("data");
			model.addAttribute("mainSetting", mainSetting);
		}
		
		model.addAttribute("target", "group");
		LOGGER.debug("ezPMS getGroupDetails ended");
		return "ezPMS/pmsTaskDetails";
	}
	
	/**
	 * 그룹 수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezPMS/updateGroupInfo.do")
	@ResponseBody
	public String updateGroupInfo(@RequestBody Map<String, Object> param, HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {
		LOGGER.debug("ezPMS changeGanttOrder started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		long groupId = Long.parseLong(param.get("groupId").toString());
		

		JSONObject jsonList = new JSONObject();
		jsonList.put("managerList", param.get("managerList"));
		jsonList.put("participantList", param.get("participantList"));
		jsonList.put("addMemberList", param.get("addMemberList"));
		jsonList.put("delMemberList", param.get("delMemberList"));
		
		String url = "/rest/ezPMS/groups/" + groupId + "/users/" + userId;
		commonUtil.getJsonFromRestApi(url, param, request, "put", jsonList);
		
		return null;
	}
	

	
	@RequestMapping(value="/ezPMS/getMemberSchedule.do")
	public String getMemberSchedule(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {
		LOGGER.debug("ezPMS getMemberSchedule started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		long projectId = Long.parseLong(request.getParameter("projectId"));
		
		Map<String, Object> param = new HashMap<String, Object>();
		String url = "/rest/ezPMS/projects/" + projectId + "/management/members";
		param.put("userId", userId);
		
		JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "get", null);
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONObject data = (JSONObject) result.get("data");
			model.addAttribute("memberList", data.get("memberList"));
			model.addAttribute("memberScheduleList", data.get("memberScheduleList"));
			model.addAttribute("planStartDate", data.get("planStartDate"));
			model.addAttribute("planEndDate", data.get("planEndDate"));
			model.addAttribute("dateList", data.get("dateList"));
			model.addAttribute("projectId", projectId);
		}
		
		LOGGER.debug("ezPMS getMemberSchedule ended");
		return "ezPMS/pmsMemberSchedule";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezPMS/getDateTaskList.do")
	@ResponseBody
	public List<String> getDateTaskList(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {
		LOGGER.debug("ezPMS getDateTaskList started");
		List<String> taskList = new ArrayList<String>();
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		System.out.println(request.getParameter("selectedDate"));
		long projectId = Long.parseLong(request.getParameter("projectId")); 
		String selectedDate = request.getParameter("selectedDate");
		String selectedUserId = request.getParameter("selectedUserId");
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		
		String url = "/rest/ezPMS/projects/" + projectId + "/dates/" + selectedDate + "/users/" + selectedUserId;
		
		JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "get", null);
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			taskList = (List<String>) result.get("data");
		}
		
		
		LOGGER.debug("ezPMS getDateTaskList started");
		return taskList;
	}
}
