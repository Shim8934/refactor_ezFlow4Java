package egovframework.ezEKP.ezPMS.web;

import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
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
		String projectName = request.getParameter("projectName");
		String taskName = request.getParameter("taskName");
		String groupId = request.getParameter("groupId");
		String taskId = request.getParameter("taskId");
		
		model.addAttribute("projectId", projectId);
		model.addAttribute("projectName", projectName);
		model.addAttribute("writerId", writerId);
		model.addAttribute("writerName", writerName);
		model.addAttribute("writerDeptName", writerDeptName);
		model.addAttribute("taskName", taskName);
		model.addAttribute("groupId", groupId);
		model.addAttribute("taskId", taskId);
		
		LOGGER.debug("ezPMS goAddBoard ended");
		
		return "/ezPMS/pmsAddBoard";
	}
	
	@RequestMapping(value="/ezPMS/addBoard.do")
	public String addBoard(HttpServletRequest request, Model model, @RequestBody Map<String, Object> param, @CookieValue("loginCookie") String loginCookie) throws Exception {
		
		LOGGER.debug("ezPMS addBoard started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String today = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
		
		param.put("tenantId", userInfo.getTenantId());
		param.put("writerId", userInfo.getId());
		param.put("writeDate", today);
		param.put("writerName", userInfo.getDisplayName1());
		param.put("writerName2", userInfo.getDisplayName2());
		param.put("writerDeptname", userInfo.getDeptName1());
		param.put("writerDeptname2", userInfo.getDeptName2());
		param.put("writerPosition", userInfo.getTitle1());
		param.put("writerPosition2", userInfo.getTitle2());
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezPMS/boards", param, request, "post", null);
		String status = resultBody.get("status").toString();
		
		if(status.equals("ok")) {
			model.addAttribute("data", "test");
		}
		
		LOGGER.debug("ezPMS addBoard ended");
		
		return "json";
	}
}
