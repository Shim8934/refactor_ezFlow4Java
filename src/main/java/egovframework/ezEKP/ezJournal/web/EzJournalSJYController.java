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

import egovframework.ezEKP.ezCommon.service.EzCommonService;
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
	
	@Autowired
	private EzCommonService ezCommonService;
	
	/**
	 * 관리자 업무일지 양식리스트 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezJournal/form.do")
	public String formMain(HttpServletRequest request, ModelMap model, @CookieValue("loginCookie") String loginCookie, HttpServletResponse response) throws Exception {
		logger.debug("formMain started");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		Map<String, Object> param = new HashMap<String, Object>();

		String companyId = null;
		if (request.getParameter("companyId") != null) {
			companyId = request.getParameter("companyId");
		} else {
			companyId = userInfo.getCompanyID();
		}
		
		param.put("companyId", companyId);
		param.put("userId", userInfo.getId());
		param.put("tenantId", userInfo.getTenantId());
		
		String restUrl = "/ezjournal/companies";
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
		
		String status = result.get("status").toString();
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		
		if (status.equals("ok")) {
			JSONArray companyList = (JSONArray) result.get("data");
			
			model.addAttribute("userInfo", userInfo);
			model.addAttribute("companyList", companyList);
			model.addAttribute("useEditor", useEditor);
		}
		
		param.clear();
		
		param.put("companyId", companyId);
		param.put("tenantId", userInfo.getTenantId());
		param.put("used", "use");
		
		restUrl = "/ezjournal/types";
		result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
		
		status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray typeList = (JSONArray) result.get("data");
			model.addAttribute("typeList", typeList);
			System.out.println(typeList);
		}
		
		logger.debug("formMain ended");
		return "/admin/ezJournal/formMain";
	}
	
	/**
	 * 관리자 업무일지 일지함의 양식리스트 가져오기
	 */
	@RequestMapping(value = "/admin/ezJournal/getFormList.do", produces = "application/json;charset=utf-8")
	@ResponseBody
	public String getFormList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) {
		logger.debug("getFormList started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String typeId = request.getParameter("typeId");
		String companyId = request.getParameter("companyId");
		int tenantId = userInfo.getTenantId();
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("companyId", companyId);
		param.put("tenantId", tenantId);
		
		String restUrl = "/ezjournal/types/" + typeId + "/forms";
		
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONObject data =  (JSONObject) result.get("data");
			JSONArray list = (JSONArray) data.get("fList");
			String fList = JsonUtil.ListToJson(list);
			model.addAttribute("fLit", fList);
			return fList;
		}
		
		logger.debug("getFormList ended");
		return "json";
	}
	
	
	/**
	 * 관리자 업무일지 양식등록 양식추가, 양식수정 화면호출함수 (폼프로세서)
	 */
	@RequestMapping(value = "/admin/ezJournal/insertForm.do")
	public String addForm(HttpServletRequest request, ModelMap model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("addForm started");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		logger.debug("addForm ended");
		return "/admin/ezJournal/insertForm";
	}
	
	/**
	 * 관리자 업무일지 양식등록 양식추가, 양식수정 화면호출함수 (CK, TAGFREE, DEXTER, NAMO)
	 */
	@RequestMapping(value = "/admin/ezJournal/insertFormOther.do")
	public String addFormOther(HttpServletRequest request, ModelMap model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("addFormOther started");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		String companyId = request.getParameter("companyId");
		String typeId = request.getParameter("typeId");
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("companyId", companyId);
		param.put("tenantId", userInfo.getTenantId());
		param.put("used", "use");
		
		String restUrl = "/ezjournal/types";
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray typeList = (JSONArray) result.get("data");
			model.addAttribute("typeList", typeList);
			System.out.println(typeList);
		}
		
		model.addAttribute("companyId", companyId);
		model.addAttribute("typeId", typeId);
		model.addAttribute("useEditor", useEditor);
		
		logger.debug("addFormOther ended");
		return "/admin/ezJournal/insertFormOther";
	}
	
	/**
	 * 업무일지 양식등록 양식등록,양식수정 양식작성기 저장 실행 함수
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezJournal/formSave.do", produces="application/json;charset=UTF-8")
	@ResponseBody
	public String formSave (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("formSave started.");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		String companyId = request.getParameter("companyId");
		String typeId = request.getParameter("typeId");
		//String formID = request.getParameter("formID");
		String formName = request.getParameter("formName");
		String formDescript = request.getParameter("formDescript");
		String formContent = request.getParameter("formContent");
		//String useDept = request.getParameter("useDept");
		String userId = userInfo.getId();
		int tenantId = userInfo.getTenantId();
		
		logger.debug("formName:" + formName + ",formDescript:" + formDescript + ",formContent:" + formContent);
		
		JSONObject param = new JSONObject();
		
		param.put("companyId", companyId);
		param.put("typeId", typeId);
		//param.put("formID", formID);
		param.put("formName", formName);
		param.put("formDescript", formDescript);
		param.put("formContent", formContent);
		//param.put("useDept", useDept);
		param.put("formWriter", userId);
		param.put("tenantId", tenantId);
		
		
		
		String restUrl = "/ezjournal/types/" + typeId + "/forms";
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, null, request, "post", param);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			
		}
		
		logger.debug("formSave ended.");         
		
		return JsonUtil.OneStringToJson("json");
	}
	
}
