package egovframework.ezEKP.ezPMS.web;

import java.util.HashMap;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.ezEKP.ezPMS.vo.ProjectBoardVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzPMSController3 {

	private static final Logger LOGGER = LoggerFactory.getLogger(EzPMSController3.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EgovFileScrty egovFileScrty;
	
	@Autowired
	private Properties config;
	
	@RequestMapping(value="/ezPMS/getProjectBoard.do")
	public String getProjectBoard(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) {
		
		LOGGER.debug("ezPMS getProjectBoard started");
		
		String projectId = request.getParameter("projectId");
		
		model.addAttribute("projectId", projectId);
		
		LOGGER.debug("ezPMS getProjectBoard ended");
		
		return "/ezPMS/pmsBoard";
	}
	
	@RequestMapping(value="/ezPMS/goAddBoard.do")
	public String goAddBoard(HttpServletRequest request, Model model, ProjectBoardVO vo , @CookieValue("loginCookie") String loginCookie) {
		
		LOGGER.debug("ezPMS goAddBoard started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String writerId = userInfo.getId();
		String writerName = userInfo.getDisplayName();
		String writerDeptName = userInfo.getDeptName();
		
		String projectId = request.getParameter("projectId");
		String taskName = request.getParameter("taskName");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/projects/" + projectId + "/userId/" + writerId, param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			model.addAttribute("project", data.get("project"));
		}
		
		model.addAttribute("projectId", projectId);
		model.addAttribute("writerId", writerId);
		model.addAttribute("writerName", writerName);
		model.addAttribute("writerDeptName", writerDeptName);
		model.addAttribute("taskName", taskName);
		
		LOGGER.debug("ezPMS goAddBoard ended");
		
		return "/ezPMS/pmsAddBoard";
	}
}
