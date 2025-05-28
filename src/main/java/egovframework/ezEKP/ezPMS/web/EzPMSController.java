package egovframework.ezEKP.ezPMS.web;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.net.URI;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.mail.internet.InternetAddress;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezPMS.vo.ProjectPagination;
import egovframework.ezEKP.ezPMS.vo.ProjectTaskVO;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzPMSController {

	private static final Logger logger = LoggerFactory.getLogger(EzPMSController.class);

	public static final int BUFF_SIZE = 2048;

	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;

	@Resource(name = "egovMessageSource")
	private EgovMessageSource egovMessageSource;

	@Resource(name = "EzEmailService")
	private EzEmailService ezEmailService;

	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;

	// 유은정 작성
	/**
	 * 프로젝트 관리 메인화면 호출함수
	 */
	@RequestMapping(value = "/ezPMS/pmsMain.do")
	public String main(HttpServletRequest request, Model model) {
		logger.debug("ezPMS main page started");

		String leftFrameWidth = "220";
		int width = 0;

		if (request.getParameter("__wwidth") != null) {
			String widthParam = request.getParameter("__wwidth");

			try {
				width = Integer.parseInt(widthParam);

				leftFrameWidth = width < 1180 ? "0" : "220";
			} catch (NumberFormatException e) {
				width = 0;
			}
		}

		model.addAttribute("leftFrameWidth", leftFrameWidth);
		
		logger.debug("ezPMS main page ended");
		return "ezPMS/pmsMain";
	}

	/**
	 * 프로젝트관리 왼쪽화면 호출함수
	 * 
	 * @return
	 */
	@RequestMapping(value = "/ezPMS/pmsLeft.do")
	public String left(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model) throws Exception {
		logger.debug("ezPMS left page started");
		model.addAttribute("mode", request.getParameter("mode"));
		logger.debug("ezPMS left page ended");
		return "ezPMS/pmsLeft";
	}

	/**
	 * 메인페이지화면 호출 함수
	 */
	@RequestMapping(value = "/ezPMS/pmsProjectListMain.do")
	public String projectList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model) throws Exception {

		logger.debug("ezPMS projectList started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();

		String settingUrl = "/rest/ezPMS/users/" + userId + "/setting";

		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userIdType", "user");

		JSONObject settingResult = commonUtil.getJsonFromRestApi(settingUrl, param, request, "get", null);
		String settingStatus = settingResult.get("status").toString();

		if (settingStatus.equals("ok")) {
			JSONObject listSetting = (JSONObject) settingResult.get("data");
			model.addAttribute("listSetting", listSetting);
			model.addAttribute("userId", userId);
		}

		logger.debug("ezPMS projectList ended");
		return "ezPMS/pmsProjectListMain";
	}

	@RequestMapping(value = "/ezPMS/getProjectList.do")
	public String getProjectList(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> param,
			HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("ezPMS getProjectList started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String viewType = param.get("viewType").toString();
		int currentPage = (int) param.remove("currentPage");
		int listNumber = Integer.parseInt(param.get("listNumber").toString());
		String projectSort = param.get("projectSort").toString();
		String listProjectStatus = param.get("listProjectStatus").toString();

		if (projectSort == null || projectSort.equals("")) {
			projectSort = "0";
		}

		String url = "/rest/ezPMS/projects/userId/" + userId;
		String countUrl = "/rest/ezPMS/projects/userId/" + userId + "/count";

		param.put("userIdType", "user");
		param.put("projectSort", projectSort);

		// 프로젝트 개수 확인
		JSONObject countResult = commonUtil.getJsonFromRestApi(countUrl, param, request, "get", null);
		String countStatus = countResult.get("status").toString();

		int projectListCount = 0;
		JSONArray projectList = new JSONArray();

		if (countStatus.equals("ok")) {
			JSONObject countJson = (JSONObject) countResult.get("data");

			if (countJson.get("projectListCount").toString() != null) {
				projectListCount = Integer.parseInt(countJson.get("projectListCount").toString());
				// 프로젝트 총 개수
				model.addAttribute("projectListCount", projectListCount);
				ProjectPagination paging = new ProjectPagination(projectListCount, listNumber, 10, currentPage);
				model.addAttribute("paging", paging);

				// 프로젝트 개수가 0이 아닐 때만 프로젝트 목록을 불러옴
				if (projectListCount != 0) {
					// 현재 페이지
					param.put("currentPage", currentPage);

					if (viewType.equals("1")) {// 목록 형식이 board type일 때
						param.put("startCount", paging.getStartCount());
					} else { // 목록 형식이 memo(card) type일 때
						param.put("startCount", param.get("startRow"));
					}

					// header 정렬 프로젝트 순서, init인 경우에는 plan_end_date순으로 정렬됨
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

			if (viewType.equals("1")) {
				viewType = "Board";
			} else {
				viewType = "Memo";
			}
		}

		logger.debug("[result] projectSort : " + projectSort + ", projectLsitCount : " + projectListCount
				+ ", currentPage : " + currentPage + ", listNumber : " + listNumber);
		logger.debug("ezPMS getProjectList ended");
		return "ezPMS/pmsProjectList" + viewType;
	}

	/**
	 * 나의 업무 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPMS/pmsMyTask.do")
	public String myTaskPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model) throws Exception {
		logger.debug("ezPMS MyTask page started");
		logger.debug("ezPMS MyTask page ended");
		return "ezPMS/pmsMyTask";
	}

	/**
	 * 프로젝트관리 환경설정 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPMS/pmsSetting.do")
	public String pmsSetting(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model) throws Exception {
		logger.debug("ezPMS Setting started");
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
			logger.debug("[result] list setting number : " + setting.get("listNumber"));
		}

		logger.debug("ezPMS Setting started");
		return "ezPMS/pmsSetting";
	}

	/**
	 * 프로젝트 상세 조회 화면 호출
	 */
	@RequestMapping(value = "/ezPMS/getProjectDetails.do")
	public String getProjectDetails(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model) throws Exception {
		logger.debug("ezPMS getProjectDetails started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String projectId = request.getParameter("projectId");
		String userId = userInfo.getId();

		String url = "/rest/ezPMS/projects/" + projectId + "/userId/" + userId;
		JSONObject result = commonUtil.getJsonFromRestApi(url, null, request, "get", null);
		String status = result.get("status").toString();

		if (status.equals("ok")) {
			JSONObject json = (JSONObject) result.get("data");
			JSONObject project = (JSONObject) json.get("project");

			// 프로젝트 정보 호출
			model.addAttribute("project", project);
			logger.debug("[result] project id : " + project.get("projectId"));
		}

		logger.debug("ezPMS getProjectDetails ended");
		return "ezPMS/pmsProjectDetails";
	}

	/**
	 * 프로젝트 등록/수정 화면 호출
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezPMS/newProject.do")
	public String newProject(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model) throws Exception {
		logger.debug("ezPMS addNewProject started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userName = userInfo.getDisplayName1();
		String userId = userInfo.getId();
		String userDeptname = userInfo.getDeptName1();
		String mode = request.getParameter("mode");

		String planStartDate = "";
		String planEndDate = "";
		long projectId = 0;

		// 프로젝트 생성
		if (mode.equals("new")) {
			String nowDate = commonUtil.getTodayUTCTime("yyyy-MM-dd");
			// 프로젝트 생성 시 시작일과 종료일이 현재 날짜로 기본으로 출력됨
			planStartDate = nowDate;
			planEndDate = nowDate;
		} else if (mode.equals("edit")) {// 프로젝트 수정
			projectId = Long.parseLong(request.getParameter("projectId"));
			long groupId = Long.parseLong(request.getParameter("groupId"));

			String url = "/rest/ezPMS/projects/" + projectId + "/userId/" + userId;

			Map<String, Object> param = new HashMap<String, Object>();
			param.put("mode", mode);

			JSONObject jsonList = new JSONObject();
			jsonList.put("overview", param.get("overview"));
			
			JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "get", jsonList);
			String status = result.get("status").toString();

			if (status.equals("ok")) {
				JSONObject resultJson = (JSONObject) result.get("data");
				JSONObject project = (JSONObject) resultJson.get("project");

				model.addAttribute("project", project);
				model.addAttribute("groupId", groupId);

				logger.debug("[result] project projectName : " + project.get("projectName"));
			}

		}

		model.addAttribute("mode", mode);
		model.addAttribute("userName", userName);
		model.addAttribute("userDeptname", userDeptname);
		model.addAttribute("planStartDate", planStartDate);
		model.addAttribute("planEndDate", planEndDate);

		logger.debug("ezPMS addNewProject ended");
		return "ezPMS/newProject";
	}

	/**
	 * 새 프로젝트 추가 함수 실행
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezPMS/addNewProject.do")
	@ResponseBody
	public JSONObject addNewProject(@CookieValue("loginCookie") String loginCookie,
			@RequestBody Map<String, Object> param, HttpServletRequest request, HttpServletResponse resp, Model model)
			throws Exception {
		logger.debug("ezPMS addNewProject started");

		long projectId = 0;
		long groupId = 0;
		String roleCheck = "";
		JSONObject json = new JSONObject();

		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			String url = "/rest/ezPMS/projects";
			String today = commonUtil.getTodayUTCTime("yyyy-MM-dd");

			param.put("createDate", today); // 등록일
			param.put("userId", userInfo.getId());

			JSONObject jsonList = new JSONObject();
			jsonList.put("managerList", param.get("managerList"));
			jsonList.put("participantList", param.get("participantList"));
			jsonList.put("viewerList", param.get("viewerList"));
			jsonList.put("overview", param.get("overview"));

			// header가 overflow하지 않게 지워줌
			param.remove("managerList");
			param.remove("participantList");
			param.remove("viewerList");
			param.remove("overview");

			JSONObject result = new JSONObject();

			if (param.get("mode").equals("new")) { // 프로젝트 추가 url로 넘김
				result = commonUtil.getJsonFromRestApi(url, param, request, "post", jsonList);
				JSONObject resultValue = (JSONObject) result.get("data");
				projectId = Long.parseLong(resultValue.get("projectId").toString());
				groupId = Long.parseLong(resultValue.get("groupId").toString());
			} else if (param.get("mode").equals("edit")) {// 프로젝트 수정 url로 넘김
				projectId = Long.parseLong(param.get("projectId").toString());
				groupId = Long.parseLong(param.get("groupId").toString());
				url += "/" + projectId;
				result = commonUtil.getJsonFromRestApi(url, param, request, "put", jsonList);

				JSONObject resultValue = (JSONObject) result.get("data");
				roleCheck = resultValue.get("roleCheck").toString();
				
			}
			
			json.put("roleCheck", roleCheck);
			json.put("projectId", projectId);
			json.put("groupId", groupId);

			logger.debug("projectId : " + projectId + ", groupId : " + groupId);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			logger.debug("ERROR : " + e.getMessage());
		}

		logger.debug("ezPMS addNewProject ended");
		return json;
	}

	/**
	 * 프로젝트 삭제
	 * 
	 * @param loginCookie
	 * @param request
	 * @param resp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezPMS/deleteProject.do")
	@ResponseBody
	public String deleteProject(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> param,
			HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		logger.debug("ezPMS deleteProject started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();

		String projectId = param.get("projectList").toString();
		String url = "/rest/ezPMS/projects/" + projectId;

		param.put("userId", userId);

		JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "delete", null);
		String data = result.get("data").toString();

		logger.debug("[result] data : " + data);
		logger.debug("ezPMS deleteProject ended");
		return data;
	}

	/**
	 * 프로젝트관리 메인 화면 환경설정
	 * 
	 * @param loginCookie
	 * @param request
	 * @param resp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezPMS/updateMainSetting.do")
	@ResponseBody
	public String updateMainSetting(@CookieValue("loginCookie") String loginCookie,
			@RequestBody Map<String, Object> param, HttpServletRequest request, HttpServletResponse resp, Model model)
			throws Exception {
		logger.debug("ezPMS updateMainSetting started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String url = "/rest/ezPMS/users/" + userId + "/setting";

		JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "put", null);
		String status = result.get("status").toString();

		logger.debug("ezPMS updateMainSetting ended");
		return status;
	}

	/**
	 * 프로젝트 상태변경 화면 호출
	 */
	@RequestMapping(value = "/ezPMS/changeProjectStatus.do")
	public String changeProjectStatus(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model) throws Exception {
		logger.debug("ezPMS changeProjectStatus started");
		logger.debug("ezPMS changeProjectStatus ended");
		return "ezPMS/changeProjectStatus";
	}

	/**
	 * 프로젝트 상태 변경 실행
	 * 
	 * @param loginCookie
	 * @param request
	 * @param resp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezPMS/updateProjectStatus.do")
	@ResponseBody
	public String updateProjectStatus(@CookieValue("loginCookie") String loginCookie,
			@RequestBody Map<String, Object> param, HttpServletRequest request, HttpServletResponse resp, Model model)
			throws Exception {
		logger.debug("ezPMS updateProjectStatus started");
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

		logger.debug("ezPMS updateProjectStatus ended");
		return data;
	}

	/**
	 * 프로젝트 개요 정보 출력
	 * 
	 * @param loginCookie
	 * @param request
	 * @param resp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezPMS/getProjectOverview.do")
	public String getProjectOverview(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model) throws Exception {
		logger.debug("ezPMS getProjectOverview started");
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
			model.addAttribute("userId", userId);
			logger.debug("[result] kanbanOrder : " + kanbanOrder + ", userRole : " + userRole);
		}

		logger.debug("ezPMS getProjectOverview ended");
		return "ezPMS/pmsProjectOverview";
	}

	/**
	 * 프로젝트 참여 역할별 멤버 조회
	 * 
	 * @param loginCookie
	 * @param request
	 * @param resp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezPMS/getProjectMember.do")
	public String getProjectMember(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model) throws Exception {
		logger.debug("ezPMS getProjectMember started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String projectId = request.getParameter("projectId");
		
		// 멤버의 권한에 따라 정보를 조회
		String roleId = request.getParameter("roleId");

		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		param.put("isGantt", 1);

		String url = "/rest/ezPMS/projects/" + projectId + "/roles/" + roleId;

		JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "get", null);
		String status = result.get("status").toString();

		if (status.equals("ok")) {
			JSONArray memberList = (JSONArray) result.get("data");
			int memberCount = memberList.size();

			model.addAttribute("roleId", roleId);
			model.addAttribute("memberList", memberList);
			model.addAttribute("memberCount", memberCount);
			logger.debug("[result] memberCount : " + memberCount);
		}

		logger.debug("ezPMS getProjectMember ended");
		return "ezPMS/pmsProjectMember";
	}

	/**
	 * 프로젝트 개요 내 카드에 들어갈 업무 목록 조회
	 * 
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
	public JSONObject getTaskList(@CookieValue("loginCookie") String loginCookie,
			@RequestBody Map<String, Object> param, HttpServletRequest request, HttpServletResponse resp, Model model)
			throws Exception {
		logger.debug("ezPMS getTaskList started");
		Long startMillis = System.currentTimeMillis();

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		long projectId = Long.parseLong(param.get("projectId").toString());
		String userId = userInfo.getId();
		String kanbanOrder = param.get("kanbanOrder").toString();

		String url = "/rest/ezPMS/task-list/" + projectId + "/users/" + userId;
		String countUrl = "/rest/ezPMS/projects/" + projectId + "/tasks/count";
		JSONObject json = new JSONObject();

		logger.debug("kanbanOrder : " + kanbanOrder);

		if (!kanbanOrder.equals("") || kanbanOrder != null) {
			String[] kanbanStatus = kanbanOrder.split(",");

			// 전체 업무의 개수를 구함
			param.put("isMyTask", "A");
			param.put("userId", userId);
			param.put("status", "A");

			JSONObject totalCountResult = commonUtil.getJsonFromRestApi(countUrl, param, request, "get", null);
			String totalCountStatus = totalCountResult.get("status").toString();

			if (totalCountStatus.equals("ok")) {
				long totalCount = (Long) totalCountResult.get("data");
				json.put("totalTaskCNT", totalCount);
			}

			for (int i = 0; i < kanbanStatus.length; i++) {
				// 나의 업무만 불러올지 전체 업무를 불러올지 결정
				if (kanbanStatus[i].contains("M")) {
					kanbanStatus[i] = kanbanStatus[i].substring(kanbanStatus[i].length() - 1);
					param.put("isMyTask", "M");
				} else {
					param.put("isMyTask", "A");
				}

				param.put("status", kanbanStatus[i]);

				// 칸반에 게시판이 포함되는 경우
				if (kanbanStatus[i].equals("B")) {
					String boardCountUrl = "/rest/ezPMS/boards/list-count/" + projectId + "/users/" + userId;
					JSONObject boardCountResult = commonUtil.getJsonFromRestApi(boardCountUrl, param, request, "get",
							null);
					String boardCountStatus = boardCountResult.get("status").toString();

					if (boardCountStatus.equals("ok")) {
						String boardCount = boardCountResult.get("data").toString();

						json.put("kanbanTaskCount" + (i + 1), boardCount);

						if (!boardCount.equals("0")) {
							String boardUrl = "/rest/ezPMS/boards/list/" + projectId + "/users/" + userId;
							JSONObject boardResult = commonUtil.getJsonFromRestApi(boardUrl, param, request, "get",
									null);
							String boardStatus = boardResult.get("status").toString();

							if (boardStatus.equals("ok")) {
								JSONArray boardList = (JSONArray) boardResult.get("data");
								json.put("kanbanTask" + (i + 1), boardList);
							}
						}
					}
				} else {
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
		Long endMillis = System.currentTimeMillis();
		logger.debug("lead time : " + ((endMillis - startMillis) / 1000.0) + " sec");
		logger.debug("ezPMS getTaskList ended");
		return json;
	}

	/**
	 * 칸반 환경설정 화면 호출
	 */
	@RequestMapping(value = "/ezPMS/kanbanSetting.do")
	public String kanbanSetting(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model mode) throws Exception {
		logger.debug("ezPMS kanbanSetting started");
		logger.debug("ezPMS kanbanSetting ended");
		return "ezPMS/pmsKanbanSetting";
	}

	/**
	 * 칸반 순서 변경
	 * 
	 * @param loginCookie
	 * @param request
	 * @param resp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezPMS/changeKanbanOrder.do")
	@ResponseBody
	public String changeKanbanOrder(@CookieValue("loginCookie") String loginCookie,
			@RequestBody Map<String, Object> param, HttpServletRequest request, HttpServletResponse resp, Model model)
			throws Exception {
		logger.debug("ezPMS changeKanbanOrder started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String projectId = param.get("projectId").toString();
		String userId = userInfo.getId();
		String url = "/rest/ezPMS/projects/" + projectId + "/userId/" + userId + "/order";

		commonUtil.getJsonFromRestApi(url, param, request, "put", null);

		logger.debug("ezPMS changeKanbanOrder ended");
		return null;
	}

	/**
	 * 즐겨찾기 추가
	 * 
	 * @param loginCookie
	 * @param request
	 * @param resp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezPMS/addFavoriteProject.do")
	@ResponseBody
	public String addFavoriteProject(@CookieValue("loginCookie") String loginCookie,
			@RequestBody Map<String, Object> param, HttpServletRequest request, HttpServletResponse resp, Model model)
			throws Exception {
		logger.debug("ezPMS addFavoriteProject started");
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

		logger.debug("ezPMS addFavoriteProject ended");
		return addResult;
	}

	/**
	 * 즐겨찾기 해제
	 * 
	 * @param loginCookie
	 * @param request
	 * @param resp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezPMS/deleteFavoriteProject.do")
	public String deleteFavoriteProject(@CookieValue("loginCookie") String loginCookie,
			@RequestBody Map<String, Object> param, HttpServletRequest request, HttpServletResponse resp, Model model)
			throws Exception {
		logger.debug("ezPMS deleteFavoriteProject started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String projectId = param.get("projectList").toString();
		String userId = userInfo.getId();

		String url = "/rest/ezPMS/userId/" + userId + "/favorites/" + projectId;

		commonUtil.getJsonFromRestApi(url, param, request, "delete", null);

		logger.debug("ezPMS deleteFavoriteProject ended");
		return null;
	}

	/**
	 * 작업 이력 추가
	 * 
	 * @param loginCookie
	 * @param request
	 * @param resp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezPMS/addTaskLog.do")
	public String addTaskLog(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> param,
			HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		logger.debug("ezPMS addTaskLog started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		long projectId = Long.parseLong(param.get("projectId").toString());
		String userId = userInfo.getId();

		param.put("userId", userId);
		String logDate = commonUtil.getTodayUTCTime("");
		param.put("logDate", logDate);

		String url = "/rest/ezPMS/projects/" + projectId + "/logs";

		commonUtil.getJsonFromRestApi(url, param, request, "post", null);

		logger.debug("ezPMS addTaskLog ended");

		return null;
	}

	/**
	 * 작업이력 리스트 페이지 및 업무 트리 호출
	 * 
	 * @param loginCookie
	 * @param request
	 * @param resp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezPMS/getTaskLogMain.do")
	public String getTaskLogMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model) throws Exception {
		logger.debug("ezPMS getTaskLogMain started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String projectId = request.getParameter("projectId");
		String onlyGroup = request.getParameter("onlyGroup");

		HashMap<String, Object> param = new HashMap<String, Object>();

		param.put("onlyGroup", onlyGroup);
		param.put("location", "taskLog");

		// 작업이력 tree호출
		JSONObject resultBody = commonUtil.getJsonFromRestApi(
				"/rest/ezPMS/tree/" + projectId + "/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBody.get("status").toString();

		if (status.equals("ok")) {
			JSONArray treeData = (JSONArray) resultBody.get("data");
			model.addAttribute("data", treeData);
		}

		model.addAttribute("projectId", request.getParameter("projectId"));

		logger.debug("ezPMS getTaskLogMain ended");
		return "ezPMS/pmsTaskLogMain";
	}

	/**
	 * 작업이력 리스트
	 * 
	 * @param loginCookie
	 * @param request
	 * @param resp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezPMS/getTaskLogList.do")
	public String getTaskLogList(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> param,
			HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		logger.debug("ezPMS getTaskLogList started");
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

			if (countJson.get("taskLogListCount").toString() != null) {
				logListCount = Integer.parseInt(countJson.get("taskLogListCount").toString());
				model.addAttribute("taskLogListCount", logListCount);
				model.addAttribute("contentTitle", projectId);
				ProjectPagination paging = new ProjectPagination(logListCount, listNumber, 10, currentPage);
				model.addAttribute("paging", paging);

				if (logListCount != 0) {
					// 현재 페이지
					param.put("currentPage", currentPage);
					// 한 페이지에 보여질 개수
					param.put("listNumber", listNumber);
					// 프로젝트 총 개수
					param.put("listCount", logListCount);
					param.put("startCount", paging.getStartCount());

					JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "get", null);
					String status = result.get("status").toString();

					if (status.equals("ok")) {
						JSONObject data = (JSONObject) result.get("data");
						model.addAttribute("logList", data.get("taskLogList"));
						//model.addAttribute("groupDetails", data.get("groupDetails"));
						model.addAttribute("taskDetails", data.get("taskDetails"));
					}
				} else {// log count가 0일 때
					if (param.get("taskId").toString().equals("0")) { // 요청이 그룹일  경우
						long groupId = Long.parseLong(param.get("groupId").toString());
						String groupUrl = "/rest/ezPMS/groups/" + groupId + "/users/" + userId;

						param.put("projectId", projectId);

						JSONObject result = commonUtil.getJsonFromRestApi(groupUrl, param, request, "get", null);
						String status = result.get("status").toString();

						if (status.equals("ok")) {
							JSONObject groupDetails = (JSONObject) result.get("data");
							model.addAttribute("taskDetails", groupDetails.get("groupDetails"));
						}
					} else {// 요청이 업무일 경우
						long taskId = Long.parseLong(param.get("taskId").toString());
						String taskUrl = "/rest/ezPMS/tasks/" + taskId + "/users/" + userInfo.getId();

						param.put("projectId", projectId);

						JSONObject result = commonUtil.getJsonFromRestApi(taskUrl, param, request, "get", null);
						String status = result.get("status").toString();

						if (status.equals("ok")) {
							JSONObject taskDetails = (JSONObject) result.get("data");
							model.addAttribute("taskDetails", taskDetails.get("taskDetails"));
						}
					}
				}
			}
		}
		logger.debug("ezPMS getTaskLogList ended");
		return "ezPMS/pmsTaskLogList";
	}

	/**
	 * 담당자, 참여자, 조회자 선택 조직도 화면 호출
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezPMS/pmsSelectAuth.do")
	public String selectAuth(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("ezPMS selectAuth started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());

		JSONObject result = commonUtil.getJsonFromRestApi("/rest/ezPMS/depts", param, request, "get", null);
		String status = result.get("status").toString();
		String type = request.getParameter("type");
		String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());

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

			model.addAttribute("type", type);
			model.addAttribute("deptList", deptList);
			model.addAttribute("userId", userInfo.getId());
			model.addAttribute("userName", userInfo.getDisplayName1());
			model.addAttribute("userDept", userInfo.getDeptName1());
			model.addAttribute("primaryLang", primaryLang);
		}

		String rtnStr = "";
		if (type.equals("headManager")) {
			rtnStr = "/ezPMS/pmsSelectAuth2";
		} else {
			rtnStr = "/ezPMS/pmsSelectAuth";
		}

		logger.debug("ezPMS selectAuth ended");
		return rtnStr;
	}

	/**
	 * 사원리스트
	 */
	@RequestMapping(value = "/ezPMS/userList.do")
	public String userList(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {
		logger.debug("ezPMS userList started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		HashMap<String, Object> param = new HashMap<String, Object>();
		String key = request.getParameter("key");
		param.put("key", key);
		param.put("value", request.getParameter("value"));
		param.put("userId", userInfo.getId());

		logger.debug(request.getParameter("key"));
		logger.debug(request.getParameter("value"));

		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/users", param, request, "get", null);
		String status = resultBody.get("status").toString();
		if (status.equals("ok")) {
			JSONArray userList = (JSONArray) resultBody.get("data");

			model.addAttribute("userList", userList);

			String keyword = "";
			if (key.equals("DEPARTMENT")) {
				// keyword = (String)
				// ((JSONObject)userList.get(0)).get("deptName");
				keyword = request.getParameter("deptName");
			} else {
				keyword = egovMessageSource.getMessage("ezPMS.t1", userInfo.getLocale());
			}
			int userCount = 0;
			if (userList.size() == 0 && !key.equals("DEPARTMENT")) {
				keyword = egovMessageSource.getMessage("ezPMS.t2", userInfo.getLocale());
			} else {
				userCount = userList.size();
			}
			model.addAttribute("keyword", keyword);
			model.addAttribute("userCount", userCount);
		}

		logger.debug("ezPMS userList ended");
		return "ezPMS/userList";
	}

	/**
	 * 프로젝트 총괄 책임자 선택 화면 호출
	 */
	@RequestMapping(value = "/ezPMS/selectHeadManager.do")
	public String selectHeadManager(HttpServletRequest request, Model model,
			@CookieValue("loginCookie") String loginCookie) {
		logger.debug("ezPMS selectHeadManager started");
		logger.debug("ezPMS selectHeadManager ended");
		return "ezPMS/selectHeadManager";
	}

	/**
	 * 프로젝트 총괄 책임자 선택 화면 호출 중 user type이 dept인 경우 부서 인원을 불러옴
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezPMS/getDeptUserList.do")
	@ResponseBody
	public JSONObject getDeptUserList(HttpServletRequest request, Model model,
			@CookieValue("loginCookie") String loginCookie) {
		logger.debug("ezPMS getDeptUserList started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		Map<String, Object> param = new HashMap<String, Object>();
		String key = request.getParameter("key");
		param.put("key", key);
		param.put("value", request.getParameter("value"));
		param.put("userId", userInfo.getId());
		param.put("lang", userInfo.getLang());

		logger.debug(request.getParameter("key"));
		logger.debug(request.getParameter("value"));

		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/users", param, request, "get", null);
		String status = resultBody.get("status").toString();

		JSONObject result = new JSONObject();

		if (status.equals("ok")) {
			JSONArray userList = (JSONArray) resultBody.get("data");

			result.put("userList", userList);

		}

		logger.debug("ezPMS getDeptUserList ended");
		return result;
	}

	/**
	 * 프로젝트 생성 시 알림메일 발송
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezPMS/sendNotiMail.do")
	@ResponseBody
	public String sendNotiMail(@RequestBody Map<String, Object> param, HttpServletRequest request, Model model,
			@CookieValue("loginCookie") String loginCookie) {
		logger.debug("ezPMS sendNotiMail Started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String mode = param.get("mode").toString();
		String projectName = (String) param.get("projectName");
		long projectId = Long.parseLong(param.get("projectId").toString());
		String headManagerId = param.get("headManagerId").toString();
		String beforeHeadManagerId = param.get("beforeHeadManagerId").toString();
		
		List<Map<String, Object>> headManager = null;
		List<Map<String, Object>> managerList = null;
		List<Map<String, Object>> participantList = null;
		List<Map<String, Object>> viewerList = null;
		List<Map<String, Object>> beforeManagerList = null;
		List<Map<String, Object>> beforeParticipantList = null;
		List<Map<String, Object>> beforeViewerList = null;

		param.put("tenantId", userInfo.getTenantId());

		try {
			// 프로젝트 담당자
			if (param.get("managerList") != null) {
				managerList = ((List<Map<String, Object>>) param.get("managerList"));
				
				headManager = managerList.stream().filter(o -> o.get("userId").equals(headManagerId)).collect(Collectors.toList());
				managerList = managerList.stream().filter(o -> !o.get("userId").equals(headManagerId)).collect(Collectors.toList());

				// 이전 member의 집합
				if (mode.equals("edit")) {
					if (param.get("beforeManagerList") != null) {
						beforeManagerList = (List<Map<String, Object>>) param.get("beforeManagerList");
						beforeManagerList = beforeManagerList.stream().filter(o -> !o.get("userId").equals(beforeHeadManagerId)).collect(Collectors.toList());

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
					
					if(headManagerId.equals(beforeHeadManagerId)) {
						headManager.remove(0);
					}	
				}
				
				getToArrMailList(headManager, param, request, projectName, projectId,
						egovMessageSource.getMessage("ezPMS.t330", userInfo.getLocale()), loginCookie);
	
				getToArrMailList(managerList, param, request, projectName, projectId,
						egovMessageSource.getMessage("ezPMS.t63", userInfo.getLocale()), loginCookie);
			}

			// 프로젝트 참여자
			if (param.get("participantList") != null) {
				participantList = (List<Map<String, Object>>) param.get("participantList");

				// 이전 member의 집합
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

				getToArrMailList(participantList, param, request, projectName, projectId,
						egovMessageSource.getMessage("ezPMS.t64", userInfo.getLocale()), loginCookie);
			}

			// 프로젝트 조회자
			if (param.get("viewerList") != null) {
				viewerList = (List<Map<String, Object>>) param.get("viewerList");

				// 이전 member의 집합
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

				getToArrMailList(viewerList, param, request, projectName, projectId,
						egovMessageSource.getMessage("ezPMS.t65", userInfo.getLocale()), loginCookie);
			}
			
		} catch (Exception e) {
			logger.debug("sendNotiMail ERROR : " + e.getMessage());
			logger.error(e.getMessage(), e);
		}

		logger.debug("ezPMS sendNotiMail Ended.");
		return "";
	}

	/**
	 * 메일 전송 함수
	 * 
	 * @param nameList
	 * @param param
	 * @param request
	 * @param projectName
	 * @param projectId
	 * @param authName
	 * @param loginCookie
	 * @return
	 */
	public InternetAddress[] getToArrMailList(List<Map<String, Object>> nameList, Map<String, Object> param,
			HttpServletRequest request, String projectName, long projectId, String authName,
			@CookieValue("loginCookie") String loginCookie) {
		logger.debug("ezPMS getToArrMailList started");

		ArrayList<InternetAddress> toArrList = new ArrayList<InternetAddress>();
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		try {
			if (nameList.size() == 0) {
				return null;
			}

			for (int i = 0; i < nameList.size(); i++) {
				String userId = (String) nameList.get(i).get("userId");

				param.put("userIdType", (String) nameList.get(i).get("userIdType"));

				JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/users/" + userId + "/setting", param, request, "get", null);
				String status = resultBody.get("status").toString();

				if (status.equals("ok")) {
					JSONObject manager = (JSONObject) resultBody.get("data");
					InternetAddress toManager = new InternetAddress();
					toManager.setAddress((String) manager.get("userMail"));
					toManager.setPersonal((String) manager.get("userName"));

					logger.debug("userMail : " + (String) manager.get("userMail") + ", userName : "	+ (String) manager.get("userName"));
					toArrList.add(toManager);
				}
			}

			InternetAddress[] toArr = new InternetAddress[toArrList.size()];

			for (int i = 0; i < toArrList.size(); i++) {
				toArr[i] = toArrList.get(i);
			}

			// 프로젝트 정보 가져오기
			String url = "/rest/ezPMS/projects/" + projectId + "/userId/" + userInfo.getId();
			param.put("mode", "");
			JSONObject resultBody = commonUtil.getJsonFromRestApi(url, param, request, "get", null);
			String status = resultBody.get("status").toString();

			String planStartDate = "";
			String planEndDate = "";
			String overview = "";
			float progress = 0;

			if (status.equals("ok")) {
				JSONObject data = (JSONObject) resultBody.get("data");
				JSONObject projectDetails = (JSONObject) data.get("project");
				planStartDate = projectDetails.get("planStartDate").toString();
				planEndDate = projectDetails.get("planEndDate").toString();
				overview = projectDetails.get("overview").toString();
				progress = Float.parseFloat(projectDetails.get("progress").toString());
			}
			
			// 메일 제목
			String subject = egovMessageSource.getMessageExtend("ezPMS.t200", new Object[] {projectName, authName} ,userInfo.getLocale());

			// 메일 내용
			String content = "<p>" + egovMessageSource.getMessageExtend("ezPMS.t200", new Object[] {commonUtil.cleanValue(projectName), authName} ,userInfo.getLocale()) + "</p>";
			content += "<p></p>";
			content += "<a href='#' target='' onclick='goProjectDetails(\"" + projectId + "\")'>" + egovMessageSource.getMessageExtend("ezPMS.t201", new Object[] {commonUtil.cleanValue(projectName)}, userInfo.getLocale()) + "</a><br/><br/>";
			content += "===================================================================<br/>";
			content += "<p style='font-size:14px'><strong>[" + commonUtil.cleanValue(projectName) + "]</strong></p>";
			content += "<p> - " + egovMessageSource.getMessage("ezPMS.t250", userInfo.getLocale()) + " : " + progress + "</p>";
			content += "<p> - " + egovMessageSource.getMessage("ezPMS.t61", userInfo.getLocale()) + " : " + planStartDate + "</p>";
			content += "<p> - " + egovMessageSource.getMessage("ezPMS.t62", userInfo.getLocale()) + " : " + planEndDate	+ "</p>";
			content += "<p> - " + egovMessageSource.getMessage("ezPMS.t66", userInfo.getLocale()) + " : " + commonUtil.cleanValue(overview) + "</p>";

			InternetAddress from;
			from = new InternetAddress(userInfo.getEmail());
			from.setPersonal(userInfo.getDisplayName());

			ezEmailService.sendMail(loginCookie, from, toArr, null, null, subject, content, false);

			logger.debug("ezPMS getToArrMailList ended");
			return toArr;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			logger.debug("ezPMS getToArrMailList ERROR : " + e.getMessage());
			return null;
		}
	}

	/**
	 * 프로젝트 이름 목록 호출 함수
	 * 
	 * @param loginCookie
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezPMS/getProjectNameList.do")
	public String getProjectNameList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse response, Model model) throws Exception {
		logger.debug("ezPMS getProjectNameList Started.");

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

		logger.debug("ezPMS getProjectNameList Ended.");
		return "ezPMS/projectNameList";
	}

	/**
	 * 총괄담당자 정보 리스트 호출 함수
	 * 
	 * @param loginCookie
	 * @param param
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezPMS/getHeadManagerList.do")
	@ResponseBody
	public JSONObject getHeadManagerList(@CookieValue("loginCookie") String loginCookie,
			@RequestBody Map<String, Object> param, HttpServletRequest request, HttpServletResponse response,
			Model model) throws Exception {
		logger.debug("ezPMS getHeadManagerList started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();

		String url = "/rest/ezPMS/list/users";
		param.put("userId", userId);

		List<Map<String, Object>> managerList = null;

		try {
			managerList = (List<Map<String, Object>>) param.get("userList");
			// IE에서는 LinkedHashMap으로만 cast할 수 있게 값이 넘어옴
		} catch (ClassCastException e) {
			Map<Integer, Map<String, Object>> tempMap = (Map<Integer, Map<String, Object>>) param.get("userList");
			managerList = new ArrayList<Map<String, Object>>(tempMap.values());
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

		logger.debug("ezPMS getHeadManagerList ended");
		return userList;
	}

	/**
	 * 프로젝트 개요 내 작업이력 및 의견 호출 함수
	 * 
	 * @param loginCookie
	 * @param param
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezPMS/getOverviewContent.do")
	@ResponseBody
	public JSONObject getOverviewContent(@CookieValue("loginCookie") String loginCookie,
			@RequestBody Map<String, Object> param, HttpServletRequest request, HttpServletResponse response,
			Model model) throws Exception {
		logger.debug("ezPMS getOverviewContent started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		long projectId = Long.parseLong(param.get("projectId").toString());

		JSONObject overviewContent = new JSONObject();

		// 작업이력 불러오기
		String logUrl = "/rest/ezPMS/projects/" + projectId + "/logs";
		param.put("userId", userId);

		JSONObject logResult = commonUtil.getJsonFromRestApi(logUrl, param, request, "get", null);
		String logStatus = logResult.get("status").toString();

		if (logStatus.equals("ok")) {
			JSONObject data = (JSONObject) logResult.get("data");
			overviewContent.put("logList", data.get("taskLogList"));
		}

		// 의견 불러오기
		String commentUrl = "/rest/ezPMS/comments/list/" + projectId + "/users/" + userId;
		JSONObject commentResult = commonUtil.getJsonFromRestApi(commentUrl, param, request, "get", null);
		String commentStatus = commentResult.get("status").toString();

		if (commentStatus.equals("ok")) {
			JSONArray commentData = (JSONArray) commentResult.get("data");
			overviewContent.put("commentList", commentData);
		}

		logger.debug("ezPMS getOverviewContent ended");
		return overviewContent;

	}

	/**
	 * 프로젝트관리 상세페이지 업무 리스트 탭의 업무 리스트 호출함수
	 * 
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value = "/ezPMS/getProjectTaskList.do")
	public String getProjectTaskList(HttpServletRequest request, Model model, @RequestBody Map<String, Object> param,
			@CookieValue("loginCookie") String loginCookie) {

		logger.debug("ezPMS projectTaskList started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		long projectId = Long.parseLong(param.get("projectId").toString());
		String userId = userInfo.getId();

		param.put("userId", userId);

		String countUrl = "/rest/ezPMS/projects/" + projectId + "/tasks/count";
		String url = "";
		
		if(projectId == 0){
			url = "/rest/ezPMS/task-list/" + projectId + "/users/" + userId + "/myTask";
		} else {
			url = "/rest/ezPMS/task-list/" + projectId + "/users/" + userId;
		}

		JSONObject countResult = commonUtil.getJsonFromRestApi(countUrl, param, request, "get", null);
		String countStatus = countResult.get("status").toString();

		int taskListCount = 0;
		int listNumber = Integer.parseInt(param.get("listNumber").toString());
		int currentPage = Integer.parseInt(param.get("currentPage").toString());

		if (countStatus.equals("ok")) {
			if (!countResult.get("data").equals("")) {
				taskListCount = Integer.parseInt(countResult.get("data").toString());
				model.addAttribute("taskListCount", taskListCount);

				ProjectPagination paging = new ProjectPagination(taskListCount, listNumber, 10, currentPage);
				model.addAttribute("paging", paging);

				if (taskListCount != 0) {
					// 현재 페이지
					param.put("currentPage", currentPage);
					// 한 페이지에 보여질 개수
					param.put("limit", listNumber);
					// 프로젝트 총 개수
					param.put("listCount", taskListCount);
					param.put("startRow", paging.getStartCount());

					// header 정렬 프로젝트 순서
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
					String userRoleUrl = "/rest/ezPMS/projects/" + projectId + "/users/" + userId + "/role";
					JSONObject roleResult = commonUtil.getJsonFromRestApi(userRoleUrl, param, request, "get", null);
					String roleStatus = roleResult.get("status").toString();
					
					if (roleStatus.equals("ok")) {
						model.addAttribute("userRole", roleResult.get("data"));
					}
					
					if (param.get("groupId") != null) {
						long groupId = Long.parseLong(param.get("groupId").toString());
						String groupUrl = "/rest/ezPMS/groups/" + groupId + "/users/" + userId;
						
						param.put("projectId", projectId);

						JSONObject result = commonUtil.getJsonFromRestApi(groupUrl, param, request, "get", null);
						String status = result.get("status").toString();

						if (status.equals("ok")) {
							JSONObject groupDetails = (JSONObject) result.get("data");
							model.addAttribute("groupDetail", groupDetails.get("groupDetails"));
						}
					} else {
						model.addAttribute("groupDetail", "{}");
						model.addAttribute("position", param.get("position"));
					}
				}
			}
		}

		logger.debug("[result] taskListCount : " + taskListCount);
		logger.debug("ezPMS projectTaskList ended");

		return "/ezPMS/pmsTaskList";
	}

	/**
	 * 프로젝트관리 업무 리스트 메인 화면 호출함수
	 * 
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value = "/ezPMS/getTaskListMain.do")
	public String getTaskListMain(HttpServletRequest request, Model model,
			@CookieValue("loginCookie") String loginCookie) {

		logger.debug("ezPMS taskListMain started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();

		String projectId = request.getParameter("projectId");
		String onlyGroup = request.getParameter("onlyGroup");

		HashMap<String, Object> param = new HashMap<String, Object>();

		param.put("onlyGroup", onlyGroup);
		param.put("location", "taskList");
		param.put("userId", userId);

		// 작업 트리 (그룹모음) 호출
		JSONObject resultBody = commonUtil.getJsonFromRestApi(
				"/rest/ezPMS/tree/" + projectId + "/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBody.get("status").toString();

		if (status.equals("ok")) {
			JSONArray treeData = (JSONArray) resultBody.get("data");
			model.addAttribute("data", treeData);
		}

		// 업무 리스트 개수 호출
		String countUrl = "/rest/ezPMS/projects/" + projectId + "/tasks/count";
		JSONObject countResult = commonUtil.getJsonFromRestApi(countUrl, param, request, "get", null);
		String countStatus = countResult.get("status").toString();

		int taskListCount = 0;

		if (countStatus.equals("ok")) {
			if (!countResult.get("data").equals("")) {
				taskListCount = Integer.parseInt(countResult.get("data").toString());
				model.addAttribute("taskListCount", taskListCount);
			}
		}

		// 사용자 role Id호출
		String roleUrl = "/rest/ezPMS/projects/" + projectId + "/users/" + userId + "/role";
		JSONObject roleResult = commonUtil.getJsonFromRestApi(roleUrl, param, request, "get", null);
		String roleStatus = roleResult.get("status").toString();

		if (roleStatus.equals("ok")) {
			int userRole = Integer.parseInt(roleResult.get("data").toString());
			model.addAttribute("userRole", userRole);
		}

		model.addAttribute("projectId", request.getParameter("projectId"));

		logger.debug("ezPMS taskListMain ended");
		return "/ezPMS/pmsTaskListMain";
	}

	/**
	 * 프로젝트 관리 업무 삭제 실행 함수
	 */
	@RequestMapping(value = "/ezPMS/deleteTask.do")
	public String deleteTask(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {
		logger.debug("ezPMS deleteTask started");

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
			model.addAttribute("checkPermission", checkPermission);
			double projectProgress = (double) result.get("projectProgress");
			model.addAttribute("projectProgress", projectProgress);
			logger.debug("projectProgress : " + projectProgress);
		}

		logger.debug("ezPMS deleteTask ended");

		return "json";
	}

	/**
	 * 나의 업무 : 담당 그룹 리스트 호출
	 */
	@RequestMapping(value = "/ezPMS/getGroupList.do")
	public String getMyGroupList(@RequestBody Map<String, Object> param, HttpServletRequest request, Model model,
			@CookieValue("loginCookie") String loginCookie) {
		logger.debug("ezPMS getMyGroupList started");
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
			if (!countResult.get("data").equals("")) {
				groupCount = Integer.parseInt(countResult.get("data").toString());
				model.addAttribute("taskListCount", groupCount);

				ProjectPagination paging = new ProjectPagination(groupCount, listNumber, 10, currentPage);
				model.addAttribute("paging", paging);

				if (groupCount != 0) {
					// 현재 페이지
					param.put("currentPage", currentPage);
					// 한 페이지에 보여질 개수
					param.put("limit", listNumber);
					// 프로젝트 총 개수
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

		logger.debug("ezPMS getMyGroupList ended");
		return "ezPMS/pmsTaskList";
	}

	/**
	 * 나의 업무 : 담당프로젝트 리스트 호출
	 * 
	 * @param param
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value = "/ezPMS/getMyProjectList.do")
	public String getMyProjectList(@RequestBody Map<String, Object> param, HttpServletRequest request, Model model,
			@CookieValue("loginCookie") String loginCookie) {
		logger.debug("ezPMS getMyProjectList started");
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

				ProjectPagination paging = new ProjectPagination(projectListCount, listNumber, 10, currentPage);
				model.addAttribute("paging", paging);

				if (projectListCount != 0) {
					// 현재 페이지
					param.put("currentPage", currentPage);
					// 한 페이지에 보여질 개수
					param.put("listNumber", listNumber);
					// 프로젝트 총 개수
					param.put("listCount", projectListCount);
					param.put("startCount", paging.getStartCount());

					// header 정렬 프로젝트 순서
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

		logger.debug("ezPMS getMyProjectList ended");
		return "ezPMS/pmsMyProjectList";
	}

	/**
	 * 프로젝트 관리 상태 색상변경 팝업 호출
	 */
	@RequestMapping(value = "/ezPMS/getColorPicker.do")
	public String getColorPicker() {
		return "ezPMS/pmsStatusColor";
	}

	// /**
	// * 간트차트에서의 날짜 변경
	// */
	// @SuppressWarnings("unchecked")
	// @RequestMapping(value="/ezPMS/updateTaskDate.do")
	// @ResponseBody
	// public JSONObject updateTaskDate(@RequestBody Map<String, Object> param,
	// HttpServletRequest request, Model model, @CookieValue("loginCookie")
	// String loginCookie) {
	// logger.debug("ezPMS updateTaskDate started");
	// LoginVO userInfo = commonUtil.userInfo(loginCookie);
	// String userId = userInfo.getId();
	//
	// String url = "/rest/ezPMS/tasks/" + param.get("taskId") + "/users/" +
	// userId + "/status";
	//
	// JSONObject result = commonUtil.getJsonFromRestApi(url, param, request,
	// "put", null);
	// String status = result.get("status").toString();
	// JSONObject json = new JSONObject();
	//
	// if (status.equals("ok")) {
	// JSONObject data = (JSONObject) result.get("data");
	// String roleCheck = data.get("roleCheck").toString();
	// String endDate = data.get("endDate").toString();
	//
	// json.put("roleCheck", roleCheck);
	// json.put("endDate", endDate);
	//
	// logger.debug("[result] roleCheck : " + roleCheck);
	// }
	//
	// logger.debug("ezPMS updateTaskDate ended");
	// return json;
	// }

	/**
	 * 간트차트에서의 선행작업 지정
	 */
	@RequestMapping(value = "/ezPMS/addPreTaskRel.do")
	@ResponseBody
	public String addPreTaskRel(@RequestBody Map<String, Object> param, HttpServletRequest request, Model model,
			@CookieValue("loginCookie") String loginCookie) {
		logger.debug("ezPMS addPreTaskRel started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();

		String url = "/rest/ezPMS/tasks/" + param.get("taskId") + "/preTasks/" + param.get("preTaskId") + "/type/"
				+ param.get("type");
		param.put("userId", userId);

		JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "post", null);
		String status = result.get("status").toString();
		String roleCheck = "";

		if (status.equals("ok")) {
			roleCheck = result.get("data").toString();
		}

		logger.debug("[result] roleCheck : " + roleCheck);
		logger.debug("ezPMS addPreTaskRel ended");
		return roleCheck;
	}

	/**
	 * 간트차트 그룹 및 업무 순서 변경
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezPMS/changeGanttOrder.do")
	@ResponseBody
	public String changeGanttOrder(@RequestBody Map<String, Object> param, HttpServletRequest request, Model model,
			@CookieValue("loginCookie") String loginCookie) {
		logger.debug("ezPMS changeGanttOrder started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		long projectId = Long.parseLong(param.get("projectId").toString());

		String url = "/rest/ezPMS/project/" + projectId + "/gantt/order";
		param.put("userId", userId);

		JSONObject jsonList = new JSONObject();
		jsonList.put("groupList", param.get("groupArr"));
		jsonList.put("taskList", param.get("taskArr"));

		// head의 overflow 막기 위해 groupArr과 taskArr param에서 제거
		param.remove("groupArr");
		param.remove("taskArr");

		JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "put", jsonList);
		String status = result.get("status").toString();
		String roleCheck = "";

		if (status.equals("ok")) {
			roleCheck = result.get("data").toString();
		}

		logger.debug("ezPMS changeGanttOrder ended");
		return roleCheck;
	}

	/**
	 * 그룹 상세보기 함수 실행
	 */
	@RequestMapping(value = "/ezPMS/getGroupDetails.do")
	public String getGroupDetails(HttpServletRequest request, Model model,
			@CookieValue("loginCookie") String loginCookie) {
		logger.debug("ezPMS getGroupDetails started");
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
			JSONObject groupInfo = (JSONObject) result.get("data");
			JSONObject taskDetails = (JSONObject) groupInfo.get("groupDetails");

			model.addAttribute("userRoleId", groupInfo.get("userRoleId"));
			model.addAttribute("taskDetails", taskDetails);
		}

		param.put("userIdType", "user");
		JSONObject resultMS = commonUtil.getJsonFromRestApi("/rest/ezPMS/users/" + userInfo.getId() + "/setting", param,
				request, "get", null);
		status = resultMS.get("status").toString();

		if (status.equals("ok")) {
			JSONObject mainSetting = (JSONObject) resultMS.get("data");
			model.addAttribute("mainSetting", mainSetting);
		}

		model.addAttribute("target", "group");
		logger.debug("ezPMS getGroupDetails ended");
		return "ezPMS/pmsTaskDetails";
	}

	/**
	 * 그룹 수정 함수 호출
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezPMS/updateGroupInfo.do")
	@ResponseBody
	public String updateGroupInfo(@RequestBody Map<String, Object> param, HttpServletRequest request, Model model,
			@CookieValue("loginCookie") String loginCookie) {
		logger.debug("ezPMS updateGroupInfo started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		long groupId = Long.parseLong(param.get("groupId").toString());

		JSONObject jsonList = new JSONObject();
		jsonList.put("managerList", param.get("managerList"));
		jsonList.put("participantList", param.get("participantList"));
		jsonList.put("addMemberList", param.get("addMemberList"));
		jsonList.put("delMemberList", param.get("delMemberList"));
		jsonList.put("overview", param.get("overview"));

		// param에서 member list 제거
		param.remove("managerList");
		param.remove("participantList");
		param.remove("addMemberList");
		param.remove("delMemberList");
		param.remove("overview");

		String url = "/rest/ezPMS/groups/" + groupId + "/users/" + userId;
		JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "put", jsonList);
		String status = result.get("status").toString();
		String roleCheck = "";

		if (status.equals("ok")) {
			roleCheck = result.get("data").toString();
		}

		logger.debug("[result] roleCheck : " + roleCheck);
		logger.debug("ezPMS updateGroupInfo ended");
		return roleCheck;
	}

	/**
	 * 인력관리 화면 호출
	 * 
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value = "/ezPMS/getMemberSchedule.do")
	public String getMemberSchedule(HttpServletRequest request, Model model,
			@CookieValue("loginCookie") String loginCookie) {
		logger.debug("ezPMS getMemberSchedule started");
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

		logger.debug("ezPMS getMemberSchedule ended");
		return "ezPMS/pmsMemberSchedule";
	}

	/**
	 * 선택된 날짜가 포함된 업무 목록 호출 함수 실행
	 * 
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezPMS/getDateTaskList.do")
	@ResponseBody
	public List<String> getDateTaskList(HttpServletRequest request, Model model,
			@CookieValue("loginCookie") String loginCookie) {
		logger.debug("ezPMS getDateTaskList started");
		List<String> taskList = new ArrayList<String>();

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
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

		logger.debug("ezPMS getDateTaskList started");
		return taskList;
	}

	// 홍대표 작성
	/**
	 * 프로젝트관리 프로젝트 업무 트리 호출함수
	 * 
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value = "/ezPMS/projectTaskTree.do")
	public String projectTaskTree(HttpServletRequest request, Model model,
			@CookieValue("loginCookie") String loginCookie) {

		logger.debug("ezPMS projectTaskTree started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String projectId = request.getParameter("projectId");

		String onlyGroup = request.getParameter("onlyGroup");

		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("onlyGroup", onlyGroup);
		param.put("location", request.getParameter("location"));

		JSONObject resultBody = commonUtil.getJsonFromRestApi(
				"/rest/ezPMS/tree/" + projectId + "/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBody.get("status").toString();

		if (status.equals("ok")) {
			JSONArray treeData = (JSONArray) resultBody.get("data");
			model.addAttribute("data", treeData);
		}

		logger.debug("ezPMS projectTaskTree ended");

		return "json";
	}

	/**
	 * 프로젝트관리 업무 등록 화면 호출함수
	 * 
	 * @param request
	 * @param model
	 * @param vo
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value = "/ezPMS/goAddTask.do")
	public String goAddTask(HttpServletRequest request, Model model, ProjectTaskVO vo,
			@CookieValue("loginCookie") String loginCookie) {

		logger.debug("ezPMS addTask started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String writerId = userInfo.getId();
		String writerName = userInfo.getDisplayName();
		String writerDeptName = userInfo.getDeptName();
		int tenantId = userInfo.getTenantId();

		String projectId = request.getParameter("projectId");

		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("tenantId", tenantId);

		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/weight/" + projectId, param, request, "get",
				null);
		String status = resultBody.get("status").toString();

		if (status.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			model.addAttribute("remainingWeight", data.get("remainingWeight"));
			model.addAttribute("projectStartDate", data.get("projectStartDate"));
			model.addAttribute("projectEndDate", data.get("projectEndDate"));
			model.addAttribute("weightInput", data.get("weightInput"));
			model.addAttribute("projectStatus", data.get("projectStatus"));
		}

		model.addAttribute("projectId", projectId);
		model.addAttribute("writerId", writerId);
		model.addAttribute("writerName", writerName);
		model.addAttribute("writerDeptName", writerDeptName);

		logger.debug("ezPMS addTask ended");

		return "/ezPMS/pmsAddTask";
	}

	/**
	 * 프로젝트관리 업무 등록 함수
	 * 
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezPMS/addTask.do")
	public String addTask(HttpServletRequest request, Model model, @RequestBody Map<String, Object> param,
			@CookieValue("loginCookie") String loginCookie) throws Exception {

		logger.debug("ezPMS addTask started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String today = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);

		String projectId = (String) param.get("projectId");

		param.put("tenantId", userInfo.getTenantId());
		param.put("writerId", userInfo.getId());
		param.put("writeDate", today);
		param.put("writerName", userInfo.getDisplayName1());
		param.put("writerName2", userInfo.getDisplayName2());
		param.put("writerDeptname", userInfo.getDeptName1());
		param.put("writerDeptname2", userInfo.getDeptName2());

		JSONObject jsonList = new JSONObject();
		jsonList.put("managerList", param.get("managerList"));
		jsonList.put("overview", param.get("overview"));

		param.remove("managerList");
		param.remove("overview");
		JSONObject resultBody = commonUtil.getJsonFromRestApi(
				"/rest/ezPMS/tasks/" + projectId + "/users/" + userInfo.getId(), param, request, "post", jsonList);
		String status = resultBody.get("status").toString();

		if (status.equals("ok")) {
			String taskId = (String) resultBody.get("data");
			double projectProgress = (double) resultBody.get("projectProgress"); 
			model.addAttribute("data", taskId);
			model.addAttribute("projectProgress", projectProgress);
		}

		logger.debug("ezPMS addTask ended");

		return "json";
	}

	/**
	 * 프로젝트 참여 멤버 조회
	 * 
	 * @param loginCookie
	 * @param request
	 * @param resp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezPMS/getProjectMemberList.do")
	public String getProjectMemberList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model) throws Exception {
		logger.debug("ezPMS getProjectMemberList started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String projectId = request.getParameter("projectId");
		String groupId = request.getParameter("groupId");
		String roleId = request.getParameter("roleId");

		String url = null;

		// 상위그룹이 프로젝트 자체일 때는 groupId값이 넘어오지 않는다
		if (groupId != null && !groupId.equals("")) {
			url = "/rest/ezPMS/member-list/" + projectId + "/groupId/" + groupId;
		} else {
			url = "/rest/ezPMS/projects/" + projectId + "/roles/" + roleId;
		}

		HashMap<String, Object> param = new HashMap<String, Object>();

		param.put("userId", userInfo.getId());
		param.put("isGantt", 0);

		JSONObject resultBody = commonUtil.getJsonFromRestApi(url, param, request, "get", null);
		String status = resultBody.get("status").toString();

		if (status.equals("ok")) {
			JSONArray memberList = (JSONArray) resultBody.get("data");
			model.addAttribute("memberList", memberList);
		}

		logger.debug("ezPMS getProjectMemberList ended");

		return "ezPMS/memberList";
	}

	/**
	 * 프로젝트관리 멤버리스트 페이지 화면 호출
	 * 
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value = "/ezPMS/goProjectMemberList.do")
	public String goProjectMemberList(HttpServletRequest request, Model model,
			@CookieValue("loginCookie") String loginCookie) {

		logger.debug("ezPMS goProjectMemberList started");

		String projectId = request.getParameter("projectId");
		String groupId = request.getParameter("groupId");
		String type = request.getParameter("type");

		model.addAttribute("projectId", projectId);
		model.addAttribute("groupId", groupId);
		model.addAttribute("type", type);

		logger.debug("ezPMS goProjectMemberList ended");

		return "/ezPMS/pmsSetTaskMember";
	}

	/**
	 * 프로젝트관리 그룹 트리 화면 호출(업무 제외)
	 * 
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value = "/ezPMS/goGroupTree.do")
	public String goGroupTree(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {

		logger.debug("ezPMS goGroupTree started");

		String projectId = request.getParameter("projectId");

		model.addAttribute("projectId", projectId);

		logger.debug("ezPMS goGroupTree ended");

		return "/ezPMS/groupTree";
	}

	/**
	 * 프로젝트관리 간트차트 프로젝트, 그룹, 업무 데이터 조회
	 * 
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value = "/ezPMS/getProjectForGantt.do")
	public String getProjectForGantt(HttpServletRequest request, Model model,
			@CookieValue("loginCookie") String loginCookie) {

		logger.debug("ezPMS getProjectForGantt started");
		
		Long startMillis = System.currentTimeMillis();
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String projectId = request.getParameter("projectId");
		String taskStatus = request.getParameter("status");

		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("position", "gantt");
		param.put("status", taskStatus);
		
		JSONObject resultBodyTask = commonUtil.getJsonFromRestApi(
				"/rest/ezPMS/task-list/" + projectId + "/users/" + userInfo.getId(), param, request, "get", null);
		
		String status = resultBodyTask.get("status").toString();
		

		if (status.equals("ok")) {
			JSONObject taskList = (JSONObject) resultBodyTask.get("data");
			model.addAttribute("taskList", taskList.get("taskList"));
			model.addAttribute("userRoleId", taskList.get("userRoleId"));
		}

		JSONObject resultBodyProject = commonUtil.getJsonFromRestApi(
				"/rest/ezPMS/projects/" + projectId + "/users/" + userInfo.getId() + "/gantt", param, request, "get",
				null);
		
		status = resultBodyProject.get("status").toString();

		if (status.equals("ok")) {
			JSONObject data = (JSONObject) resultBodyProject.get("data");
			model.addAttribute("projectDetail", data.get("project"));
			model.addAttribute("holidayList", data.get("holidayList"));
		}

		JSONObject resultBodyGroup = commonUtil.getJsonFromRestApi(
				"/rest/ezPMS/projects/" + projectId + "/groups/users/" + userInfo.getId() + "/gantt", param, request,
				"get", null);
		status = resultBodyGroup.get("status").toString();

		if (status.equals("ok")) {
			model.addAttribute("groupList", resultBodyGroup.get("data"));
		}

		if (taskStatus != null) {
			model.addAttribute("taskStatus", taskStatus);
		}

		model.addAttribute("projectId", projectId);
		
		Long endMillis = System.currentTimeMillis();
		logger.debug("lead time : " + ((endMillis - startMillis) / 1000.0) + " sec");
		logger.debug("ezPMS getProjectForGantt ended");

		return "/ezPMS/taskListGantt";
	}

	/**
	 * 업무 데이터 상세 조회
	 * 
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value = "/ezPMS/getTaskDetails.do")
	public String getTaskDetails(HttpServletRequest request, Model model,
			@CookieValue("loginCookie") String loginCookie) {

		logger.debug("ezPMS getTaskDetails started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String taskId = request.getParameter("taskId");
		String projectId = request.getParameter("projectId");

		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("tenantId", userInfo.getTenantId());
		param.put("projectId", projectId);

		JSONObject resultBody = commonUtil.getJsonFromRestApi(
				"/rest/ezPMS/tasks/" + taskId + "/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBody.get("status").toString();

		if (status.equals("ok")) {
			JSONObject taskDetails = (JSONObject) resultBody.get("data");
			model.addAttribute("taskDetails", taskDetails.get("taskDetails"));
			model.addAttribute("userRoleId", taskDetails.get("userRoleId"));
		}

		param.put("userIdType", request.getParameter("userIdType"));
		JSONObject resultMS = commonUtil.getJsonFromRestApi("/rest/ezPMS/users/" + userInfo.getId() + "/setting", param,
				request, "get", null);
		status = resultMS.get("status").toString();

		if (status.equals("ok")) {
			JSONObject mainSetting = (JSONObject) resultMS.get("data");
			model.addAttribute("mainSetting", mainSetting);
		}

		JSONObject resultBodyWeight = commonUtil.getJsonFromRestApi("/rest/ezPMS/weight/" + projectId, param, request,
				"get", null);
		status = resultBodyWeight.get("status").toString();

		if (status.equals("ok")) {
			JSONObject weightData = (JSONObject) resultBodyWeight.get("data");
			model.addAttribute("weightData", weightData);
		}

		logger.debug("ezPMS getTaskDetails ended");

		return "/ezPMS/pmsTaskDetails";
	}

	/**
	 * 업무 데이터 상세 조회 (업무정보 탭)
	 * 
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value = "/ezPMS/getTaskDetailsTab.do")
	public String getTaskDetailsTab(HttpServletRequest request, Model model,
			@CookieValue("loginCookie") String loginCookie) {

		logger.debug("ezPMS getTaskDetailsTab started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String taskId = request.getParameter("taskId");
		String groupId = request.getParameter("groupId");

		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("projectId", request.getParameter("projectId"));

		if (groupId == null || groupId.equals("")) { // 업무 상세 조회
			JSONObject resultBody = commonUtil.getJsonFromRestApi(
					"/rest/ezPMS/tasks/" + taskId + "/users/" + userInfo.getId(), param, request, "get", null);
			String status = resultBody.get("status").toString();

			if (status.equals("ok")) {
				JSONObject taskDetails = (JSONObject) resultBody.get("data");
				model.addAttribute("taskDetails", taskDetails.get("taskDetails"));
				model.addAttribute("target", "task");
			}
		} else { // 그룹 상세 조회
			JSONObject resultBody = commonUtil.getJsonFromRestApi(
					"/rest/ezPMS/groups/" + Long.parseLong(groupId) + "/users/" + userInfo.getId(), param, request,
					"get", null);
			String status = resultBody.get("status").toString();

			if (status.equals("ok")) {
				JSONObject taskDetails = (JSONObject) resultBody.get("data");
				model.addAttribute("taskDetails", taskDetails.get("groupDetails"));
				model.addAttribute("target", "group");
			}
		}

		logger.debug("ezPMS getTaskDetailsTab ended");

		return "/ezPMS/pmsTaskInfoTab";
	}

	/**
	 * 업무 정보 수정 페이지 호출
	 * 
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value = "/ezPMS/goUpdateTaskInfo.do")
	public String goTaskInfo(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {

		logger.debug("ezPMS goTaskInfo started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String taskId = request.getParameter("taskId");
		long projectId = 0;
		String target = request.getParameter("target");

		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("tenantId", userInfo.getTenantId());
		param.put("projectId", Long.parseLong(request.getParameter("projectId")));

		if (target.equals("task")) {
			JSONObject resultBody = commonUtil.getJsonFromRestApi(
					"/rest/ezPMS/tasks/" + taskId + "/users/" + userInfo.getId(), param, request, "get", null);
			String status = resultBody.get("status").toString();

			if (status.equals("ok")) {
				JSONObject result = (JSONObject) resultBody.get("data");
				JSONObject taskDetails = (JSONObject) result.get("taskDetails");
				model.addAttribute("taskDetails", taskDetails);
				projectId = Long.parseLong(taskDetails.get("projectId").toString());
			}

			JSONObject resultBodyWeight = commonUtil.getJsonFromRestApi("/rest/ezPMS/weight/" + projectId, param,
					request, "get", null);
			status = resultBodyWeight.get("status").toString();

			if (status.equals("ok")) {
				JSONObject weightData = (JSONObject) resultBodyWeight.get("data");
				model.addAttribute("weightData", weightData);
			}
		} else if (target.equals("group")) {
			projectId = Long.parseLong(request.getParameter("projectId"));
			param.put("projectId", projectId);

			JSONObject resultBody = commonUtil.getJsonFromRestApi(
					"/rest/ezPMS/groups/" + Long.parseLong(taskId) + "/users/" + userInfo.getId(), param, request,
					"get", null);
			String status = resultBody.get("status").toString();

			if (status.equals("ok")) {
				JSONObject taskDetails = (JSONObject) resultBody.get("data");
				model.addAttribute("taskDetails", taskDetails.get("groupDetails"));

				JSONObject resultBodyMember = commonUtil.getJsonFromRestApi(
						"/rest/ezPMS/tasks/member-list/group/" + Long.parseLong(taskId) + "/users/" + userInfo.getId(),
						param, request, "get", null);
				status = resultBodyMember.get("status").toString();

				if (status.equals("ok")) {
					JSONArray groupTaskMember = (JSONArray) resultBodyMember.get("data");
					model.addAttribute("groupTaskMember", groupTaskMember);
				}
			}
		}

		model.addAttribute("target", request.getParameter("target"));

		logger.debug("ezPMS goUpdateTaskInfo ended");

		return "/ezPMS/pmsTaskInfoUpdate";
	}

	/**
	 * 업무 정보 수정 실행 함수
	 * 
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezPMS/updateTaskInfo.do")
	@ResponseBody
	public String updateTaskInfo(HttpServletRequest request, Model model, @RequestBody Map<String, Object> param,
			@CookieValue("loginCookie") String loginCookie) {

		logger.debug("ezPMS updateTaskInfo started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();

		String taskId = (String) param.get("taskId");

		JSONObject jsonList = new JSONObject();
		jsonList.put("managerList", param.get("managerList"));
		jsonList.put("overview", param.get("overview"));
		
		param.remove("managerList");
		param.remove("overview");

		String url = "/rest/ezPMS/tasks/" + taskId + "/users/" + userId;

		JSONObject resultBody = commonUtil.getJsonFromRestApi(url, param, request, "put", jsonList);
		String status = resultBody.get("status").toString();
		String roleCheck = "";

		if (status.equals("ok")) {
			roleCheck = resultBody.get("data").toString();
		}

		logger.debug("[result] roleCheck : " + roleCheck);
		logger.debug("ezPMS updateTaskInfo ended");

		return roleCheck;
	}

	/**
	 * 업무 상태 수정 화면 호출.
	 * 
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value = "/ezPMS/goUpdateTaskStatus.do")
	public String goTaskStatus(HttpServletRequest request, Model model,
			@CookieValue("loginCookie") String loginCookie) {

		logger.debug("ezPMS goUpdateTaskStatus started");
		logger.debug("ezPMS goUpdateTaskStatus ended");

		return "/ezPMS/pmsTaskStatusUpdate";
	}

	/**
	 * 업무 상태 수정 함수 실행
	 * 
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value = "/ezPMS/updateTaskStatus.do")
	public String updateTaskStatus(HttpServletRequest request, Model model, @RequestBody Map<String, Object> param,
			@CookieValue("loginCookie") String loginCookie) {

		logger.debug("ezPMS updateTaskStatus started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String taskId = (String) param.get("taskId");
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/tasks/" + taskId + "/users/" + userInfo.getId() + "/status", param,
				request, "put", null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			double projectProgress = (double) resultBody.get("projectProgress");
			model.addAttribute("projectProgress", projectProgress);
		}

		logger.debug("ezPMS updateTaskStatus ended");

		return "json";
	}

	/**
	 * 업무 관련 게시물 조회 (관련게시물 탭)
	 * 
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value = "/ezPMS/getBoardListTab.do")
	public String getBoardListTab(HttpServletRequest request, Model model,
			@CookieValue("loginCookie") String loginCookie) {

		logger.debug("ezPMS getBoardListTab started");

		String taskId = request.getParameter("taskId");
		String projectId = request.getParameter("projectId");
		String groupId = request.getParameter("groupId");

		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("taskId", taskId);
		param.put("startRow", 0);
		param.put("limit", 10);
		param.put("groupId", groupId);

		model.addAttribute("projectId", projectId);
		model.addAttribute("groupId", groupId);
		model.addAttribute("taskId", taskId);

		logger.debug("ezPMS getBoardListTab ended");

		return "/ezPMS/pmsBoardListTab";
	}

	/**
	 * 업무 작업이력 조회 (작업이력 탭)
	 * 
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value = "/ezPMS/getTaskLogListTab.do")
	public String getTaskLogListTab(HttpServletRequest request, Model model,
			@CookieValue("loginCookie") String loginCookie) {

		logger.debug("ezPMS getTaskLogListTab started");

		String projectId = request.getParameter("projectId");
		String groupId = request.getParameter("groupId");
		String taskId = request.getParameter("taskId");

		model.addAttribute("projectId", projectId);
		model.addAttribute("groupId", groupId);
		model.addAttribute("taskId", taskId);

		logger.debug("ezPMS getTaskLogListTab ended");

		return "/ezPMS/pmsTaskLogListTab";
	}

	/**
	 * 새 그룹 추가 팝업 호출.
	 * 
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value = "/ezPMS/goAddGroup.do")
	public String goAddGroup(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {

		logger.debug("ezPMS goAddGroup started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		model.addAttribute("userId", userInfo.getId());
		model.addAttribute("userName", userInfo.getDisplayName());

		logger.debug("ezPMS goAddGroup ended");

		return "/ezPMS/pmsAddGroup";
	}

	/**
	 * 그룹 추가 실행
	 * 
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezPMS/addGroup.do")
	public String addGroup(HttpServletRequest request, Model model, @RequestBody Map<String, Object> param,
			@CookieValue("loginCookie") String loginCookie) {

		logger.debug("ezPMS addGroup started");

		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);

			String projectId = (String) param.get("projectId");
			String url = "/rest/ezPMS/groups/" + projectId + "/users/" + userInfo.getId();
			String today = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);

			param.put("createDate", today);
			param.put("userId", userInfo.getId());

			JSONObject jsonList = new JSONObject();
			jsonList.put("managerList", param.get("managerList"));
			jsonList.put("participantList", param.get("participantList"));
			jsonList.put("overview", param.get("overview"));

			param.remove("managerList");
			param.remove("participantList");
			param.remove("overview");

			commonUtil.getJsonFromRestApi(url, param, request, "post", jsonList);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		logger.debug("ezPMS addGroup ended");

		return "json";
	}

	/**
	 * 그룹 삭제 실행
	 * 
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value = "/ezPMS/deleteGroup.do")
	@ResponseBody
	public String deleteGroup(HttpServletRequest request, Model model, @RequestBody Map<String, Object> param,
			@CookieValue("loginCookie") String loginCookie) {

		logger.debug("ezPMS deleteGroup started");

		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			long projectId = Long.parseLong(param.get("projectId").toString());
			long groupId = Long.parseLong(param.get("groupId").toString());
			String userId = userInfo.getId();

			param.put("userId", userId);

			String url = "/rest/ezPMS/projects/" + projectId + "/groups/" + groupId;

			commonUtil.getJsonFromRestApi(url, param, request, "delete", null);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		logger.debug("ezPMS deleteGroup ended");

		return "json";
	}

	/**
	 * 업무 가중치 수정.
	 * 
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value = "/ezPMS/updateTaskWeight.do")
	public String updateTaskWeight(HttpServletRequest request, Model model, @RequestBody Map<String, Object> param,
			@CookieValue("loginCookie") String loginCookie) {

		logger.debug("ezPMS updateTaskWeight started");

		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			String taskId = (String) param.get("taskId");
			String userId = userInfo.getId();

			param.put("userId", userId);

			commonUtil.getJsonFromRestApi("/rest/ezPMS/tasks/" + taskId + "/weight/", param, request, "put", null);

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		logger.debug("ezPMS updateTaskWeight ended");

		return "json";
	}

	/**
	 * 업무 실제진행률 수정.
	 * 
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value = "/ezPMS/updateTaskProgress.do")
	public String updateTaskProgress(HttpServletRequest request, Model model, @RequestBody Map<String, Object> param,
			@CookieValue("loginCookie") String loginCookie) {

		logger.debug("ezPMS updateTaskProgress started");

		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			String taskId = (String) param.get("taskId");
			String userId = userInfo.getId();

			param.put("userId", userId);

			JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/tasks/" + taskId + "/progress/", param, request, "put", null);
			String status = resultBody.get("status").toString();

			if (status.equals("ok")) {
				double projectProgress = (double) resultBody.get("data");
				model.addAttribute("projectProgress", projectProgress);
			}

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		logger.debug("ezPMS updateTaskProgress ended");

		return "json";
	}

	// 임민석 작성
	/**
	 * 게시판 화면 호출 함수
	 * 
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value = "/ezPMS/getBoardMain.do")
	public String getBoardMain(HttpServletRequest request, Model model,
			@CookieValue("loginCookie") String loginCookie) {
		logger.debug("ezPMS getBoardMain started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String projectId = request.getParameter("projectId");
		String userId = userInfo.getId();

		Map<String, Object> param = new HashMap<String, Object>();
		param.put("location", "board");

		String url = "/rest/ezPMS/projects/" + projectId + "/board/folders";
		param.put("userId", userId);

		JSONObject resultBody = commonUtil.getJsonFromRestApi(url, param, request, "get", null);
		String status = resultBody.get("status").toString();

		if (status.equals("ok")) {
			JSONArray treeData = (JSONArray) resultBody.get("data");
			model.addAttribute("data", treeData);
		}

		resultBody = commonUtil.getJsonFromRestApi(
				"/rest/ezPMS/projects/" + projectId + "/users/" + userInfo.getId() + "/role", null, request, "get",
				null);

		if (status.equals("ok")) {
			Long userRole = (Long) resultBody.get("data");
			model.addAttribute("userRole", userRole);
		}

		model.addAttribute("projectId", projectId);

		logger.debug("ezPMS getBoardMain ended");

		return "/ezPMS/pmsBoardMain";
	}

	/**
	 * 게시물 등록 화면 호출 함수
	 * 
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezPMS/goAddBoard.do")
	public String goAddBoard(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie)
			throws Exception {
		logger.debug("ezPMS goAddBoard started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String userId = userInfo.getId();
		String writerName = userInfo.getDisplayName();
		String writerDeptName = userInfo.getDeptName();
		String mode = request.getParameter("mode");
		String projectId = request.getParameter("projectId");
		String folderId = request.getParameter("folderId");

		Map<String, Object> param = new HashMap<String, Object>();

		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/sysParams/" + userId, param, request, "post",
				null);
		String status = resultBody.get("status").toString();

		if (status.equals("ok")) {
			JSONArray configList = (JSONArray) resultBody.get("data");

			for (Object configVO : configList) {
				JSONObject configItem = (JSONObject) configVO;

				if (configItem.get("name").equals("MailAttachLimit")) {
					model.addAttribute("attachLimit", configItem.get("value"));
				}
			}
		}

		param.put("userId", userId);
		param.put("projectId", projectId);
		param.put("folderId", folderId);

		// 폴더 정보 불러오기
		resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/projects/" + projectId + "/board/folders/" + folderId,
				param, request, "get", null);

		if (status.equals("ok")) {
			JSONObject folderDetails = (JSONObject) resultBody.get("data");
			model.addAttribute("folderName", folderDetails.get("text"));
			model.addAttribute("projectName", folderDetails.get("projectName"));
			model.addAttribute("folderId", folderDetails.get("id"));
			logger.debug("folderName : " + folderDetails.get("folderName"));
		}

		if (mode.equals("modify")) { // 게시물을 수정할 때
			String itemId = request.getParameter("itemId");

			param.put("itemId", itemId);

			resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/boards/" + itemId, param, request, "get", null);
			status = resultBody.get("status").toString();

			if (status.equals("ok")) {
				JSONObject board = (JSONObject) resultBody.get("data");
				model.addAttribute("board", board);
				model.addAttribute("writeContent", board.get("writeContent").toString().replaceAll("\'", "&#39;")
						.replaceAll("(\r\n|\r|\n|\n\r)", " "));
				JSONArray fileList = (JSONArray) board.get("fileList");

				if (fileList != null && fileList.size() > 0) {

					for (int i = 0; i < fileList.size(); i++) {
						JSONObject file = (JSONObject) fileList.get(i);
						file.put("pFileName", file.get("fileName"));
						String filePath = file.get("filePath").toString();
						filePath = filePath.substring(filePath.indexOf("{"), filePath.indexOf("}") + 1);
						file.put("pUploadSN", filePath);
						file.put("resultUpload", "true");
						fileList.set(i, file);

						logger.debug("File Name : " + file.get("fileName"));
					}

					model.addAttribute("fileList",
							URLEncoder.encode(fileList.toString(), "UTF-8").replaceAll("\\+", "%20"));
				}
			}
		} else if (mode.equals("reply")) { // 게시물이 답변일때
			String itemId = request.getParameter("itemId");

			param.put("itemId", itemId);

			resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/boards/" + itemId, param, request, "get", null);
			status = resultBody.get("status").toString();

			if (status.equals("ok")) {
				JSONObject board = (JSONObject) resultBody.get("data");
				model.addAttribute("board", board);
				model.addAttribute("writeContent", board.get("writeContent").toString().replaceAll("\'", "&#39;")
						.replaceAll("(\r\n|\r|\n|\n\r)", " "));
			}
		}

		model.addAttribute("writerId", userId);
		model.addAttribute("writerName", writerName);
		model.addAttribute("writerDeptName", writerDeptName);

		Enumeration<String> parameterNames = request.getParameterNames();

		while (parameterNames.hasMoreElements()) {
			String parameterName = parameterNames.nextElement();
			model.addAttribute(parameterName, request.getParameter(parameterName));
		}

		logger.debug("ezPMS goAddBoard ended");

		return "/ezPMS/pmsAddBoard";
	}

	/**
	 * 게시물 등록 실행 함수
	 * 
	 * @param request
	 * @param model
	 * @param jsonParam
	 * @param loginCookie
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezPMS/addBoard.do")
	public String addBoard(HttpServletRequest request, Model model, @RequestBody JSONObject jsonParam,
			@CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("ezPMS addBoard started");
		logger.debug("folderId : " + jsonParam.get("folderId"));

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String today = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
		String mode = (String) jsonParam.get("mode");

		jsonParam.put("userId", userInfo.getId());

		Map<String, Object> param = new HashMap<String, Object>();
		param.put("folderId", jsonParam.get("folderId"));

		JSONObject resultBody = null;

		if (mode.equals("modify")) {
			jsonParam.put("writeUpdateDate", today);
			resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/boards", param, request, "put", jsonParam);
		} else {
			jsonParam.put("writeDate", today);
			jsonParam.put("writerName", userInfo.getDisplayName());
			jsonParam.put("writerName2", userInfo.getDisplayName2());
			jsonParam.put("writerDeptname", userInfo.getDeptName());
			jsonParam.put("writerDeptname2", userInfo.getDeptName2());
			jsonParam.put("writerPosition", userInfo.getTitle());
			jsonParam.put("writerPosition2", userInfo.getTitle2());

			resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/boards", param, request, "post", jsonParam);
		}

		String status = resultBody.get("status").toString();

		if (status.equals("ok")) {
			model.addAttribute("data", mode); // mode(new/modify)에 따라
												// currentPage = 1로 reset할지의 여부를
												// 결정하기 위함
		}

		logger.debug("ezPMS addBoard ended");

		return "json";
	}

	/**
	 * 프로젝트 내 게시물 이동 화면 호출 (트리 포함)
	 * 
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value = "/ezPMS/goMoveBoards.do")
	public String goMoveBoards(HttpServletRequest request, Model model,
			@CookieValue("loginCookie") String loginCookie) {
		logger.debug("ezPMS goMoveBoards started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String projectId = request.getParameter("projectId");

		Map<String, Object> param = new HashMap<String, Object>();
		param.put("location", "folderSetting");
		param.put("userId", userInfo.getId());

		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/projects/" + projectId + "/board/folders",
				param, request, "get", null);
		String status = resultBody.get("status").toString();

		if (status.equals("ok")) {
			JSONArray treeData = (JSONArray) resultBody.get("data");
			model.addAttribute("data", treeData);
		}

		logger.debug("ezPMS goMoveBoards ended");

		return "/ezPMS/pmsMoveBoards";
	}

	/**
	 * 프로젝트 내 게시물 이동 실행 함수
	 * 
	 * @param request
	 * @param model
	 * @param jsonParam
	 * @param loginCookie
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezPMS/moveBoards.do")
	public String moveBoards(HttpServletRequest request, Model model, @RequestBody JSONObject jsonParam,
			@CookieValue("loginCookie") String loginCookie) {
		logger.debug("ezPMS moveBoards started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		Map<String, Object> param = null;
		jsonParam.put("userId", userInfo.getId());
		jsonParam.put("deptId", userInfo.getDeptID());

		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/moveBoards", param, request, "put",
				jsonParam);
		String status = resultBody.get("status").toString();

		if (status.equals("ok")) {
			model.addAttribute("data", "success");
		}

		logger.debug("ezPMS moveBoards ended");

		return "json";
	}

	/**
	 * 게시물 삭제 실행 함수
	 * 
	 * @param request
	 * @param model
	 * @param jsonParam
	 * @param loginCookie
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezPMS/deleteBoard.do")
	public String deleteBoard(HttpServletRequest request, Model model, @RequestBody JSONObject jsonParam,
			@CookieValue("loginCookie") String loginCookie) {
		logger.debug("ezPMS deleteBoard started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		Map<String, Object> param = null;
		jsonParam.put("userId", userInfo.getId());
		jsonParam.put("deptId", userInfo.getDeptID());

		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/boards", param, request, "delete",
				jsonParam);
		String status = resultBody.get("status").toString();

		if (status.equals("ok")) {
			model.addAttribute("data", "success");
		}

		logger.debug("ezPMS deleteBoard ended");

		return "json";
	}

	/**
	 * 업무 트리 화면 호출 함수
	 * 
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezPMS/getTaskSelectionTree.do")
	public String getTaskSelectionTree(HttpServletRequest request, Model model,
			@CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("ezPMS getTaskSelectionTree started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String projectId = request.getParameter("projectId");

		Map<String, Object> param = new HashMap<String, Object>();

		param.put("location", "folderSetting");
		param.put("userId", userInfo.getId());

		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/projects/" + projectId + "/board/folders",
				param, request, "get", null);
		String status = resultBody.get("status").toString();

		if (status.equals("ok")) {
			JSONArray treeData = (JSONArray) resultBody.get("data");
			model.addAttribute("data", treeData);
		}

		logger.debug("ezPMS getTaskSelectionTree ended");

		return "/ezPMS/pmsTaskSelectionTree";
	}

	/**
	 * 게시물 리스트 호출 실행 함수
	 * 
	 * @param request
	 * @param model
	 * @param param
	 * @param loginCookie
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezPMS/getBoardList.do")
	public String getBoardList(HttpServletRequest request, Model model, @RequestBody Map<String, Object> param,
			@CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("ezPMS getBoardList started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		int boardCount = 0;
		int totalCount = 0;
		int listCnt = (int) param.get("limit");
		int countPage = 10;
		int currentPage = (int) param.get("currentPage");
		int projectId = (int) param.get("projectId");

		// 새 글 여부를 판단하기 위해서 하루 이전의 시간을 계산해서 넘김
		String todayStr = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Calendar yesterday = Calendar.getInstance();
		yesterday.setTime(sdf.parse(todayStr));
		yesterday.add(Calendar.DATE, -1);

		// 검색 조건에 지정된 날짜 + 1을 검색 조건으로 재지정(searchByEndDate + 1 0시 이전 글 검색)
		String endDate = (String) param.get("searchByEndDate");

		if (endDate != null) {

			if (!endDate.equals("")) {
				SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd");
				Calendar searchByEndDate = Calendar.getInstance();
				searchByEndDate.setTime(sdf2.parse((String) param.get("searchByEndDate")));
				searchByEndDate.add(Calendar.DATE, 1);
				param.put("searchByEndDate", sdf2.format(searchByEndDate.getTime()));
			}
		}

		model.addAttribute("yesterday", sdf.format(yesterday.getTime()));

		JSONObject resultBody = commonUtil.getJsonFromRestApi(
				"/rest/ezPMS/boards/list-count/" + projectId + "/users/" + userInfo.getId(), param, request, "get",
				null);
		String status = resultBody.get("status").toString();

		if (status.equals("ok")) {
			boardCount = Integer.parseInt((String) resultBody.get("data"));
			totalCount = Integer.parseInt((String) resultBody.get("data2"));
			model.addAttribute("boardCount", boardCount);
			model.addAttribute("totalCount", totalCount);
		}

		ProjectPagination paging = new ProjectPagination(totalCount, listCnt, countPage, currentPage);
		model.addAttribute("paging", paging);

		int startRow = paging.getStartCount() > 0 ? paging.getStartCount() : 0;

		param.put("startRow", startRow);

		resultBody = commonUtil.getJsonFromRestApi(
				"/rest/ezPMS/boards/list/" + projectId + "/users/" + userInfo.getId(), param, request, "get", null);
		status = resultBody.get("status").toString();

		if (status.equals("ok")) {
			JSONArray boardList = (JSONArray) resultBody.get("data");
			String folderName = (String) resultBody.get("folderName");
			model.addAttribute("data", boardList);
			model.addAttribute("folderName", folderName);

			logger.debug("[result] folderName : " + folderName);
		}

		logger.debug("ezPMS getBoardList ended");

		return "/ezPMS/pmsBoardList";
	}

	/**
	 * 게시물 첨부파일 관련 드래그앤드롭 실행 함수
	 * 
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezPMS/dragAndDrop.do")
	public String projectDragAndDrop(HttpServletRequest request, Model model,
			@CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("ezPMS projectDragAndDrop started");

		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String attachFileNameMaxLength = commonUtil.getTenantConfigRest("attachFileNameMaxLength", userInfo.getId(),
				request);

		if (attachFileNameMaxLength.equals("")) {
			attachFileNameMaxLength = "100";
		}

		String mode = "";
		String projectId = "";

		if (request.getParameter("mode") != null && !request.getParameter("mode").equals("")) {
			mode = request.getParameter("mode");
		}

		if (request.getParameter("projectId") != null && !request.getParameter("projectId").equals("")) {
			projectId = request.getParameter("projectId");
		}

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("attachFileNameMaxLength", attachFileNameMaxLength);
		model.addAttribute("mode", mode);
		model.addAttribute("projectId", projectId);
		logger.debug("ezPMS projectDragAndDrop ended");

		return "/ezPMS/pmsDragAndDrop";
	}

	/**
	 * 게시물 첨부파일 업로드 함수
	 * 
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@ResponseBody
	@RequestMapping(value = "/ezPMS/uploadProjectAttach.do", produces = "text/plain; charset=utf-8")
	public String uploadProjectAttach(MultipartHttpServletRequest request, Model model,
			@CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("ezPMS uploadProjectAttach started");

		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);

		String gwServerUrl = config.getProperty("config.projectGWServerURL");
		String url = gwServerUrl + "/rest/ezPMS/attachfiles";

		URI uri = URI.create(url);

		List<MultipartFile> files = request.getFiles("fileToUpload");
		int cnt = files.size();
		int maxSize = 0;
		logger.debug("###files : " + files + ", cnt: " + cnt);

		Long[] fileSize = new Long[cnt];
		String[] resultUpload = new String[cnt];
		String[] sGUID = new String[cnt];
		String[] pUploadSN = new String[cnt];
		maxSize = Integer.parseInt(request.getParameter("maxSize"));
		JSONObject jsonObject = new JSONObject();
		JSONArray jsonArray = new JSONArray();

		String mode = "";
		String projectId = "";

		if (request.getParameter("mode") != null && !request.getParameter("mode").equals("")) {
			mode = request.getParameter("mode");
		}

		if (request.getParameter("projectId") != null && !request.getParameter("projectId").equals("")) {
			projectId = request.getParameter("projectId");
		}

		logger.debug("mode : " + mode + " | projectId : " + projectId);

		for (int i = 0; i < cnt; i++) {
			resultUpload[i] = "false";
			sGUID[i] = UUID.randomUUID().toString();
			pUploadSN[i] = "{" + sGUID[i] + "}";
		}

		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());

		if (StringUtils.isNotEmpty(files.get(0).getOriginalFilename())
				&& StringUtils.isNotBlank(files.get(0).getOriginalFilename()) && cnt > 0) {

			for (int i = 0; i < cnt; i++) {
				JSONObject fileJson = new JSONObject();

				byte[] bytes = files.get(i).getBytes();
				fileSize[i] = files.get(i).getSize();
				String originalFilename = files.get(i).getOriginalFilename();
				fileJson.put("bytes", bytes);
				fileJson.put("fileSize", fileSize[i]);
				fileJson.put("originalFilename", originalFilename);

				jsonArray.add(fileJson);
			}
		}

		jsonObject.put("fileArray", jsonArray);
		jsonObject.put("cnt", cnt);
		jsonObject.put("maxSize", maxSize);
		jsonObject.put("userId", userInfo.getId());

		HttpEntity<JSONObject> entity = new HttpEntity(jsonObject, headers);

		RestTemplate rest = new RestTemplate();

		ResponseEntity<String> result = rest.exchange(uri, HttpMethod.POST, entity, String.class);

		JSONParser jp = new JSONParser();

		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());

		String status = resultBody.get("status").toString();

		Object data = "";

		if (status.equals("ok")) {
			data = resultBody.get("data");
			model.addAttribute("data", data.toString());
		}

		logger.debug("status: " + status);
		logger.debug("uploadProjectAttach ended");

		return data.toString();
	}

	/**
	 * 게시물 업로드된 첨부파일 삭제 함수
	 * 
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "/ezPMS/uploadFileDelete.do")
	public String uploadFileDelete(HttpServletRequest request, Model model,
			@CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("ezPMS uploadFileDelete started");

		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);

		String fileList = request.getParameter("fileList");

		String filePath = "";

		logger.debug("fileList : " + fileList);

		filePath = "tempUploadFile";

		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("filePath", filePath);
		param.put("fileList", fileList);

		String restUrl = "/rest/ezPMS/attachfiles";
		JSONObject resultBody = commonUtil.getJsonFromRestApi(restUrl, param, request, "delete", null);

		String status = resultBody.get("status").toString();

		if (status.equals("ok")) {
			logger.debug("status : " + status);
		}

		logger.debug("ezPMS uploadFileDelete ended");

		return status;
	}

	/**
	 * 게시물 첨부파일 다운로드 함수
	 * 
	 * @param request
	 * @param response
	 * @param loginCookie
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezPMS/downloadFile.do")
	@ResponseBody
	public void downloadFile(HttpServletRequest request, HttpServletResponse response,
			@CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("ezPMS downloadFile started");

		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);

		String filePath = request.getParameter("filePath");
		String fileName = request.getParameter("fileName");

		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("filePath", filePath);

		JSONObject result = commonUtil.getJsonFromRestApi("/rest/ezPMS/attachfiles", param, request, "get", null);

		String status = result.get("status").toString();

		if (status.equals("ok")) {
			JSONObject data = (JSONObject) result.get("data");
			String bytes = (String) data.get("bytes");
			int fileSize = Integer.parseInt((String) data.get("fileSize"));

			String mimetype = "application/octet-stream";
			byte[] tempBytes = Base64.getDecoder().decode(bytes);

			fileName = CommonUtil.getEncodedFileNameForDownload(request.getHeader("User-Agent"), fileName);

			try (InputStream is = new ByteArrayInputStream(tempBytes)) {
				response.setBufferSize(BUFF_SIZE);
				response.setContentType(mimetype);
				response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
				response.setContentLength(fileSize);

				FileCopyUtils.copy(is, response.getOutputStream());

				response.getOutputStream().flush();
				response.getOutputStream().close();
			} catch (Exception e) {
				logger.debug("ezPMS downloadFile error");
			}
		} else if (status.equals("fileNotFound")) {
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html;charset=UTF-8");

			StringBuffer sb = new StringBuffer();
			sb.append("<script type='text/javascript'>");
			sb.append("alert('" + egovMessageSource.getMessage("ezPMS.t202", userInfo.getLocale()) + "');");
			sb.append("history.go(-1);");
			sb.append("</script>");

			response.getWriter().println(sb.toString());
			response.getWriter().close();

		}

		logger.debug("ezPMS downloadFile ended");
	}

	/**
	 * 게시물 읽기 함수 호출
	 * 
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value = "/ezPMS/getBoardDetail.do")
	public String getBoardDetail(HttpServletRequest request, Model model,
			@CookieValue("loginCookie") String loginCookie) {
		logger.debug("ezPMS getBoardDetail started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String projectId = request.getParameter("projectId");
		String itemId = request.getParameter("itemId");
		String userId = userInfo.getId();
		String deptId = userInfo.getDeptID();

		Map<String, Object> param = new HashMap<String, Object>();

		param.put("userId", userId);
		param.put("userName", userInfo.getDisplayName());
		param.put("userName2", userInfo.getDisplayName2());
		param.put("userDeptName", userInfo.getDeptName());
		param.put("userDeptName2", userInfo.getDeptName2());
		param.put("projectId", projectId);
		param.put("deptId", deptId);

		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/boards/" + itemId, param, request, "get",
				null);

		String status = resultBody.get("status").toString();

		if (status.equals("ok")) {
			JSONObject board = (JSONObject) resultBody.get("data");
			model.addAttribute("board", board);
			Long authority = (Long) resultBody.get("authority");
			model.addAttribute("authority", authority);
		}

		model.addAttribute("userId", userId);

		logger.debug("ezPMS getBoardDetail ended");

		return "/ezPMS/pmsBoardDetail";
	}

	/**
	 * 게시물 조회자 정보 호출 함수
	 * 
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value = "/ezPMS/getBoardViewerList.do")
	public String getBoardViewerList(HttpServletRequest request, Model model,
			@CookieValue("loginCookie") String loginCookie) {
		logger.debug("ezPMS getBoardViewerList started");

		int totalCount = 0;
		int currentPage = 1;
		int listCnt = 10;
		int countPage = 10;

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String itemId = request.getParameter("itemId");
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("projectId", request.getParameter("projectId"));

		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/boards/" + itemId + "/viewer-count", param,
				request, "get", null);
		String status = resultBody.get("status").toString();

		if (status.equals("ok")) {
			totalCount = Integer.parseInt((String) resultBody.get("data"));
		}

		logger.debug("totalCount : " + totalCount);

		String currentPageStr = request.getParameter("currentPage");

		if (currentPageStr != null && !currentPageStr.equals("")) {
			currentPage = Integer.parseInt(currentPageStr);
		}

		ProjectPagination paging = new ProjectPagination(totalCount, listCnt, countPage, currentPage);
		model.addAttribute("paging", paging);

		param.put("startRow", paging.getStartCount());
		param.put("limit", listCnt);

		if (totalCount > 0) {
			resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/boards/" + itemId + "/viewers/", param, request,
					"get", null);
			status = resultBody.get("status").toString();

			if (status.equals("ok")) {
				JSONArray viewerList = (JSONArray) resultBody.get("data");
				model.addAttribute("viewerList", viewerList);
			}
		}

		logger.debug("ezPMS getBoardViewerList ended");

		return "/ezPMS/pmsBoardViewerList";
	}

	/**
	 * 게시물 정보 호출 함수
	 * 
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value = "/ezPMS/boardDetailJSON.do")
	public JSONObject getboardJSON(HttpServletRequest request, Model model,
			@CookieValue("loginCookie") String loginCookie) {
		logger.debug("ezPMS getboardJSON started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("projectId", request.getParameter("projectId"));

		String itemId = request.getParameter("itemId");

		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/boards/" + itemId, param, request, "get",
				null);

		String status = resultBody.get("status").toString();

		JSONObject board = null;

		if (status.equals("ok")) {
			board = (JSONObject) resultBody.get("data");
			String boardContent = ((String) board.get("writeContent")).replaceAll("\'", "&#39;")
					.replaceAll("(\r\n|\r|\n|\n\r)", " ");
			board.put("boardContent", boardContent);
		}

		logger.debug("ezPMS getboardJSON ended");

		return board;
	}

	/**
	 * 프로젝트 의견 화면 호출
	 */
	@RequestMapping(value = "/ezPMS/getCommentMain.do")
	public String getCommentMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model) throws Exception {
		logger.debug("ezPMS getCommentMain started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String projectId = request.getParameter("projectId");
		String onlyGroup = request.getParameter("onlyGroup");

		Map<String, Object> param = new HashMap<String, Object>();

		param.put("onlyGroup", onlyGroup);
		param.put("location", "comment");

		JSONObject resultBody = commonUtil.getJsonFromRestApi(
				"/rest/ezPMS/tree/" + projectId + "/users/" + userInfo.getId(), param, request, "get", null);

		String status = resultBody.get("status").toString();

		if (status.equals("ok")) {
			JSONArray treeData = (JSONArray) resultBody.get("data");
			model.addAttribute("data", treeData);
		}

		model.addAttribute("projectId", projectId);

		logger.debug("ezPMS getCommentMain ended");
		return "ezPMS/pmsCommentMain";
	}

	/**
	 * 의견 목록 호출 함수
	 * 
	 * @param request
	 * @param model
	 * @param param
	 * @param loginCookie
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezPMS/getCommentList.do")
	public String getCommentList(HttpServletRequest request, Model model, @RequestBody Map<String, Object> param,
			@CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("ezPMS getCommentList started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		int totalCount = 0;
		int listCnt = (int) param.get("limit");
		int countPage = 10;
		int currentPage = (int) param.get("currentPage");
		String projectId = (String) param.get("projectId");

		// 검색 조건에 지정된 날짜 + 1을 검색 조건으로 재지정(searchByEndDate + 1 0시 이전 글 검색)
		String endDate = (String) param.get("searchByEndDate");

		if (endDate != null) {

			if (!endDate.equals("")) {
				SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd");
				Calendar searchByEndDate = Calendar.getInstance();
				searchByEndDate.setTime(sdf2.parse((String) param.get("searchByEndDate")));
				searchByEndDate.add(Calendar.DATE, 1);
				param.put("searchByEndDate", sdf2.format(searchByEndDate.getTime()));
			}
		}

		JSONObject resultBody = commonUtil.getJsonFromRestApi(
				"/rest/ezPMS/comments/list-count/" + projectId + "/users/" + userInfo.getId(), param, request, "get",
				null);
		String status = resultBody.get("status").toString();

		if (status.equals("ok")) {
			totalCount = Integer.parseInt((String) resultBody.get("data"));
			model.addAttribute("totalCount", totalCount);
		}

		ProjectPagination paging = new ProjectPagination(totalCount, listCnt, countPage, currentPage);
		model.addAttribute("paging", paging);

		int startRow = paging.getStartCount() > 0 ? paging.getStartCount() : 0;
		param.put("startRow", startRow);

		resultBody = commonUtil.getJsonFromRestApi(
				"/rest/ezPMS/comments/list/" + projectId + "/users/" + userInfo.getId(), param, request, "get", null);
		status = resultBody.get("status").toString();

		if (status.equals("ok")) {
			JSONArray commentList = (JSONArray) resultBody.get("data");
			String taskName = (String) resultBody.get("taskName");
			model.addAttribute("data", commentList);
			model.addAttribute("taskName", taskName);
		}

		resultBody = commonUtil.getJsonFromRestApi(
				"/rest/ezPMS/projects/" + projectId + "/users/" + userInfo.getId() + "/role", null, request, "get",
				null);

		if (status.equals("ok")) {
			Long userRole = (Long) resultBody.get("data");
			model.addAttribute("userRole", userRole);
		}

		logger.debug("ezPMS getCommentList ended");

		return "/ezPMS/pmsCommentList";
	}

	/**
	 * 의견 등록 호출 함수
	 * 
	 * @param request
	 * @param model
	 * @param jsonParam
	 * @param loginCookie
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezPMS/addComment.do")
	public String addComment(HttpServletRequest request, Model model, @RequestBody JSONObject jsonParam,
			@CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("ezPMS addComment started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String today = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);

		Map<String, Object> param = null;

		jsonParam.put("updateDate", today);
		jsonParam.put("writerId", userInfo.getId());
		jsonParam.put("writeDate", today);
		jsonParam.put("writerName", userInfo.getDisplayName());
		jsonParam.put("writerName2", userInfo.getDisplayName2());
		jsonParam.put("writerDeptName", userInfo.getDeptName());
		jsonParam.put("writerDeptName2", userInfo.getDeptName2());

		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/comments", param, request, "post",
				jsonParam);
		String status = resultBody.get("status").toString();

		if (status.equals("ok")) {
			model.addAttribute("data", "success"); // mode(new/modify)에 따라
													// currentPage = 1로 reset할지의
													// 여부를 결정하기 위함
		}

		logger.debug("ezPMS addComment ended");

		return "json";
	}

	/**
	 * 의견 삭제 실행 함수
	 * 
	 * @param request
	 * @param model
	 * @param jsonParam
	 * @param loginCookie
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezPMS/deleteComment.do")
	public String deleteComment(HttpServletRequest request, Model model, @RequestBody JSONObject jsonParam,
			@CookieValue("loginCookie") String loginCookie) {
		logger.debug("ezPMS deleteComment started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		Map<String, Object> param = null;
		jsonParam.put("userId", userInfo.getId());
		jsonParam.put("deptId", userInfo.getDeptID());

		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/comments", param, request, "delete",
				jsonParam);
		String status = resultBody.get("status").toString();

		if (status.equals("ok")) {
			model.addAttribute("data", "success");
		}

		logger.debug("ezPMS deleteComment ended");

		return "json";
	}

	/**
	 * 의견 수정 호출 함수
	 * 
	 * @param request
	 * @param model
	 * @param jsonParam
	 * @param loginCookie
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezPMS/modifyComment.do")
	public String modifyComment(HttpServletRequest request, Model model, @RequestBody JSONObject jsonParam,
			@CookieValue("loginCookie") String loginCookie) {
		logger.debug("ezPMS modifyComment started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		Map<String, Object> param = null;
		jsonParam.put("userId", userInfo.getId());
		jsonParam.put("deptId", userInfo.getDeptID());

		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/comments", param, request, "put", jsonParam);
		String status = resultBody.get("status").toString();

		if (status.equals("ok")) {
			model.addAttribute("data", "success");
		}

		logger.debug("ezPMS modifyComment ended");

		return "json";
	}

	/**
	 * 업무/그룹 상세 팝업 내 의견 탭 화면 호출
	 * 
	 * @param loginCookie
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezPMS/getCommentListTab.do")
	public String getCommentListTab(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			Model model) throws Exception {
		logger.debug("ezPMS getCommentListTab started");

		String projectId = request.getParameter("projectId");
		String groupId = request.getParameter("groupId");
		String taskId = request.getParameter("taskId");

		model.addAttribute("projectId", projectId);
		model.addAttribute("groupId", groupId);
		model.addAttribute("taskId", taskId);

		logger.debug("ezPMS getCommentListTab ended");
		return "ezPMS/pmsCommentListTab";
	}

	/**
	 * 선행작업 관련 업무 트리 호출 함수
	 * 
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value = "/ezPMS/goPreTaskSelectionTree.do")
	public String goPreTaskSelectionTree(HttpServletRequest request, Model model,
			@CookieValue("loginCookie") String loginCookie) {
		logger.debug("ezPMS goPreTaskSelectionTree started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String projectId = request.getParameter("projectId");
		String onlyGroup = request.getParameter("onlyGroup");

		Map<String, Object> param = new HashMap<String, Object>();

		param.put("onlyGroup", onlyGroup);
		param.put("location", "");

		JSONObject resultBody = commonUtil.getJsonFromRestApi(
				"/rest/ezPMS/tree/" + projectId + "/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBody.get("status").toString();

		if (status.equals("ok")) {
			JSONArray treeData = (JSONArray) resultBody.get("data");
			model.addAttribute("data", treeData);
		}

		logger.debug("ezPMS goPreTaskSelectionTree ended");
		return "/ezPMS/pmsPreTaskSelectionTree";
	}

	/**
	 * 답변 존재 여부 체크 관련 함수
	 * 
	 * @param request
	 * @param model
	 * @param jsonParam
	 * @param loginCookie
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezPMS/checkIfBoardHasReplies.do")
	public String checkIfBoardHasReplies(HttpServletRequest request, Model model, @RequestBody JSONObject jsonParam,
			@CookieValue("loginCookie") String loginCookie) {
		logger.debug("ezPMS checkIfHasReplies started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		jsonParam.put("userId", userInfo.getId());

		// List<String> itemIds = (List<String>) jsonParam.get("itemIds");
		// logger.debug("itemIds : " + itemIds);

		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/boards/checkIfHasReplies", null, request,
				"post", jsonParam);
		String status = resultBody.get("status").toString();

		if (status.equals("ok")) {
			boolean ifBoardHasReplies = (boolean) resultBody.get("data");
			model.addAttribute("data", ifBoardHasReplies);
		}

		logger.debug("ezPMS checkIfHasReplies ended");
		return "json";
	}

	/**
	 * 선행작업 존재 여부 호출 함수
	 * 
	 * @param request
	 * @param model
	 * @param jsonParam
	 * @param loginCookie
	 * @return
	 */
	// @SuppressWarnings("unchecked")
	// @RequestMapping(value = "/ezPMS/checkIfExistPreTaskRel.do")
	// public String checkIfExistPreTaskRel(HttpServletRequest request, Model
	// model, @RequestBody JSONObject jsonParam, @CookieValue("loginCookie")
	// String loginCookie) {
	// logger.debug("ezPMS checkIfExistPreTaskRel started");
	//
	// LoginVO userInfo = commonUtil.userInfo(loginCookie);
	// jsonParam.put("userId", userInfo.getId());
	//
	// JSONObject resultBody =
	// commonUtil.getJsonFromRestApi("/rest/ezPMS/tasks/checkIfExistPreTaskRel/"
	// + jsonParam.get("pretaskId"), null, request, "post", jsonParam);
	// String status = resultBody.get("status").toString();
	//
	// if(status.equals("ok")) {
	// boolean ifExistPreTaskRel = (boolean) resultBody.get("data");
	// model.addAttribute("data", ifExistPreTaskRel);
	// }
	//
	// logger.debug("ezPMS checkIfExistPreTaskRel ended");
	// return "json";
	// }

	/**
	 * 선행작업 삭제 관련 함수
	 * 
	 * @param request
	 * @param model
	 * @param jsonParam
	 * @param loginCookie
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezPMS/deletePretaskRel.do")
	public String deletePretaskRel(HttpServletRequest request, Model model, @RequestBody JSONObject jsonParam,
			@CookieValue("loginCookie") String loginCookie) {
		logger.debug("ezPMS deletePretaskRel started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		jsonParam.put("userId", userInfo.getId());

		String url = "/rest/ezPMS/tasks/" + jsonParam.get("taskId") + "/preTasks/" + jsonParam.get("pretaskId");
		JSONObject resultBody = commonUtil.getJsonFromRestApi(url, null, request, "delete", jsonParam);
		String status = resultBody.get("status").toString();

		if (status.equals("ok")) {
			model.addAttribute("roleCheck", resultBody.get("data"));
		}

		logger.debug("ezPMS deletePretaskRel ended");
		return "json";
	}

	/**
	 * 간트차트 화면의 모든 정보 업데이트 호출 함수
	 * 
	 * @param request
	 * @param model
	 * @param jsonParam
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value = "/ezPMS/updateAllSchedules.do")
	public String updateAllSchedules(HttpServletRequest request, Model model, @RequestBody JSONObject jsonParam,
			@CookieValue("loginCookie") String loginCookie) {
		logger.debug("ezPMS updateAllSchedules started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String url = "/rest/ezPMS/allSchedules/users/" + userInfo.getId();
		
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(url, null, request, "put", jsonParam);
		String status = resultBody.get("status").toString();

		if (status.equals("ok")) {
			double projectProgress = (double) resultBody.get("data");
			model.addAttribute("projectProgress", projectProgress);
		}

		logger.debug("ezPMS updateAllSchedules ended");
		return "json";
	}

	/**
	 * 간트차트 모든 정보 호출 함수
	 * 
	 * @param request
	 * @param model
	 * @param jsonParam
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value = "/ezPMS/getAllGanttItems.do")
	public String getAllGanttItems(HttpServletRequest request, Model model, @RequestBody JSONObject jsonParam,
			@CookieValue("loginCookie") String loginCookie) {
		logger.debug("ezPMS getAllGanttItems started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String projectId = (String) jsonParam.get("projectId");
		String taskStatus = (String) jsonParam.get("status");

		Map<String, Object> param = new HashMap<String, Object>();
		param.put("position", "gantt");
		param.put("status", taskStatus);

		JSONObject resultBodyTask = commonUtil.getJsonFromRestApi(
				"/rest/ezPMS/task-list/" + projectId + "/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBodyTask.get("status").toString();

		if (status.equals("ok")) {
			JSONObject taskList = (JSONObject) resultBodyTask.get("data");
			model.addAttribute("taskList", taskList.get("taskList"));
			model.addAttribute("userRoleId", taskList.get("userRoleId"));
		}

		JSONObject resultBodyProject = commonUtil.getJsonFromRestApi(
				"/rest/ezPMS/projects/" + projectId + "/users/" + userInfo.getId() + "/gantt", param, request, "get",
				null);
		status = resultBodyProject.get("status").toString();

		if (status.equals("ok")) {
			JSONObject data = (JSONObject) resultBodyProject.get("data");
			model.addAttribute("projectDetails", data.get("project"));
			model.addAttribute("holidayList", data.get("holidayList"));
		}

		JSONObject resultBodyGroup = commonUtil.getJsonFromRestApi(
				"/rest/ezPMS/projects/" + projectId + "/groups/users/" + userInfo.getId() + "/gantt", param, request,
				"get", null);
		status = resultBodyGroup.get("status").toString();

		if (status.equals("ok")) {
			model.addAttribute("groupList", resultBodyGroup.get("data"));
		}

		logger.debug("ezPMS getAllGanttItems ended");
		return "json";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezPMS/sendMail.do")
	@ResponseBody
	public JSONObject mailWrite(HttpServletRequest request, Model model, @RequestBody Map<String, Object> param,
			@CookieValue("loginCookie") String loginCookie) {
		logger.debug("ezPMS mailWrite started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		Long projectId = Long.parseLong(param.get("projectId").toString());
		String roleId = param.get("roleId").toString();
		String type = param.get("type").toString();
		String toUserId = param.get("toUserId").toString();
		String taskId = param.get("taskId").toString();

		JSONObject result = new JSONObject();
		param.put("userId", userId);

		// 프로젝트 정보 불러오기
		String projectUrl = "/rest/ezPMS/projects/" + projectId + "/userId/" + userId;
		JSONObject projectResult = commonUtil.getJsonFromRestApi(projectUrl, null, request, "get", null);
		String projectStatus = projectResult.get("status").toString();

		if (projectStatus.equals("ok")) {
			JSONObject json = (JSONObject) projectResult.get("data");
			JSONObject project = (JSONObject) json.get("project");

			// 프로젝트 정보 호출
			result.put("project", project);
		}

		if (taskId == null || taskId.equals("")) {
			if (type.equals("group")) {
				String url = "/rest/ezPMS/projects/" + projectId + "/roles/" + Integer.parseInt(roleId);
				param.put("isGantt", 1);
				param.put("roleId", roleId);

				JSONObject resultBody = commonUtil.getJsonFromRestApi(url, param, request, "get", null);
				String status = resultBody.get("status").toString();

				if (status.equals("ok")) {
					result.put("list", resultBody.get("data"));
				}
			} else {
				String url = "/rest/ezPMS/users/" + toUserId + "/setting";
				param.put("userIdType", param.get("userIdType"));

				JSONObject resultBody = commonUtil.getJsonFromRestApi(url, param, request, "get", null);
				String status = resultBody.get("status").toString();

				if (status.equals("ok")) {
					result.put("list", resultBody.get("data"));
				}
			}
		} else {
			String url = "/rest/ezPMS/tasks/" + Long.parseLong(taskId) + "/users/" + userId;
			JSONObject resultBody = commonUtil.getJsonFromRestApi(url, param, request, "get", null);
			String status = resultBody.get("status").toString();

			if (status.equals("ok")) {
				JSONObject data = (JSONObject) resultBody.get("data");
				JSONObject taskDetails = (JSONObject) data.get("taskDetails");

				result.put("list", taskDetails.get("taskMember"));
			}
		}

		logger.debug("ezPMS mailWrite ended");
		return result;
	}

	/**
	 * 프로젝트관리 폴더관리 화면 호출 함수
	 * 
	 * @return
	 */
	@RequestMapping(value = "/ezPMS/folderSetting.do")
	public String getFolderSetting(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model) throws Exception {
		logger.debug("ezPMS getFolderSetting started");
		logger.debug("ezPMS getFolderSetting ended");
		return "ezPMS/folderSetting";
	}

	/**
	 * 프로젝트관리 폴더리스트 호출
	 * 
	 * @return
	 */
	@RequestMapping(value = "/ezPMS/getFolderList.do")
	@ResponseBody
	public JSONArray getFolderList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model) throws Exception {
		logger.debug("ezPMS getFolderList started");
		JSONArray data = new JSONArray();
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String userId = userInfo.getId();
		Long projectId = Long.parseLong(request.getParameter("projectId"));

		String url = "/rest/ezPMS/projects/" + projectId + "/board/folders";
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		param.put("location", request.getParameter("location"));

		JSONObject resultBody = commonUtil.getJsonFromRestApi(url, param, request, "get", null);
		String status = resultBody.get("status").toString();

		if (status.equals("ok")) {
			data = (JSONArray) resultBody.get("data");
		}

		logger.debug("ezPMS getFolderList ended");
		return data;
	}

	/**
	 * 프로젝트관리 폴더 삭제 실행
	 * 
	 * @return
	 */
	@RequestMapping(value = "/ezPMS/deleteFolder.do")
	@ResponseBody
	public String deleteFolder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model) throws Exception {
		logger.debug("ezPMS getFolderList started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String userId = userInfo.getId();
		Long projectId = Long.parseLong(request.getParameter("projectId"));
		Long folderId = Long.parseLong(request.getParameter("folderId"));
		String url = "/rest/ezPMS/projects/" + projectId + "/board/folders/" + folderId;

		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);

		String roleCheck = "";

		JSONObject resultBody = commonUtil.getJsonFromRestApi(url, param, request, "delete", null);
		String status = resultBody.get("status").toString();

		if (status.equals("ok")) {
			roleCheck = resultBody.get("data").toString();
		}

		logger.debug("ezPMS getFolderList ended");
		return roleCheck;
	}

	/**
	 * 프로젝트관리 폴더 이름 추가/수정 화면 호출
	 * 
	 * @return
	 */
	@RequestMapping(value = "/ezPMS/inputFolderName.do")
	public String inputFolderName(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model) throws Exception {
		logger.debug("ezPMS inputFolderName started");
		model.addAttribute("mode", request.getParameter("mode"));

		String mode = request.getParameter("mode");

		if (mode.equals("modify")) {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);

			String userId = userInfo.getId();
			Long projectId = Long.parseLong(request.getParameter("projectId"));
			Long folderId = Long.parseLong(request.getParameter("folderId"));
			String url = "/rest/ezPMS/projects/" + projectId + "/board/folders/" + folderId;

			Map<String, Object> param = new HashMap<String, Object>();
			param.put("userId", userId);

			JSONObject resultBody = commonUtil.getJsonFromRestApi(url, param, request, "get", null);
			String status = resultBody.get("status").toString();

			if (status.equals("ok")) {
				model.addAttribute("folderDetails", resultBody.get("data"));
			}
		} else {
			model.addAttribute("folderDetails", "{}");
		}

		logger.debug("ezPMS inputFolderName ended");
		return "ezPMS/pmsSetFolderName";
	}

	/**
	 * 프로젝트관리 폴더 이름 추가/수정 함수 실행
	 * 
	 * @return
	 */
	@RequestMapping(value = "/ezPMS/setFolderName.do")
	@ResponseBody
	public String setFolderName(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model) throws Exception {
		logger.debug("ezPMS setFolderName started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Map<String, Object> param = new HashMap<String, Object>();

		String roleCheck = "";
		String userId = userInfo.getId();
		Long projectId = Long.parseLong(request.getParameter("projectId"));
		String mode = request.getParameter("mode");
		String url = "/rest/ezPMS/projects/" + projectId + "/board/folders";

		param.put("userId", userId);
		param.put("order", request.getParameter("order"));
		param.put("folderName1", request.getParameter("folderName1"));
		param.put("folderName2", request.getParameter("folderName2"));

		if (mode.equals("new")) {
			JSONObject resultBody = commonUtil.getJsonFromRestApi(url, param, request, "post", null);
			String status = resultBody.get("status").toString();

			if (status.equals("ok")) {
				roleCheck = resultBody.get("data").toString();
			}
		} else if (mode.equals("modify")) {
			String modifUrl = url + "/" + Long.parseLong(request.getParameter("folderId"));

			JSONObject resultBody = commonUtil.getJsonFromRestApi(modifUrl, param, request, "put", null);
			String status = resultBody.get("status").toString();

			if (status.equals("ok")) {
				roleCheck = resultBody.get("data").toString();
			}
		}

		logger.debug("ezPMS setFolderName ended");
		return roleCheck;
	}

	@SuppressWarnings({ "unchecked", "static-access" })
	@RequestMapping(value = "/ezPMS/exportGanttExcel.do")
	@ResponseBody
	public void exportGanttExcel(@CookieValue("loginCookie") String loginCookie, HttpServletResponse response,
			HttpServletRequest request) throws Exception {
		logger.debug("ezPMS exportGanttExcel started.");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		Long projectId = Long.parseLong(request.getParameter("projectId"));
		JSONArray taskList = new JSONArray();
		JSONObject project = new JSONObject();
		JSONArray groupList = new JSONArray();
		JSONArray holidayList = new JSONArray();

		logger.debug("projectId : " + projectId);

		// 순서와 레벨 매칭
		String taskId = request.getParameter("taskId");
		String taskLevel = request.getParameter("taskLevel");

		String[] taskIdList = taskId.split(",");
		String[] taskLevelList = taskLevel.split(",");

		List<Map<String, String>> ganttTaskOrder = new ArrayList<Map<String, String>>();

		for (int i = 0; i < taskIdList.length; i++) {
			Map<String, String> taskPair = new HashMap<String, String>();
			taskPair.put("taskId", taskIdList[i]);
			taskPair.put("taskLevel", taskLevelList[i]);

			ganttTaskOrder.add(taskPair);
		}

		Map<String, Object> param = new HashMap<String, Object>();
		param.put("position", "gantt");
		param.put("userId", userId);
		param.put("isMyTask", "A");

		JSONObject resultBodyTask = commonUtil.getJsonFromRestApi(
				"/rest/ezPMS/task-list/" + projectId + "/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBodyTask.get("status").toString();

		if (status.equals("ok")) {
			JSONObject data = (JSONObject) resultBodyTask.get("data");
			taskList = (JSONArray) data.get("taskList");
		}

		JSONObject resultBodyProject = commonUtil.getJsonFromRestApi(
				"/rest/ezPMS/projects/" + projectId + "/users/" + userInfo.getId() + "/gantt", param, request, "get",
				null);
		status = resultBodyProject.get("status").toString();

		if (status.equals("ok")) {
			JSONObject data = (JSONObject) resultBodyProject.get("data");
			project = (JSONObject) data.get("project");
			holidayList = (JSONArray) data.get("holidayList");
		}

		JSONObject resultBodyGroup = commonUtil.getJsonFromRestApi(
				"/rest/ezPMS/projects/" + projectId + "/groups/users/" + userInfo.getId() + "/gantt", param, request,
				"get", null);
		status = resultBodyGroup.get("status").toString();

		if (status.equals("ok")) {
			groupList = (JSONArray) resultBodyGroup.get("data");
		}
		
		//XSSFWorkbook workbook = new XSSFWorkbook();
		XSSFSheet sheet;
		try (XSSFWorkbook workbook = new XSSFWorkbook()) {
	
			// 1행 타이틀 font (bold, 맑은고딕, 크기 12pt)
			XSSFFont titleFont = workbook.createFont();
			titleFont.setBoldweight((short) titleFont.BOLDWEIGHT_BOLD);
			titleFont.setFontHeight((short) 240);
			titleFont.setFontName("맑은 고딕");
	
			// header font (bold, 맑은고딕)
			XSSFFont headerFont = workbook.createFont();
			headerFont.setBoldweight((short) headerFont.BOLDWEIGHT_BOLD);
			headerFont.setFontName("맑은 고딕");
	
			// 기본 font(맑은고딕)
			XSSFFont basicFont = workbook.createFont();
			basicFont.setFontName("맑은 고딕");
			
			//토요일일 경우 font
			XSSFFont satFont = workbook.createFont();
			satFont.setBoldweight((short) satFont.BOLDWEIGHT_BOLD);
			satFont.setFontName("맑은 고딕");
			satFont.setColor(HSSFColor.BLUE.index);
			
			//일요일/공휴일일 경우  font
			XSSFFont sunFont = workbook.createFont();
			sunFont.setBoldweight((short) sunFont.BOLDWEIGHT_BOLD);
			sunFont.setFontName("맑은 고딕");
			sunFont.setColor(HSSFColor.RED.index);
			
			// 헤더 스타일(회색 배경, border 얇은 라인(위아래좌우), 가로세로 텍스트 중앙정렬)
			XSSFCellStyle headerStyle = workbook.createCellStyle();
			headerStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
			headerStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			headerStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			headerStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			headerStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			headerStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			headerStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			headerStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
			headerStyle.setFont(headerFont);
			headerStyle.setWrapText(true);
	
			// 간트쪽 스타일(border 얇은 라인(위아래좌우), 가로세로 텍스트 중앙정렬)
			XSSFCellStyle ganttStyle = workbook.createCellStyle();
			ganttStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			ganttStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			ganttStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			ganttStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			ganttStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			ganttStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
			ganttStyle.setFont(headerFont);
			ganttStyle.setWrapText(true);
			
			// 간트쪽 토요일 스타일(border 얇은 라인(위아래좌우), 가로세로 텍스트 중앙정렬)
			XSSFCellStyle ganttSatStyle = workbook.createCellStyle();
			ganttSatStyle.setFillForegroundColor(HSSFColor.LIGHT_YELLOW.index);
			ganttSatStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			ganttSatStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			ganttSatStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			ganttSatStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			ganttSatStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			ganttSatStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			ganttSatStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
			ganttSatStyle.setFont(satFont);
			ganttSatStyle.setWrapText(true);		
			
			// 간트쪽 일요일 스타일(border 얇은 라인(위아래좌우), 가로세로 텍스트 중앙정렬)
			XSSFCellStyle ganttSunStyle = workbook.createCellStyle();
			ganttSunStyle.setFillForegroundColor(HSSFColor.LIGHT_YELLOW.index);
			ganttSunStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			ganttSunStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			ganttSunStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			ganttSunStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			ganttSunStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			ganttSunStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			ganttSunStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
			ganttSunStyle.setFont(sunFont);
			ganttSunStyle.setWrapText(true);
					
			// 간트 그래프 업무 색칠 o 스타일(border 얇은 라인(위아래좌우), 가로세로 텍스트 중앙정렬)
			XSSFCellStyle graphStyle = workbook.createCellStyle();
			graphStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			graphStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			graphStyle.setBorderRight(HSSFCellStyle.BORDER_NONE);
			graphStyle.setBorderLeft(HSSFCellStyle.BORDER_NONE);
			graphStyle.setFillForegroundColor(IndexedColors.PALE_BLUE.getIndex());
			graphStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			
			// 간트 그래프 프로젝트 색칠 o 스타일(border 얇은 라인(위아래좌우), 가로세로 텍스트 중앙정렬)
			XSSFCellStyle projectGraphStyle = workbook.createCellStyle();
			projectGraphStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			projectGraphStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			projectGraphStyle.setBorderRight(HSSFCellStyle.BORDER_NONE);
			projectGraphStyle.setBorderLeft(HSSFCellStyle.BORDER_NONE);
			projectGraphStyle.setFillForegroundColor(IndexedColors.LIME.getIndex());
			projectGraphStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			
			// 간트 그래프 그룹 색칠 o 스타일(border 얇은 라인(위아래좌우), 가로세로 텍스트 중앙정렬)
			XSSFCellStyle groupGraphStyle = workbook.createCellStyle();
			groupGraphStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			groupGraphStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			groupGraphStyle.setBorderRight(HSSFCellStyle.BORDER_NONE);
			groupGraphStyle.setBorderLeft(HSSFCellStyle.BORDER_NONE);
			groupGraphStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
			groupGraphStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			
			// 간트 그래프 색칠 X 스타일(border 얇은 라인(위아래좌우), 가로세로 텍스트 중앙정렬)
			XSSFCellStyle noGraphStyle = workbook.createCellStyle();
			noGraphStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			noGraphStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			noGraphStyle.setBorderRight(HSSFCellStyle.BORDER_NONE);
			noGraphStyle.setBorderLeft(HSSFCellStyle.BORDER_NONE);
			noGraphStyle.setFillForegroundColor(IndexedColors.WHITE.getIndex());
			noGraphStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
	
			// 작업 이름 border스타일(좌우 라인 없음, 왼쪽정렬)
			XSSFCellStyle taskNameStyle = workbook.createCellStyle();
			taskNameStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			taskNameStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			taskNameStyle.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			taskNameStyle.setFont(basicFont);
	
			// 1행 타이틀 스타일
			XSSFCellStyle titleStyle = workbook.createCellStyle();
			titleStyle.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			titleStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
			titleStyle.setFont(titleFont);
	
			// project 이름 라인 style
			XSSFCellStyle projectStyle = workbook.createCellStyle();
			projectStyle.setFont(headerFont);
			projectStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			projectStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			projectStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			projectStyle.setBorderBottom(HSSFCellStyle.BORDER_DOUBLE);
			projectStyle.setFillForegroundColor(IndexedColors.YELLOW.getIndex());
			projectStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			projectStyle.setAlignment(HSSFCellStyle.ALIGN_LEFT);
	
			// 프로젝트 아래 그룹/업무 라인 style
			XSSFCellStyle upperGroupTaskStyle = workbook.createCellStyle();
			upperGroupTaskStyle.setFont(headerFont);
			upperGroupTaskStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			upperGroupTaskStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			upperGroupTaskStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			upperGroupTaskStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			upperGroupTaskStyle.setFillForegroundColor(IndexedColors.TAN.getIndex());
			upperGroupTaskStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			upperGroupTaskStyle.setAlignment(HSSFCellStyle.ALIGN_LEFT);
	
			// 그룹 아래 그룹/업무 라인 style
			XSSFCellStyle lowerGroupTaskStyle = workbook.createCellStyle();
			lowerGroupTaskStyle.setFont(headerFont);
			lowerGroupTaskStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			lowerGroupTaskStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			lowerGroupTaskStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			lowerGroupTaskStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			lowerGroupTaskStyle.setAlignment(HSSFCellStyle.ALIGN_LEFT);
	
			// 최하위 그룹 아래 업무 stlye
			XSSFCellStyle taskStyle = workbook.createCellStyle();
			taskStyle.setFont(basicFont);
			taskStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			taskStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			taskStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			taskStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			taskStyle.setAlignment(HSSFCellStyle.ALIGN_LEFT);
	
			// 경계라인 style
			XSSFCellStyle delimiterStyle = workbook.createCellStyle();
			delimiterStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			delimiterStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			delimiterStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			delimiterStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			delimiterStyle.setFillForegroundColor(IndexedColors.LIGHT_GREEN.getIndex());
			delimiterStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
	
			Row row;
	
			sheet = workbook.createSheet("report");
			row = sheet.createRow(0);
			String fileName = project.get("projectName").toString() + "_gantt";
			
			String[] invalidName = {"\\\\","/",":","[*]","[?]","\"","<",">","[|]"}; // 윈도우 파일명으로 사용할 수 없는 문자
			
			for(int i = 0;i < invalidName.length; i++) { 
				fileName = fileName.replaceAll(invalidName[i], "_"); //언더바로 치환
			}
			
			String browser = "";
			String header = request.getHeader("User-Agent"); 
			
			if (header.indexOf("MSIE") > -1) { 
				browser = "MSIE"; 
			} else if (header.indexOf("Chrome") > -1) { 
				browser = "Chrome"; 
			} else if (header.indexOf("Opera") > -1) { 
				browser = "Opera"; 
			} else if (header.indexOf("Trident/7.0") > -1) { 
				//IE 11 이상 
				//IE 버전 별 체크 >> Trident/6.0(IE 10) , Trident/5.0(IE 9) , Trident/4.0(IE 8)
				browser = "MSIE"; 
			} else if (header.indexOf("Trident/6.0") > -1) { 
				//IE 11 이상 
				//IE 버전 별 체크 >> Trident/6.0(IE 10) , Trident/5.0(IE 9) , Trident/4.0(IE 8)
				browser = "MSIE"; 
			} else {
				browser = "Firefox";
			}
	
			String encodedFileName = "";
			
			if (browser.equals("MSIE")) { 
				encodedFileName = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20"); 
			} else if (browser.equals("Firefox")) { 
				encodedFileName = new String(fileName.getBytes("UTF-8"), "8859_1");
			} else if (browser.equals("Opera")) {
				encodedFileName = new String(fileName.getBytes("UTF-8"), "8859_1"); 
			} else if (browser.equals("Chrome")) { 
				StringBuffer sb = new StringBuffer(); 
				
				for (int i = 0; i < fileName.length(); i++) { 
					char c = fileName.charAt(i); 
					
					if (c > '~') { 
						sb.append(URLEncoder.encode("" + c, "UTF-8")); 
					
					} else { 
						sb.append(c); 
					} 
				} 
				
				encodedFileName = sb.toString(); 
			} else { 
				encodedFileName = URLEncoder.encode(project.get("projectName").toString() + "_gantt", "UTF-8").replaceAll("\\+", "%20"); 
			}
	
			// 프로젝트 제목
			row.createCell(0).setCellValue(project.get("projectName").toString());
			row.getCell(0).setCellStyle(titleStyle);
			row.setHeight((short) 512);
	
			// 기준일, 간트차트 시작 주수 등 들어감
			row = sheet.createRow(1);
			// 빈 행
			row = sheet.createRow(2);
	
			// 셀병합
			sheet.addMergedRegion(new CellRangeAddress(3, 4, 0, 0));
			sheet.addMergedRegion(new CellRangeAddress(3, 4, 1, 5));
			sheet.addMergedRegion(new CellRangeAddress(3, 4, 6, 6));
			sheet.addMergedRegion(new CellRangeAddress(3, 3, 7, 8));
			sheet.addMergedRegion(new CellRangeAddress(3, 4, 9, 9));
			sheet.addMergedRegion(new CellRangeAddress(3, 4, 10, 10));
			sheet.addMergedRegion(new CellRangeAddress(3, 4, 11, 11));
			sheet.addMergedRegion(new CellRangeAddress(3, 3, 12, 13));
			sheet.addMergedRegion(new CellRangeAddress(3, 4, 14, 14));
			sheet.addMergedRegion(new CellRangeAddress(3, 4, 15, 15));
			sheet.addMergedRegion(new CellRangeAddress(3, 4, 16, 16));
			sheet.addMergedRegion(new CellRangeAddress(3, 4, 17, 17));
	
			// 열/행 고정
			sheet.createFreezePane(19, 6);
			
			// 간트 헤더 - 4번째 줄
			row = sheet.createRow(3);
			row.createCell(0).setCellValue("WBS");// numbering
			row.getCell(0).setCellStyle(headerStyle);
			row.createCell(1).setCellValue(egovMessageSource.getMessage("ezPMS.t98", userInfo.getLocale()));// 업무명
			row.getCell(1).setCellStyle(headerStyle);
			row.createCell(2).setCellStyle(headerStyle);
			row.createCell(3).setCellStyle(headerStyle);
			row.createCell(4).setCellStyle(headerStyle);
			row.createCell(5).setCellStyle(headerStyle);
			row.createCell(6).setCellValue(egovMessageSource.getMessage("ezPMS.t353", userInfo.getLocale()));// 업무 상태
			row.getCell(6).setCellStyle(headerStyle);
			row.createCell(7).setCellValue(egovMessageSource.getMessage("ezPMS.t354", userInfo.getLocale()));// 실시 일자
			row.getCell(7).setCellStyle(headerStyle);
			row.createCell(8).setCellStyle(headerStyle);
			row.createCell(9).setCellValue(egovMessageSource.getMessage("ezPMS.t355", userInfo.getLocale()));// 실제 시작일과 종료일 기간
			
			row.getCell(9).setCellStyle(headerStyle);
			row.createCell(10).setCellValue(egovMessageSource.getMessage("ezPMS.t356", userInfo.getLocale()));// 실제 진행률
			row.getCell(10).setCellStyle(headerStyle);
			row.createCell(11).setCellValue(egovMessageSource.getMessage("ezPMS.t357", userInfo.getLocale()));// 목표진행률 - 실제 진행률
			row.getCell(11).setCellStyle(headerStyle);
			row.createCell(12).setCellValue(egovMessageSource.getMessage("ezPMS.t358", userInfo.getLocale()));
			row.getCell(12).setCellStyle(headerStyle);
			row.createCell(13).setCellStyle(headerStyle);
			row.createCell(14).setCellValue(egovMessageSource.getMessage("ezPMS.t267", userInfo.getLocale()) + "\n(%)");
			row.getCell(14).setCellStyle(headerStyle);
			row.createCell(15).setCellValue(egovMessageSource.getMessage("ezPMS.t359", userInfo.getLocale()));
			row.getCell(15).setCellStyle(headerStyle);
			row.createCell(16).setCellValue(egovMessageSource.getMessage("ezPMS.t63", userInfo.getLocale()));
			row.getCell(16).setCellStyle(headerStyle);
			row.createCell(17).setCellValue(egovMessageSource.getMessage("ezPMS.t360", userInfo.getLocale()));
			row.getCell(17).setCellStyle(headerStyle);
			row.createCell(18).setCellValue(egovMessageSource.getMessage("ezPMS.t361", userInfo.getLocale()));
			row.getCell(18).setCellStyle(headerStyle);
	
			// 간트차트 프로젝트 개월수 및 각 달의 일 수 구하기
	
			String pPlanStartDateStr = project.get("planStartDate").toString().replaceAll("-", "");
			String pPlanEndDateStr = project.get("planEndDate").toString().replaceAll("-", "");
	
			int sYear = Integer.parseInt(pPlanStartDateStr.substring(0, 4));
			int sMonth = Integer.parseInt(pPlanStartDateStr.substring(4, 6));
			int eYear = Integer.parseInt(pPlanEndDateStr.substring(0, 4));
			int eMonth = Integer.parseInt(pPlanEndDateStr.substring(4, 6));
	
			int month_diff = (eYear - sYear) * 12 + (eMonth - sMonth);
	
			List<Map<String, Object>> monthDays = new ArrayList<Map<String, Object>>();
	
			for (int i = 0; i < month_diff + 1; i++) {
				Map<String, Object> months = new HashMap<String, Object>();
				String yearAndMonth = sYear + " / " + sMonth;
	
				Calendar cal = Calendar.getInstance();
				cal.set(sYear, sMonth - 1, 1);
	
				int maxDaysOfMonth = cal.getActualMaximum(Calendar.DATE);
	
				months.put("yearAndMonth", yearAndMonth);
				months.put("maxDaysOfMonth", maxDaysOfMonth);
				monthDays.add(months);
	
				if (sMonth != 12) {
					sMonth++;
				} else {
					sMonth = 1;
					sYear++;
				}
			}
	
			// 간트차트 셀 병합
			int cellCount = 19;
			int chartTotalDays = 0;
	
			for (int i = 0; i < monthDays.size(); i++) {
				int maxDays = Integer.parseInt(monthDays.get(i).get("maxDaysOfMonth").toString());
				sheet.addMergedRegion(new CellRangeAddress(3, 3, cellCount, cellCount + maxDays - 1));
				row.createCell(cellCount).setCellValue(monthDays.get(i).get("yearAndMonth").toString());
				row.getCell(cellCount).setCellStyle(ganttStyle);
	
				chartTotalDays = chartTotalDays + maxDays;
	
				for (int j = 0; j < maxDays - 1; j++) {
					row.createCell(cellCount + 1 + j).setCellStyle(ganttStyle);
				}
	
				cellCount = cellCount + maxDays;
			}
	
			// 간트 헤더 - 5번째 줄
			row = sheet.createRow(4);
			row.createCell(0).setCellStyle(headerStyle);
			row.createCell(1).setCellStyle(headerStyle);
			row.createCell(2).setCellStyle(headerStyle);
			row.createCell(3).setCellStyle(headerStyle);
			row.createCell(4).setCellStyle(headerStyle);
			row.createCell(5).setCellStyle(headerStyle);
			row.createCell(6).setCellStyle(headerStyle);
			row.createCell(7).setCellValue(egovMessageSource.getMessage("ezPMS.t61", userInfo.getLocale()));// 실시 일자
			row.getCell(7).setCellStyle(headerStyle);
			row.createCell(8).setCellValue(egovMessageSource.getMessage("ezPMS.t62", userInfo.getLocale()));// 실시 일자
			row.getCell(8).setCellStyle(headerStyle);
			row.createCell(9).setCellStyle(headerStyle);
			row.createCell(10).setCellStyle(headerStyle);
			row.createCell(11).setCellStyle(headerStyle);
			row.createCell(12).setCellValue(egovMessageSource.getMessage("ezPMS.t61", userInfo.getLocale()));// 목표진행률 - 실제 진행률
			row.getCell(12).setCellStyle(headerStyle);
			row.createCell(13).setCellValue(egovMessageSource.getMessage("ezPMS.t62", userInfo.getLocale()));
			row.getCell(13).setCellStyle(headerStyle);
			row.createCell(14).setCellStyle(headerStyle);
			row.createCell(15).setCellStyle(headerStyle);
			row.createCell(16).setCellStyle(headerStyle);
			row.createCell(17).setCellStyle(headerStyle);
			row.createCell(18).setCellValue(egovMessageSource.getMessage("ezPMS.t362", userInfo.getLocale()));
			row.getCell(18).setCellStyle(headerStyle);
	
			// 간트차트 날짜 넣기
			int dateCount = 19;
	
			for (int i = 0; i < monthDays.size(); i++) {
				int maxDays = Integer.parseInt(monthDays.get(i).get("maxDaysOfMonth").toString());
				String yearAndMonth = monthDays.get(i).get("yearAndMonth").toString();
				
				int year = Integer.parseInt(yearAndMonth.substring(0, 4));
				int month = Integer.parseInt(yearAndMonth.substring(7));
				
				for (int j = 0; j < maxDays; j++) {
					row.createCell(dateCount + j).setCellValue(j + 1);
					row.getCell(dateCount + j).setCellStyle(ganttStyle);
					String comDateStr = year + "-";
					
					if (month < 10) {
						comDateStr += "0" + month + "-";
					} else {
						comDateStr += month + "-";
					}
					
					if (j + 1 < 10) {
						comDateStr += "0" + (j + 1);
					} else {
						comDateStr += (j + 1);
					}
					
					Date compDate = new SimpleDateFormat("yyyy-MM-dd").parse(comDateStr);
					
					Calendar compCal = Calendar.getInstance();
					compCal.setTime(compDate);
					
					int weekDay = compCal.get(Calendar.DAY_OF_WEEK);
					
					if (weekDay == 7) {
						row.getCell(dateCount + j).setCellStyle(ganttSatStyle);
					} else if (weekDay == 1) {
						row.getCell(dateCount + j).setCellStyle(ganttSunStyle);
					} else {
						for (int k = 0; k < holidayList.size(); k ++) {
							String holiday = holidayList.get(k).toString();
							
							if (holiday.equals(comDateStr)) {
								row.getCell(dateCount + j).setCellStyle(ganttSunStyle);
							}
						}
					}
					
					
					sheet.setColumnWidth(dateCount + j, 1000);
				}
	
				dateCount = dateCount + maxDays;
			}
	
			// body(정보)
			// 프로젝트 정보
			row = sheet.createRow(5);
			row.createCell(0).setCellValue("*");// numbering
			row.getCell(0).setCellStyle(projectStyle);
			row.createCell(1).setCellValue(project.get("projectName").toString());// numbering
			row.getCell(1).setCellStyle(projectStyle);
			row.createCell(2).setCellStyle(projectStyle);
			row.createCell(3).setCellStyle(projectStyle);
			row.createCell(4).setCellStyle(projectStyle);
			row.createCell(5).setCellStyle(projectStyle);
			row.createCell(6).setCellStyle(projectStyle);
	
			if (project.get("realStartDate") != null && !project.get("realStartDate").equals("")) {
				String pRealStartDate = project.get("realStartDate").toString();
				row.createCell(7).setCellValue(pRealStartDate);// 수행 시작일
			} else {
				row.createCell(7).setCellValue("");// 프로젝트가 시작 안한경우
			}
	
			row.getCell(7).setCellStyle(projectStyle);
	
			if (project.get("realEndDate") != null && !project.get("realEndDate").equals("")) {
				String pRealEndDate = project.get("realEndDate").toString();
				row.createCell(8).setCellValue(pRealEndDate);// 수행 종료일
			} else {
				row.createCell(8).setCellValue("");
			}
			row.getCell(8).setCellStyle(projectStyle);
	
			row.createCell(9).setCellValue(0);// 실시 일수
			row.getCell(9).setCellStyle(projectStyle);
	
			float pProgress = Float.parseFloat(project.get("progress").toString());
			row.createCell(10).setCellValue((Math.round(pProgress * 10) / 10.0) + "%");// 진척률
			row.getCell(10).setCellStyle(projectStyle);
			
			float pLatePercent = 0.0f;
			
			for (int i = 0; i < taskList.size(); i ++) {
				JSONObject lateContent = (JSONObject) taskList.get(i);
				
				if (lateContent.get("status").equals("L")) {
					pLatePercent += (100 - Float.parseFloat(lateContent.get("realProgress").toString())) 
							*  (Float.parseFloat(lateContent.get("weight").toString()) / 100.00);
				}
			}
			
			row.createCell(11).setCellValue((Math.round(pLatePercent * 10) / 10.0) + "%");// 지연율
			row.getCell(11).setCellStyle(projectStyle);
			row.createCell(12).setCellValue(project.get("planStartDate").toString());// 계획
																						// 종료일
			row.getCell(12).setCellStyle(projectStyle);
			row.createCell(13).setCellValue(project.get("planEndDate").toString());// 계획
																					// 시작일
			row.getCell(13).setCellStyle(projectStyle);
			row.createCell(14).setCellValue(100 + "%");// 가중치
			row.getCell(14).setCellStyle(projectStyle);
	
			// working day
			float pWorkingday = Float.parseFloat(project.get("workingday").toString());
			row.createCell(15).setCellValue(Math.floor(pWorkingday));// 계획 일수
			row.getCell(15).setCellStyle(projectStyle);
			
			String pName = project.get("headManagerName").toString();
			JSONArray pProjectMemberList = (JSONArray) project.get("projectMember");
			int pCount = pProjectMemberList.size() - 1;
			
			if (pCount == 0) {
				row.createCell(16).setCellValue(pName);// 담당자
			} else {
				row.createCell(16).setCellValue(egovMessageSource.getMessageExtend("ezPMS.t349", new Object[] {pName, pCount}, userInfo.getLocale()) );// 담당자
			}
			
			row.getCell(16).setCellStyle(projectStyle);
			row.createCell(17).setCellValue("");// 산출물
			row.getCell(17).setCellStyle(projectStyle);
			row.createCell(18).setCellValue(taskList.size());// 업무 수
			row.getCell(18).setCellStyle(projectStyle);
	
			// 프로젝트 기간에 그래프 색칠
			Date pPlanStartDate = new SimpleDateFormat("yyyyMMdd").parse(pPlanStartDateStr);
			Date pPlanEndDate = new SimpleDateFormat("yyyyMMdd").parse(pPlanEndDateStr);
			String monthStartStr = pPlanStartDateStr.substring(0, 6) + "01";
			Date monthStartDate = new SimpleDateFormat("yyyyMMdd").parse(monthStartStr);
	
			// 프로젝트 시작일 - 해당 월의 1일 차이만큼 띄우고 프로젝트 종료일 차이까지 색칠 (그 외는
			// noGraphStyle적용)//프로젝트 시작일 - 해당 월의 1일 차이만큼 띄우고 프로젝트 종료일 차이까지 색칠 (그 외는
			// noGraphStyle적용)
			long monthStartDiff = (pPlanStartDate.getTime() - monthStartDate.getTime()) / (24 * 60 * 60 * 1000);
	
			// 두 날짜 차이
			long pDateDiff = (pPlanEndDate.getTime() - pPlanStartDate.getTime()) / (24 * 60 * 60 * 1000);
			// 시작일 해당 월의 1일 부터 종료일 해당 월의 마지막 날까지 일 수 (chartTotalDays)
	
			int startCell = 19;
	
			for (int i = 0; i < chartTotalDays; i++) {
				if (i < monthStartDiff) {
					// 시작일 부터 처음
					row.createCell(startCell + i).setCellStyle(noGraphStyle);
				} else if (i >= monthStartDiff && i <= monthStartDiff + pDateDiff) {
					row.createCell(startCell + i).setCellStyle(projectGraphStyle);
					// ganttStyle.setFillPattern(HSSFCellStyle.NO_FILL);
				} else {
					// 색칠이 끝나고 난 다음 부터 끝까지
					row.createCell(startCell + i).setCellStyle(noGraphStyle);
				}
			}
	
			////////// group, task정보
			int upperGroupTask = 0;
			int lowerGroupTask = 0;
			int lowestTask = 0;
	
			// 하위 업무 개수
			int taskCount = 0;
			
			// task와 group정보
			for (int i = 1; i < ganttTaskOrder.size(); i++) {
				row = sheet.createRow(5 + i);
	
				// 업무/그룹 구분
				String ganttTaskId = ganttTaskOrder.get(i).get("taskId");
				ganttTaskId = ganttTaskId.substring(ganttTaskId.lastIndexOf("_") + 1);
				int workingday = 0;
				JSONObject content = new JSONObject();
				String contMemberName = "";
				String taskOrGroup = "";
				// 지연율
				float latePercent = 0;
				int realWorkingday = 0;
				
				if (ganttTaskId.contains("t")) {
					taskOrGroup = "task";
					
					for (int j = 0; j < taskList.size(); j++) {
						content = (JSONObject) taskList.get(j);
						String contentTaskId = content.get("taskId").toString();
						String compTaskId = ganttTaskId.substring(1);
						
						if (contentTaskId.equals(compTaskId)) {
							float workingdayFloat = Float.parseFloat(content.get("realWorkingday").toString());
							workingday = Math.round(workingdayFloat);
							taskCount = 1;
							JSONArray taskMemberList = (JSONArray) content.get("taskMember");
							JSONObject taskMember = (JSONObject) taskMemberList.get(0);
							int taskMemberCount = taskMemberList.size() - 1;
							
							if (taskMemberCount != 0) {
								contMemberName = egovMessageSource.getMessageExtend("ezPMS.t349", new Object[] {taskMember.get("userName").toString(), taskMemberCount}, userInfo.getLocale());// 담당자
							} else {
								contMemberName = taskMember.get("userName").toString();
							}
							
							if (content.get("status").equals("L")) {
								latePercent = 100 - Float.parseFloat(content.get("realProgress").toString());	
							}
							
							realWorkingday = Integer.parseInt(content.get("realStartEndDiff").toString());
							break;
						}
					}
				} else if (ganttTaskId.contains("g")) {	
					taskOrGroup = "group";
					
					for (int j = 0; j < groupList.size(); j++) {
						content = (JSONObject) groupList.get(j);
	
						String contentGroupId = content.get("groupId").toString();
						String compGroupId = ganttTaskId.substring(1);
						
						if (contentGroupId.equals(compGroupId)) {
							float workingdayFloat = Float.parseFloat(content.get("workingday").toString());
							workingday = Math.round(workingdayFloat);
							taskCount = Integer.parseInt(content.get("taskCount").toString());
	
							JSONArray groupMemberList = (JSONArray) content.get("groupMember");
							JSONObject groupMember = new JSONObject();
							
							if (groupMemberList.size() != 0 ) {
								groupMember = (JSONObject) groupMemberList.get(0);
								
								int groupMemberCount = groupMemberList.size() - 1;
								
								if (groupMemberCount != 0) {
									contMemberName = egovMessageSource.getMessageExtend("ezPMS.t349", new Object[] {groupMember.get("userName").toString(), groupMemberCount}, userInfo.getLocale());// 담당자
								} else {
									contMemberName = groupMember.get("userName").toString();
								}
								
							} else {
								groupMember = null;
								contMemberName = "";
							}
							
							latePercent = Float.parseFloat(content.get("latePercent").toString());
							realWorkingday = Integer.parseInt(content.get("realStartEndDiff").toString());
							
							content.put("status", "");
							break;
						}
					}
				}
	
				if (ganttTaskOrder.get(i).get("taskLevel").equals("1")) {
					upperGroupTask++;
					lowerGroupTask = 0;
					lowestTask = 0;
	
					// numbering
					row.createCell(0).setCellValue(upperGroupTask);
					row.getCell(0).setCellStyle(upperGroupTaskStyle);
	
					// 이름
					if (content.get("taskId") == null) {
						row.createCell(1).setCellValue("■ " + content.get("groupName").toString());
					} else {
						row.createCell(1).setCellValue("■ " + content.get("taskName").toString());
					}
	
					row.getCell(1).setCellStyle(upperGroupTaskStyle);
					row.createCell(2).setCellStyle(upperGroupTaskStyle);
					row.createCell(3).setCellStyle(upperGroupTaskStyle);
					row.createCell(4).setCellStyle(upperGroupTaskStyle);
					row.createCell(5).setCellStyle(upperGroupTaskStyle);
				} else if (ganttTaskOrder.get(i).get("taskLevel").equals("2")) {
					lowerGroupTask++;
					lowestTask = 0;
	
					// numbering
					row.createCell(0).setCellValue(upperGroupTask + "." + lowerGroupTask);// numbering
					row.getCell(0).setCellStyle(lowerGroupTaskStyle);
	
					row.createCell(1).setCellStyle(lowerGroupTaskStyle);
	
					// 이름
					if (content.get("taskId") == null) {
						row.createCell(2).setCellValue(content.get("groupName").toString());
					} else {
						row.createCell(2).setCellValue(content.get("taskName").toString());
					}
	
					row.getCell(2).setCellStyle(lowerGroupTaskStyle);
					row.createCell(3).setCellStyle(lowerGroupTaskStyle);
					row.createCell(4).setCellStyle(lowerGroupTaskStyle);
					row.createCell(5).setCellStyle(lowerGroupTaskStyle);
				} else if (ganttTaskOrder.get(i).get("taskLevel").equals("3")) {
					lowestTask++;
	
					// numbering
					row.createCell(0).setCellValue(upperGroupTask + "." + lowerGroupTask + "." + lowestTask);// numbering
					row.getCell(0).setCellStyle(taskStyle);
	
					row.createCell(1).setCellStyle(taskStyle);
					row.createCell(2).setCellStyle(taskStyle);
	
					// 이름
					if (content.get("taskId") == null) {
						row.createCell(3).setCellValue(content.get("groupName").toString());
					} else {
						row.createCell(3).setCellValue(content.get("taskName").toString());
					}
	
					row.createCell(4).setCellStyle(taskStyle);
					row.createCell(5).setCellStyle(taskStyle);
				}
	
				// 작업 구분
				String statusStr = content.get("status").toString();
	
				if (statusStr != null && !statusStr.equals("")) {
					switch (statusStr) {
					case "L":
						statusStr = egovMessageSource.getMessage("ezPMS.t18", userInfo.getLocale());
						break;
					case "W":
						statusStr = egovMessageSource.getMessage("ezPMS.t16", userInfo.getLocale());
						break;
					case "P":
						statusStr = egovMessageSource.getMessage("ezPMS.t15", userInfo.getLocale());
						break;
					case "C":
						statusStr = egovMessageSource.getMessage("ezPMS.t17", userInfo.getLocale());
						break;
					case "S":
						statusStr = egovMessageSource.getMessage("ezPMS.t19", userInfo.getLocale());
						break;
					}
				}
	
				row.createCell(6).setCellValue(statusStr);
				String realStartDate = "";
				String realEndDate = "";
	
				if (content.get("realStartDate") != null) {
					realStartDate = content.get("realStartDate").toString();
				}
	
				if (content.get("realEndDate") != null) {
					realEndDate = content.get("realEndDate").toString();
				}
	
				row.createCell(7).setCellValue(realStartDate);
				row.createCell(8).setCellValue(realEndDate);
				
				if (realWorkingday == 0) {
					row.createCell(9).setCellValue("");
				} else {
					row.createCell(9).setCellValue(realWorkingday);
				}
	
				float contProgress = Float.parseFloat(content.get("realProgress").toString());
				row.createCell(10).setCellValue((Math.round(contProgress * 10) / 10.0) + "%");
				row.createCell(11).setCellValue((Math.round(latePercent * 10) / 10.0) + "%"); // 지연율
				row.createCell(12).setCellValue(content.get("planStartDate").toString());
				row.createCell(13).setCellValue(content.get("planEndDate").toString());
	
				float contWeight = Float.parseFloat(content.get("weight").toString());
				row.createCell(14).setCellValue((Math.round(contWeight * 10) / 10.0) + "%");
				row.createCell(15).setCellValue(workingday);
	
				row.createCell(16).setCellValue(contMemberName);
				row.createCell(17).setCellValue("");
				row.createCell(18).setCellValue(taskCount);
	
				for (int j = 5; j < 19; j++) {
					if (ganttTaskOrder.get(i).get("taskLevel").equals("1")) {
						row.getCell(j).setCellStyle(upperGroupTaskStyle);
					} else if (ganttTaskOrder.get(i).get("taskLevel").equals("2")) {
						row.getCell(j).setCellStyle(lowerGroupTaskStyle);
					} else {
						row.getCell(j).setCellStyle(taskStyle);
					}
				}
	
				// 업무/그룹 기간에 그래프 색칠
				Date contPlanEndDate = new SimpleDateFormat("yyyy-MM-dd").parse(content.get("planEndDate").toString());
				Date contPlanStartDate = new SimpleDateFormat("yyyy-MM-dd").parse(content.get("planStartDate").toString());
			
				long contStartDiff = (contPlanStartDate.getTime() - monthStartDate.getTime()) / (24 * 60 * 60 * 1000);
	
				// 두 날짜 차이
				long contDateDiff = (contPlanEndDate.getTime() - contPlanStartDate.getTime()) / (24 * 60 * 60 * 1000);
				// 시작일 해당 월의 1일 부터 종료일 해당 월의 마지막 날까지 일 수 (chartTotalDays)
	
				for (int j = 0; j < chartTotalDays; j++) {
					if (j < contStartDiff) {
						// 시작일 부터 처음
						row.createCell(startCell + j).setCellStyle(noGraphStyle);
					} else if (j >= contStartDiff && j <= contStartDiff + contDateDiff) {
						if (taskOrGroup.equals("task")) {
							row.createCell(startCell + j).setCellStyle(graphStyle);
						} else if (taskOrGroup.equals("group")) {
							row.createCell(startCell + j).setCellStyle(groupGraphStyle);
						}
						
						// ganttStyle.setFillPattern(HSSFCellStyle.NO_FILL);
					} else {
						// 색칠이 끝나고 난 다음 부터 끝까지
						row.createCell(startCell + j).setCellStyle(noGraphStyle);
					}
				}
			}
	
			// 열 너비 설정
			sheet.setColumnWidth(0, 2000);
			sheet.setColumnWidth(1, 340);
			sheet.setColumnWidth(2, 340);
			sheet.setColumnWidth(3, 340);
			sheet.setColumnWidth(4, 340);
			sheet.setColumnWidth(5, 8000);
			sheet.setColumnWidth(6, 1300);
			sheet.setColumnWidth(7, 4000);
			sheet.setColumnWidth(8, 4000);
			sheet.setColumnWidth(9, 50);
			sheet.setColumnWidth(10, 2000);
			sheet.setColumnWidth(11, 2000);
			sheet.setColumnWidth(12, 4000);
			sheet.setColumnWidth(13, 4000);
			sheet.setColumnWidth(14, 50);
			sheet.setColumnWidth(15, 1500);
			sheet.setColumnWidth(16, 4000);
			sheet.setColumnWidth(17, 8000);
			sheet.setColumnWidth(18, 2000);
			
			response.setContentType("application/vnd.ms-excel");
			response.setHeader("Content-Disposition", "attachment; fileName=\"" + encodedFileName + ".xlsx\"");
			workbook.write(response.getOutputStream());
	
			//workbook.close();
		} 

		logger.debug("ezPMS exportGanttExcel ended.");
	}
	
	/**
	 * 프로젝트, 그룹, 업무의 이름 변경(간트차트)
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezPMS/updateTaskName.do")
	@ResponseBody
	public String updateTaskName(HttpServletRequest request, Model model, @RequestBody Map<String, Object> param, @CookieValue("loginCookie") String loginCookie) {
		
		logger.debug("ezPMS updateTaskName started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		
		String taskId = (String)param.get("taskId");
		
		String url = "/rest/ezPMS/tasks/" + taskId + "/name/users/" + userId;
				
		JSONObject resultBody = commonUtil.getJsonFromRestApi(url, param, request, "put", null);
		String status = resultBody.get("status").toString();
		String roleCheck = "";
		
		if(status.equals("ok")) {
			roleCheck = resultBody.get("data").toString();
		}
		
		logger.debug("[result] roleCheck : " + roleCheck);
		logger.debug("ezPMS updateTaskName ended");
		
		return roleCheck;
	}
	
	@RequestMapping(value="/ezPMS/updateGroupRealStartEndDate.do")
	public String updateGroupRealStartEndDate(HttpServletRequest request, Model model, @RequestBody Map<String, Object> param, @CookieValue("loginCookie") String loginCookie) {
		logger.debug("ezPMS updateGroupRealStartEndDate started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		param.put("userId", userInfo.getId());
		
		int groupId;
		
		if(param.get("groupId") instanceof String) {
			groupId = Integer.parseInt((String) param.get("groupId"));
		} else {
			groupId = (Integer)param.get("groupId");
		}
		
		
		String url = "/rest/ezPMS/groups/" + groupId + "/realStartEndDate";
		commonUtil.getJsonFromRestApi(url, param, request, "put", null);
		
		logger.debug("ezPMS updateGroupRealStartEndDate ended");
		return "json";
	}
}
