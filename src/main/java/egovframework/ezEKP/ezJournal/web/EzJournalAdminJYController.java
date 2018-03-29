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

import com.google.gson.Gson;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezJournal.vo.JournalFormInfoVO;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.JsonUtil;

@Controller
public class EzJournalAdminJYController {

	private static final Logger logger = LoggerFactory.getLogger(EzJournalAdminJYController.class);
	
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
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		Map<String, Object> param = new HashMap<String, Object>();

		String companyId = null;
		if (request.getParameter("companyId") != null) {
			companyId = request.getParameter("companyId");
		} 
		
		param.put("companyId", companyId);
		param.put("userId", userInfo.getId());
		
		String restUrl = "/rest/ezjournal/companies";
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
		
		String status = result.get("status").toString();
//		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String useEditor = commonUtil.getTenantConfigRest("EDITOR", userInfo.getId(), request);
		
		
		if (status.equals("ok")) {
			JSONArray companyList = (JSONArray) result.get("data");
			
			model.addAttribute("userInfo", userInfo);
			model.addAttribute("companyList", companyList);
			model.addAttribute("useEditor", useEditor);
		}
		
		param.clear();
		
		param.put("userId", userInfo.getId());
		param.put("companyId", companyId);
		param.put("used", "use");
		
		restUrl = "/rest/ezjournal/types";
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
	@RequestMapping(value = "/admin/ezJournal/getFormList.do")
	public String getFormList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) {
		logger.debug("getFormList started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String typeId = request.getParameter("typeId");
		String companyId = request.getParameter("companyId");
	
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("companyId", companyId);
		param.put("userId", userInfo.getId());
		
		String restUrl = "/rest/ezjournal/types/" + typeId + "/forms";
		
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray formList = (JSONArray) result.get("data");
			model.addAttribute("formList", formList);
			logger.debug("formList : " + formList);
		}
		
		logger.debug("getFormList ended");
		return "/admin/ezJournal/formList";
	}
	
	/**
	 * 관리자 업무일지 양식등록 양식추가, 양식수정 화면호출함수 (폼프로세서)
	 */
	@RequestMapping(value = "/admin/ezJournal/insertForm.do")
	public String addForm(HttpServletRequest request, ModelMap model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("addForm started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		logger.debug("addForm ended");
		return "/admin/ezJournal/insertForm";
	}
	
	/**
	 * 관리자 업무일지 양식등록 양식추가, 양식수정 화면호출함수 (CK, TAGFREE, DEXTER, NAMO)
	 */
	@RequestMapping(value = "/admin/ezJournal/insertFormOther.do")
	public String addFormOther(HttpServletRequest request, ModelMap model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("addFormOther started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String companyId = request.getParameter("companyId");
		String typeId = request.getParameter("typeId");
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("companyId", companyId);
		param.put("userId", userInfo.getId());
		param.put("used", "use");
		
		String restUrl = "/rest/ezjournal/types";
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
		
		if (request.getParameter("formId") != null) {
			String formId = request.getParameter("formId");
			restUrl = "/rest/ezjournal/types/" + typeId + "/forms/" + formId;
			result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
			status = result.get("status").toString();
			
			if (status.equals("ok")) {
				JSONObject jsonResult = (JSONObject) result.get("data");
				Gson gson = new Gson();
				JournalFormInfoVO journalFormInfo = gson.fromJson(jsonResult.toString(), JournalFormInfoVO.class);
				model.addAttribute("formId", formId);
				model.addAttribute("formName", journalFormInfo.getFormName());
				model.addAttribute("formInfo", journalFormInfo.getFormInfo());
				model.addAttribute("formContent", JsonUtil.OneStringToJson(journalFormInfo.getFormContent()));
				model.addAttribute("useDepts", JsonUtil.ListToJson(journalFormInfo.getDepts()));
				logger.debug("useDepts 뭐임 : " + JsonUtil.ListToJson(journalFormInfo.getDepts()));
			}
		}
		
		param.clear();
		
		param.put("userId", userInfo.getId());
		param.put("companyId", companyId);
		
		result = commonUtil.getJsonFromRestApi("/rest/ezjournal/depts", param, request, "get", null);
		status = result.get("status").toString();
		
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
					dept.put("state", state);
				}
			}
			model.addAttribute("deptList", deptList);
		}
		
		logger.debug("addFormOther ended");
		return "/admin/ezJournal/insertFormOther";
	}
	
	/**
	 * 업무일지 양식등록 양식등록,양식수정 양식작성기 저장 실행 함수
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezJournal/formSave.do", produces="application/json;charset=UTF-8")
	@ResponseBody
	public void formSave (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("formSave started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String companyId = request.getParameter("companyId");
		String typeId = request.getParameter("typeId");
		String formName = request.getParameter("formName");
		String formDescript = request.getParameter("formDescript");
		String formContent = request.getParameter("formContent");
		String useDept = request.getParameter("useDept");
		String isDeptChanged = request.getParameter("isDeptChanged");
		String userId = userInfo.getId();
		
		logger.debug("formName:" + formName + ",formDescript:" + formDescript + ",formContent:" + formContent + ",useDept:" + useDept + ",isDeptChanged:" + isDeptChanged);
		
		JSONObject param = new JSONObject();
		
		param.put("companyId", companyId);
		param.put("typeId", typeId);
		param.put("formName", formName);
		param.put("formDescript", formDescript);
		param.put("formContent", formContent);
		param.put("useDept", useDept);
		param.put("formWriter", userId);
		param.put("isDeptChanged", isDeptChanged);
		param.put("userId", userInfo.getId());
		
		String formId = request.getParameter("formId");
		String restUrl = "";
		JSONObject result = null;
		String status = "";
		logger.debug("formId:" + formId);
		// formId가 있으면 수정, 없으면 신규등록
		if (formId != null && formId.trim() != "") {
			param.put("formId", formId);
			restUrl = "/rest/ezjournal/types/" + typeId + "/forms/" + formId;
			result = commonUtil.getJsonFromRestApi(restUrl, null, request, "put", param);
			status = result.get("status").toString();
		} else {
			restUrl = "/rest/ezjournal/types/" + typeId + "/forms";
			result = commonUtil.getJsonFromRestApi(restUrl, null, request, "post", param);
			status = result.get("status").toString();
		}
		
		if (status.equals("ok")) {
			
		}
		
		logger.debug("formSave ended.");         
	}
	
	/**
	 * 업무일지 양식관리 양식삭제 실행함수
	 */
	@RequestMapping(value = "/admin/ezJournal/deleteForm.do", produces="application/json;charset=UTF-8")
	@ResponseBody
	public void deleteForm (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("deleteForm started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String formId = request.getParameter("formId");
		String companyId = request.getParameter("companyId");
		String typeId = request.getParameter("typeId");
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("formId", formId);
		param.put("companyId", companyId);
		param.put("userId", userInfo.getId());
		
		String restUrl = "/rest/ezjournal/types/" + typeId + "/forms/" + formId;
		
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request, "delete", null);
		
		String status = result.get("status").toString();
		
		logger.debug("deleteForm ended.");
	}
	
}
