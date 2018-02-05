package egovframework.ezEKP.ezJournal.web;

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
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

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
		
		
		logger.debug("formMain ended");
		return "/admin/ezJournal/formMain";
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
