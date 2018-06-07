package egovframework.ezEKP.ezPMS.web;

import java.util.Map;

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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

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
		String userId = userInfo.getId();
		int currentPage = (int) param.remove("currentPage");
		int listNumber = Integer.parseInt(param.get("listNumber").toString());
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		} else {
			// checkAdmin을 통해 사용자가 관리자임이 확인되었을 때만 admin값을 true로 넘긴다.
			param.put("admin", true);
		}
		
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
}
