package egovframework.ezEKP.ezCabinet.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.ezEKP.ezCabinet.service.EzCabinetRestService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzCabinetController_m {
	private static final Logger logger = LoggerFactory.getLogger(EzCabinetController_m.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzCabinetRestService cabinetRestService;
	
	@RequestMapping(value = "/ezCabinet/cabinetAddRelated.do")
	public String jspGetCabinetFileDetail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		logger.debug("jspGetCabinetFileDetail started");
		logger.debug("jspGetCabinetFileDetail ended");
		return "ezCabinet/cabinetAddRelated";
	}
	
	@RequestMapping(value="/ezCabinet/saveRelatedItem.do", method = RequestMethod.POST)
	@ResponseBody
	public String jsonSaveRelatedItem(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		logger.debug("Save relatedItem is running!");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String title           = request.getParameter("title")       != null ? request.getParameter("title")       : "";
		String author          = request.getParameter("author")      != null ? request.getParameter("author")      : "";
		String normalScreen    = request.getParameter("normalScreen")!= null ? request.getParameter("normalScreen"): "";
		JSONObject resultObj   = new JSONObject();
		
		if (title.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		JSONParser jp        = new JSONParser();
		JSONArray normalScr  = (JSONArray) jp.parse(normalScreen);
		
		resultObj = cabinetRestService.SaveRelatedItem(request, userInfo.getId(), title, author, normalScr);
		
		logger.debug("Save relatedItem finishes!");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/cabinetRelatedFileDetail.do")
	public String jspGetCabinetRelatedFileDetail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		logger.debug("jspGetCabinetFileDetail started");
		logger.debug("jspGetCabinetFileDetail ended");
		return "ezCabinet/cabinetFileDetail";
	}
}