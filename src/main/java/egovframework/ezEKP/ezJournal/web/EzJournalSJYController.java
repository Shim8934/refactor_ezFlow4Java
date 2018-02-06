package egovframework.ezEKP.ezJournal.web;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.JsonUtil;

@Controller
public class EzJournalSJYController {

	private static final Logger logger = LoggerFactory.getLogger(EzJournalSJYController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	/**
	 * 관리자 업무일지 양식리스트 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezJournal/form.do")
	public String formMain(HttpServletRequest request, ModelMap model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse response) throws Exception {
		logger.debug("formMain started");
		
		userInfo = commonUtil.checkAdmin(loginCookie);
		
		String userId = userInfo.getId();
		int tenantId = userInfo.getTenantId();
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		param.put("tenantId", tenantId);
		
		String restUrl = "/ezjournal/companies";
		
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray companyList = (JSONArray) result.get("data");
			
			model.addAttribute("userInfo", userInfo);
			model.addAttribute("companyList", companyList);
		}
		
		logger.debug("formMain ended");
		return "/admin/ezJournal/formMain";
	}
	
	/**
	 * 관리자 업무일지 사용하는 일지함 정보만 가져오기
	 */
	@RequestMapping(value = "/admin/ezJournal/useType.do", produces = "application/json;charset=utf-8")
	@ResponseBody
	public String useType(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) {
		logger.debug("useType started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String companyId = request.getParameter("companyId");
		int tenantId = userInfo.getTenantId();
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("companyId", companyId);
		param.put("tenantId", tenantId);
		param.put("used", "use");
		
		String restUrl = "/ezjournal/types";
		
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray data = (JSONArray) result.get("data");
			String typeList = JsonUtil.ListToJson(data);
			model.addAttribute("typeList", typeList);
			System.out.println(typeList);
			return typeList;
		}
		
		logger.debug("useType ended");
		return "";
	}
	
	
	/**
	 * 관리자 업무일지 양식등록 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezJournal/addForm.do")
	public String addForm(HttpServletRequest req, ModelMap model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp) throws Exception {
		logger.debug("addForm started");
		
		userInfo = commonUtil.checkAdmin(loginCookie);
		
		logger.debug("addForm ended");
		return "/admin/ezJournal/addForm";
	}
	
	
}
