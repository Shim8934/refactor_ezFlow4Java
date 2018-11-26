package egovframework.ezEKP.ezSurvey.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import egovframework.ezEKP.ezSurvey.service.EzSurveyRestService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.utl.fcc.service.CommonUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@SuppressWarnings("unchecked")
@Controller
public class EzSurveyController {
	private static final Logger logger = LoggerFactory.getLogger(EzSurveyController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzSurveyRestService surveyRestService;
	
	@RequestMapping(value = "/ezSurvey/surveyMain.do")
	public String jspGetSurveyMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, Model model) {
		logger.debug("jspGetSurveyMain started");
		logger.debug("jspGetSurveyMain ended");
		return "ezSurvey/mainmenu/surveyMain";
	}
	
	@RequestMapping(value="/ezSurvey/surveyLeft.do")
	public String jspGetSurveyLeft(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception{
		logger.debug("jspGetSurveyLeft started");
		
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		logger.debug("jspGetSurveyLeft ended");
		return "ezSurvey/mainmenu/surveyLeft";
	}
	
	@RequestMapping(value="/ezSurvey/surveyConfig.do")
	public String jspGetSurveyConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetSurveyConfig started");
		logger.debug("jspGetSurveyConfig ended");
		return "ezSurvey/config/surveyConfig";
	}
	
	
	@RequestMapping(value="/ezSurvey/surveyGeneral.do")
	public String jspGetSurveyGeneral(@CookieValue("loginCookie") String loginCookie,  HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetSurveyGeneral started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
/*		JSONObject resultObj = cabinetRestService.getUserPreviewConfig(request, user.getId());
		
		if (resultObj.get("status").toString().equals("ok")) {
			JSONObject userConfig = (JSONObject)resultObj.get("config");
			model.addAttribute("config", userConfig);
		}*/
		
		logger.debug("jspGetSurveyGeneral ended");
		return "ezSurvey/config/surveyGeneral";
	}
	
	@RequestMapping(value="/ezSurvey/surveyList.do")
	public String jspGetSurveyList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetSurveyList started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		/*String cabinetId   = request.getParameter("cabinetId");
		
		JSONObject resultObj = cabinetRestService.getCabinetInfo(request, user.getId(), cabinetId);
		
		if (resultObj.get("status").toString().equals("ok")) {
			JSONObject cabinet = (JSONObject) resultObj.get("cabinet");
			model.addAttribute("cabinet", cabinet);
		}
		
		JSONObject configObj = cabinetRestService.getUserPreviewConfig(request, user.getId());
		
		if (configObj.get("status").toString().equals("ok")) {
			JSONObject userConfig = (JSONObject)configObj.get("config");
			model.addAttribute("config", userConfig);
		}
		
		model.addAttribute("cabinetId", cabinetId);*/
		logger.debug("jspGetSurveyList ended");
		return "ezSurvey/listmenu/surveyList";
	}
	
	@RequestMapping(value="/ezSurvey/createSurvey.do")
	public String jspGetCreateSurveyPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetCreateSurveyPage started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		logger.debug("jspGetCreateSurveyPage ended");
		return "ezSurvey/listmenu/surveyCreate";
	}
	
	@RequestMapping(value="/ezSurvey/addQuestionPage.do")
	public String jspAddQuestionPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspAddQuestionPage started");
		
		logger.debug("jspAddQuestionPage ended");
		return "ezSurvey/listmenu/questionCreate";
	}
	
	@RequestMapping(value="/ezSurvey/statisticsPage.do")
	public String jspStatisticsPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspStatisticsPage started");
		
		logger.debug("jspStatisticsPage ended");
		return "ezSurvey/listmenu/statistics";
	}
	
	@RequestMapping(value="/ezSurvey/selectUsers.do")
	public String jspGetSelectUesrPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetSelectUesrPage started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		logger.debug("jspGetSelectUesrPage ended");
		return "ezSurvey/user/selectUser";
	}
	
	@RequestMapping(value="/ezSurvey/getCompanyTree.do")
	@ResponseBody
	public String jsonGetCompanyTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception{
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String companyId       = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		JSONObject resultObj   = new JSONObject();
		
		resultObj = surveyRestService.getCompanyTree(request, userInfo.getId(), companyId);
		
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezSurvey/getSubNodes.do")
	@ResponseBody
	public String jsonGetSubNodes(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception{
		logger.debug("jsonGetSubNodes started");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String deptId          = request.getParameter("nodeId") != null ? request.getParameter("nodeId") : "";
		String level           = request.getParameter("level")  != null ? request.getParameter("level")  : "";
		JSONObject resultObj   = new JSONObject();
		
		if (deptId.equals("") || level.equals("")) {
			logger.debug("Parameter error");
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = surveyRestService.getDeptSubNodes(request, userInfo.getId(), deptId, level);
		logger.debug("jsonGetSubNodes ended");
		
		return resultObj.toString();
	}
}
