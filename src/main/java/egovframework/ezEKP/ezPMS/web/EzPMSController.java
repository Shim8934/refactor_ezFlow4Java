package egovframework.ezEKP.ezPMS.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezMobile.ezCommon.web.MCommonGWController;
import egovframework.let.user.login.vo.LoginSimpleVO;
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

	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name = "EzEmailService")
	private EzEmailService ezEmailService;
	
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
	 */
	@RequestMapping(value = "/ezPMS/getProjectDetails.do")
	public String getProjectDetails(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS getProjectDetails started");		
		LOGGER.debug("ezPMS getProjectDetails ended");		
		return "ezPMS/pmsProjectDetails";
	}
	
	/**
	 * 새프로젝트 등록 화면 호출
	 */
	@RequestMapping(value = "/ezPMS/newProject.do")
	public String newProject(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS addNewProject started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userName = userInfo.getDisplayName1();
		String offset = userInfo.getOffset();
		String projectId = request.getParameter("taskID");
		
		String planStartDate = "";
		String planEndDate = "";
		
		if (projectId == null) {
			projectId = "";
			
			String nowDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), offset, false);
			planStartDate = nowDate.substring(0, 10);
			
			planEndDate = nowDate.substring(0, 10);
		}
		
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
	public String addNewProject(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> param, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("ezPMS addNewProject started");
		
		String projectId = "";
		
		try{
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			String url = "/rest/ezPMS/projects";
			String writerName = userInfo.getDisplayName1();
			String today = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
			
			param.put("writerName", writerName);
			param.put("creatorId", userInfo.getId());
			param.put("tenantId", userInfo.getTenantId());
			param.put("createDate", today);
			param.put("creatorName", userInfo.getDisplayName1());
			param.put("creatorName2", userInfo.getDisplayName2());
			param.put("creatorDeptname", userInfo.getDeptName1());
			param.put("creatorDeptname2", userInfo.getDeptName2());
			
			JSONObject jsonList = new JSONObject();
			jsonList.put("managerList", param.get("managerList"));
			jsonList.put("participantList", param.get("participantList"));
			jsonList.put("viewerList", param.get("viewerList"));

			JSONObject result = commonUtil.getJsonFromRestApi(url, param, request, "post", jsonList);
			
			Map<String, Object> data = (Map<String, Object>) result.get("data");
			projectId = String.valueOf(data.get("projectId"));
			
			LOGGER.debug("projectId : " + projectId);
		} catch(Exception e) {
			LOGGER.debug("ERROR : " + e.getMessage());
		}
		
		LOGGER.debug("ezPMS addNewProject ended");
		return projectId;
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
	
	/**
	 * 수신자 선택화면 호출
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezPMS/pmsSelectAuth.do")
	public String selectAuth(@CookieValue("loginCookie") String loginCookie,HttpServletRequest request, Model model) {
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
			
			System.out.println(userInfo.getDeptName1());
			System.out.println(userInfo.getDeptName());
			
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
	public String selectHeadManager() {
		return "ezPMS/selectHeadManager";
	}
	
	// 알림메일 발송
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezPMS/sendNotiMail.do")
	public void sendNotiMail(@RequestBody Map<String, Object> param, HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {
		LOGGER.debug("sendNotiMail Started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String projectName = (String) param.get("projectName");
		int projectId = (int) param.get("projectId");
		List<Map<String, Object>> managerList = (List<Map<String, Object>>) param.get("managerList");
		List<Map<String, Object>> participantList = (List<Map<String, Object>>) param.get("participantList");
		List<Map<String, Object>> viewerList = (List<Map<String, Object>>) param.get("viewerList");
		
		param.put("tenantId", userInfo.getTenantId());
		
		try{
			getToArrMailList(managerList, param, request, projectName, projectId, "관리자", loginCookie);
			getToArrMailList(participantList, param, request, projectName, projectId, "참여자", loginCookie);
			getToArrMailList(viewerList, param, request, projectName, projectId, "조회자", loginCookie);
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			LOGGER.debug("ERROR : " + e.getMessage());
		}
	}
	
	public InternetAddress[] getToArrMailList (List<Map<String, Object>> nameList, Map<String, Object> param, HttpServletRequest request, String projectName, int projectId, String authName, @CookieValue("loginCookie") String loginCookie) {
		LOGGER.debug("getToArrMailList started");
		
		ArrayList<InternetAddress> toArrList = new ArrayList<InternetAddress>();
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		try {
			for (int i = 0; i < nameList.size(); i++) {
				String userId = (String)nameList.get(i).get("userId");
				
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
			
			for (int i = 0; i < toArr.length; i++) {
				String subject = "[" + projectName + "] 프로젝트 " + authName + "로 지정되었습니다."; 
				
				String content = "<p>" + "[" + projectName + "] 프로젝트 " + authName + "로 지정되었습니다." + "</p>";
				content += "<p></p>";
				content += "<a href='#' target='' onclick='getProjectInfo(" + projectId + ");'>[" + projectName + "] 프로젝트로 이동</a>";
				
				InternetAddress from;
				from = new InternetAddress(userInfo.getEmail());
				from.setPersonal(userInfo.getDisplayName());
				
				ezEmailService.sendMail(loginCookie, from, toArr, null, null, subject, content, false);
			}
			
			LOGGER.debug("getToArrMailList ended");
			return toArr;
		} catch (Exception e) {
			LOGGER.debug("ERROR : " + e.getMessage());
			return null;
		}
	}
}
