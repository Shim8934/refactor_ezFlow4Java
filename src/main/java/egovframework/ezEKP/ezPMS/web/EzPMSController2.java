package egovframework.ezEKP.ezPMS.web;

import java.util.HashMap;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
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
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.google.gson.Gson;

import egovframework.ezEKP.ezPMS.vo.ProjectTaskVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzPMSController2 {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(EzPMSController2.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EgovFileScrty egovFileScrty;
	
	@Autowired
	private Properties config;
	
	/**
	 * 프로젝트관리 업무 리스트 호출함수
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/ezPMS/TaskListMain.do")
	public String TaskListMain(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) {
		
		LOGGER.debug("ezPMS TaskListMain started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String projectId = request.getParameter("projectId");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("taskName", "test123");
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/task-list/" + projectId + "/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			JSONArray taskList = (JSONArray) resultBody.get("data");
			model.addAttribute("taskList", taskList);
		}
		
		LOGGER.debug("ezPMS TaskListMain ended");
		
		return "/ezPMS/pmsProjectList";
	}
	
	@RequestMapping(value="/ezPMS/addTask.do")
	public String addTask(HttpServletRequest request, Model model, ProjectTaskVO vo,@CookieValue("loginCookie") String loginCookie) {
		
		LOGGER.debug("ezPMS TaskListMain started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String projectId = request.getParameter("projectId");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		vo.setTaskName("test123");
		
		Gson gson = new Gson();
		JSONParser jp = new JSONParser();
		JSONObject jsonParam = null;
		try {
			jsonParam = (JSONObject) jp.parse(gson.toJson(vo));
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/tasks/" + projectId + "/users/" + userInfo.getId(), param, request, "post", jsonParam);
		String status = resultBody.get("status").toString();
				
		LOGGER.debug("ezPMS TaskListMain ended");
		
		return "/ezPMS/pmsProjectList";
	}
	
}
