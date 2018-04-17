package egovframework.ezEKP.ezPMS.web;

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.ezMobile.ezCommon.web.MCommonGWController;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzPMSController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(MCommonGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EgovFileScrty egovFileScrty;
	
	@Autowired
	private Properties config;
	
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
	public String left() {
		return "ezPMS/pmsLeft";
	}
	
	/**
	 * 메인페이지화면 호출 함수
	 */
	@RequestMapping(value = "/ezPMS/pmsProjectList.do")
	public String projectList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		
		LOGGER.debug("ezPMS projectList started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String url = "/rest/ezPMS/projects/userId/"+userInfo.getId();
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("status", "P");
		param.put("projectName", "hello world");
		param.put("manager", "eunjeong");
		param.put("planStartDate", "2018-04-17");
		param.put("planEndDate", "2018-04-18");
		param.put("overview", "hello");
		param.put("viewType", "memo");
		param.put("listNum", 10);
		param.put("sortType", "endDate");
		
		JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "get", null);
		
		String status = result.get("status").toString();
		
		model.addAttribute("status", status);
		
		LOGGER.debug("ezPMS projectList ended");
		return "ezPMS/pmsProjectList";
	}
	
	/**
	 * 나의 업무 화면 호출 함수
	 */
	@RequestMapping(value = "/ezPMS/pmsMyTask.do")
	public String myTaskPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS MyTask page started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
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
		
		LOGGER.debug("ezPMS Setting started");
		return "ezPMS/pmsSetting";
	}
	
	/**
	 * 프로젝트 상세 조회 화면 호출
	 * @param loginCookie
	 * @param request
	 * @param resp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezPMS/getProjectDetails.do")
	public String getProjectDetails(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS getProjectDetails started");		
		LOGGER.debug("ezPMS getProjectDetails ended");		
		return "ezPMS/pmsProjectDetails";
	}
	
	/**
	 * 새로운 프로젝트 추가
	 * @param loginCookie
	 * @param request
	 * @param resp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezPMS/addNewProject.do")
	@ResponseBody
	public JSONObject addNewProject(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS addNewProject started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String url = "/rest/ezPMS/projects";
		
		int test = 25;
		
		Map<String, Object> param = new HashMap<>();
		param.put("test", test);
		
		JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "post", null);
		
//		JSONArray list = new JSONArray();
		System.out.println(result);
		model.addAttribute("test", result.get("status").toString());
		model.addAttribute("result", result);
		
		LOGGER.debug("ezPMS addNewProject ended");
		return result;
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
	public String deleteProject(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS deleteProject started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String projectId = request.getParameter("projectId");
		String url = "/rest/ezPMS/projects/" + projectId;
		
		LOGGER.debug("ezPMS deleteProject ended");
		return null;
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
	public String updateMainSetting(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS updateMainSetting started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String url = "/rest/ezPMS/users/" + userId + "/setting";
		
				
		LOGGER.debug("ezPMS updateMainSetting ended");
		return null;
	}
	
	/**
	 * 프로젝트 상태 변경
	 * @param loginCookie
	 * @param request
	 * @param resp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezPMS/updateProjectStatus.do")
	public String updateProjectStatus(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS updateProjectStatus started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String projectId = request.getParameter("projectId");
		String url = "/rest/ezPMS/projects/" + projectId + "/status";
		
		LOGGER.debug("ezPMS updateProjectStatus ended");
		return null;
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
		LOGGER.debug("ezPMS getProjectDetails started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String projectId = request.getParameter("projectId");
		String userId = userInfo.getId();
		
		String url = "/rest/ezPMS/projects" + projectId + "/userId/" + userId;
		
		
		LOGGER.debug("ezPMS getProjectDetails ended");		
		return "ezPMS/pmsProjectOverview";
	}
	
	/**
	 * 프로젝트 수정
	 * @param loginCookie
	 * @param request
	 * @param resp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezPMS/updateProject.do")
	public String updateProject(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS updateProject started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String projectId = request.getParameter("projectId");
		String url = "/rest/ezPMS/projects/" + projectId;
		
		LOGGER.debug("ezPMS updateProject ended");		
		return null;
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
		String projectId = request.getParameter("projectId");
		String roleId = request.getParameter("roleId");
		
		String url = "/rest/ezPMS/projects/" + projectId + "/roles/" + roleId;
		
		
		LOGGER.debug("ezPMS getProjectMember ended");			
		return null;
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
	@RequestMapping(value = "/ezPMS/getTaskList.do")
	public String getTaskList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS getTaskList started");
		
		LOGGER.debug("ezPMS getTaskList ended");			
		return null;
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
	public String changeKanbanOrder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS changeKanbanOrder started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String projectId = request.getParameter("projectId");
		String userId = userInfo.getId();
		
		String url = "/rest/ezPMS/projects" + projectId + "/userId/" + userId + "/order";
		
		
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
	public String addFavoriteProject(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS addFavoriteProject started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String projectId = request.getParameter("projectId");
		String userId = userInfo.getId();
		
		String url = "/rest/ezPMS/userId/" + userId + "/favorites/" + projectId;
		
		LOGGER.debug("ezPMS addFavoriteProject ended");			
		return null;
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
	public String deleteFavoriteProject(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS deleteFavoriteProject started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String projectId = request.getParameter("projectId");
		String userId = userInfo.getId();
		
		String url = "/rest/ezPMS/userId/" + userId + "/favorites/" + projectId;
		
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
	public String addTaskLog(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS addTaskLog started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String projectId = request.getParameter("projectId");
		
		String url = "/rest/ezPMS/projects/" + projectId + "/logs";
		
		LOGGER.debug("ezPMS addTaskLog ended");				
		return null;
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
	public String getTaskLogList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS getTaskLogList started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String projectId = request.getParameter("projectId");
		
		String url = "/rest/ezPMS/projects/" + projectId + "/logs";
		
		LOGGER.debug("ezPMS getTaskLogList ended");				
		return "ezPMS/pmsTaskLogList";
	}
}
