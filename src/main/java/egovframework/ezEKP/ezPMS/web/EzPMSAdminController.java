package egovframework.ezEKP.ezPMS.web;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

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
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.ezEKP.ezPMS.vo.ProjectPagination;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzPMSAdminController {

	private static final Logger LOGGER = LoggerFactory.getLogger(EzPMSAdminController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	/**
	 * 프로젝트 관리 관리자 모드 메인 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPMS/pmsMain.do")
	public String ezPMSMain(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo) {
		LOGGER.debug("ezPMSMain started");

		userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		LOGGER.debug("ezPMSMain ended");
		
		return "/admin/ezPMS/pmsMain";
	}
	
	/**
	 * 프로젝트 관리 관리자 모드  좌측 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPMS/leftTop.do")
	public String leftTop(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo) {
		LOGGER.debug("leftTop started");

		userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		LOGGER.debug("leftTop ended");
		
		return "/admin/ezPMS/leftTop";
	}
	
	
	/**
	 * 프로젝트 관리 관리자 모드 메인 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPMS/projectListMain.do")
	public String projectListMain(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo) {
		LOGGER.debug("projectListMain started");

		userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		LOGGER.debug("projectListMain ended");
		
		return "/admin/ezPMS/pmsProjectListMain";
	}
	
	/**
	 * 프로젝트 관리 관리자 모드 프로젝트 리스트 호출 함수
	 */
	@RequestMapping(value = "/admin/ezPMS/getProjectList.do", method=RequestMethod.POST)
	public String getProjectList(HttpServletRequest request, Model model, @RequestBody Map<String, Object> param, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) {
		LOGGER.debug("getProjectList started");

		userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		} else {
			// checkAdmin을 통해 사용자가 관리자임이 확인되었을 때만 admin값을 true로 넘긴다.
			param.put("admin", true);
		}
		
		String userId = userInfo.getId();
		int currentPage = (int) param.remove("currentPage");
		int listNumber = Integer.parseInt(param.get("listNumber").toString());
		String url = "/rest/ezPMS/projects/userId/" + userId;
		String countUrl = "/rest/ezPMS/projects/userId/" + userId + "/count";
		
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
					param.put("startCount", paging.getStartCount());
					
					JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "get", null);
					String status = result.get("status").toString();
					
					if (status.equals("ok")) {		
						projectList = (JSONArray) result.get("data");
					}
				}
			}
			
			model.addAttribute("projectList", projectList);
			model.addAttribute("projectListCount", projectListCount);
		}
		
		LOGGER.debug("getProjectList ended");
		
		return "/admin/ezPMS/pmsProjectList";
	}
	
	@RequestMapping(value = "/admin/ezPMS/getProjectGeneralInfo.do")
	public String getProjectGeneralInfo(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) {
		LOGGER.debug("getProjectGeneralInfo started");
		
		userInfo = commonUtil.checkAdmin(loginCookie);
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		} else {
			// checkAdmin을 통해 사용자가 관리자임이 확인되었을 때만 admin값을 true로 넘긴다.
			param.put("admin", true);
		}
		
		String userId = userInfo.getId();
		String projectId = request.getParameter("projectId");
		String url = "/rest/ezPMS/projects/" + projectId + "/userId/" + userId;
		JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "get", null);
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONObject json = (JSONObject) result.get("data");
			JSONObject project = (JSONObject) json.get("project");
			
			model.addAttribute("project", project);
		}
		
		LOGGER.debug("getProjectGeneralInfo ended");
		
		return "/admin/ezPMS/pmsProjectGeneralInfo";
	}
	
	@RequestMapping(value = "/admin/ezPMS/deleteProject.do")
	@ResponseBody
	public String deleteProject(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> param, HttpServletRequest request, Model model, LoginVO userInfo) throws Exception {
		LOGGER.debug("deleteProject started");
		
		userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		} else {
			// checkAdmin을 통해 사용자가 관리자임이 확인되었을 때만 admin값을 true로 넘긴다.
			param.put("admin", true);
		}
		
		String userId = userInfo.getId();
		String projectId = (String) param.get("projectId");
		String url = "/rest/ezPMS/projects/" + projectId;
		
		param.put("userId", userId);
		
		JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "delete", null);
		String data = result.get("data").toString();	
		
		LOGGER.debug("deleteProject ended");
		
		return data;
	}
	
	// need to think about transaction
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezPMS/modifyProject.do")
	public String modifyProject(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> param, HttpServletRequest request, Model model, LoginVO userInfo) throws Exception {
		LOGGER.debug("modifyProject started");
		
		userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		} else {
			// checkAdmin을 통해 사용자가 관리자임이 확인되었을 때만 admin값을 true로 넘긴다.
			param.put("admin", true);
		}
		
		String projectId = (String) param.get("projectId");
		String url = "/rest/ezPMS/projects/" + projectId;
		String today = commonUtil.getTodayUTCTime("yyyy-MM-dd");
		
		param.put("createDate", today);
		param.put("userId", userInfo.getId());
		
		JSONObject jsonList = new JSONObject();
		jsonList.put("managerList", param.get("managerList"));
		jsonList.put("participantList", param.get("participantList"));
		jsonList.put("viewerList", param.get("viewerList"));
		jsonList.put("overview", param.get("overview"));
		
		JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "put", jsonList);
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			model.addAttribute("memberChange", "success");
		}
		
		url = "/rest/ezPMS/projects/" + projectId + "/status";
		
		param.put("changeDate", today);
		
		result = commonUtil.getJsonFromRestApi(url, param, request, "put", null);
		status = result.get("status").toString();
		
		if (status.equals("ok")) {
			model.addAttribute("statusChange", "success");
		}
		
		LOGGER.debug("modifyProject ended");
		
		return "json";
	}
}
