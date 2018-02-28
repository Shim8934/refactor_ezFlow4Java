package egovframework.ezEKP.ezJournal.web;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;

import com.google.gson.Gson;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezJournal.vo.JournalFormInfoVO;
import egovframework.ezEKP.ezResource.vo.ResSelectFormIDVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.JsonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzJournalJYController {

	private static final Logger logger = LoggerFactory.getLogger(EzJournalJYController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Autowired
	private EzCommonService ezCommonService;
	
	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	/**
	 * 업무일지 작성 화면 호출
	 */
	@RequestMapping(value="/ezJournal/journalNewItem.do")
	public String journalNewItem(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("journalNewItem started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String mode = request.getParameter("mode");
		String typeId = request.getParameter("typeId");
		String hasAttach = "";
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("companyId", userInfo.getCompanyID());
		param.put("tenantId", userInfo.getTenantId());
		param.put("used", "use");
		
		String restUrl = "/restezjournal/types";
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray typeList = (JSONArray) result.get("data");
			model.addAttribute("typeList", typeList);
			System.out.println(typeList);
		}
		
		model.addAttribute("typeId", typeId);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("mode", mode);
		
		logger.debug("journalNewItem ended");
		
		return "/ezJournal/journalNewItem";
	}
	
	
	/**
	 * 업무일지 일지함의 양식리스트 가져오기
	 */
	@RequestMapping(value = "/ezJournal/getFormList.do")
	public String getFormList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) {
		logger.debug("getFormList started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String typeId = request.getParameter("typeId");
		if (typeId == null || typeId.equals("")) {
			typeId = "basic";
		}
		
		String companyId = userInfo.getCompanyID();
		String deptId = userInfo.getDeptID();
		int tenantId = userInfo.getTenantId();
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("companyId", companyId);
		param.put("tenantId", tenantId);
		param.put("deptId", deptId);
		
		String restUrl = "/restezjournal/types/" + typeId + "/forms";
		
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
	
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray formList = (JSONArray) result.get("data");
			model.addAttribute("formList", formList);
			logger.debug("formList : " + formList);
		}
		
		logger.debug("getFormList ended");
		return "/ezJournal/journalFormList";
	}
	
	/**
	 * 수신자 선택화면 호출
	 */
	@RequestMapping(value = "/ezJournal/selectReceiver.do")
	public String selectReceiver(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) {
		logger.debug("selectReceiver started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("tenantId", userInfo.getTenantId());
		param.put("companyId", userInfo.getCompanyID());
		
		JSONObject result = commonUtil.getJsonFromRestApi("/restezjournal/depts", param, request, "get", null);
		String status = result.get("status").toString();
		
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
			model.addAttribute("userId", userInfo.getId());
		}		
		logger.debug("selectReceiver ended");
		return "/ezJournal/journalSelectReceiver";
	}
	
	/**
	 * 수신자 즐겨찾기 저장 화면 호출 
	 */
	@RequestMapping(value = "/ezJournal/receiverLineName.do")
	public String receiverLineName(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) {
		logger.debug("receiverLineName started");
	
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("userId", userId);
		
		logger.debug("receiverLineName ended");
		return "/ezJournal/journalReceiverLineName";
	}
	
	/**
	 * 수신자 즐겨찾기 저장  
	 */
	@RequestMapping(value = "/ezJournal/saveReceiverFavorite.do")
	public String saveReceiverFavorite(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) {
		logger.debug("saveReceiverFavorite started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		
		String receiverList = request.getParameter("receiverLine");
		String favoriteName = request.getParameter("favoriteName");
		String type = request.getParameter("type");
		String favoriteId = request.getParameter("favoriteId");
		logger.debug("receiverLine : " + receiverList + ",favoriteName : " + favoriteName + ",type : " + type + ",favoriteId : " + favoriteId);
		
		JSONObject param = new JSONObject();
		
		param.put("userId", userId);
		param.put("tenantId", userInfo.getTenantId());
		param.put("favoriteName", favoriteName);
		param.put("receiverList", receiverList);
		param.put("favoriteId", favoriteId);
		
		String restUrl = "";
		JSONObject result = new JSONObject();
		
		if (type.trim().equals("mod")) {
			restUrl = "/restezjournal/users/" + userId + "/favorites/" + favoriteId;
			result = commonUtil.getJsonFromRestApi(restUrl, null, request, "put", param);
		} else {
			restUrl = "/restezjournal/users/" + userId + "/favorites";
			result = commonUtil.getJsonFromRestApi(restUrl, null, request, "post", param);
		}
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			
		}
		
		logger.debug("saveReceiverFavorite ended");
		return "json";
	}
	
	/**
	 * 수신자 즐겨찾기 리스트 가져오기
	 */
	@RequestMapping(value = "/ezJournal/getFavoriteList.do")
	public String getFavoriteList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) {
		logger.debug("getFavoriteList started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = request.getParameter("userId");
		if (userId == null || userId.equals("")) {
			userId = userInfo.getId();
		}
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("tenantId", userInfo.getTenantId());
		
		String restUrl = "/restezjournal/users/" + userId + "/favorites";
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray favoriteList = (JSONArray) result.get("data");
			model.addAttribute("favoriteList", favoriteList);
			logger.debug("favoriteList : " + favoriteList);
		}
		
		logger.debug("getFavoriteList started");
		return "/ezJournal/journalFavoriteList";
	}
	
	/**
	 * 즐겨찾기 아이디에 해당하는 수신자 리스트 가져오기
	 */
	@RequestMapping(value = "/ezJournal/getFavoriteUser.do")
	public String getFavoriteUser(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) {
		logger.debug("getFavoriteUser started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = request.getParameter("userId");
		if (userId == null || userId.equals("")) {
			userId = userInfo.getId();
		}
		String favoriteId = request.getParameter("favoriteId");
		logger.debug("favoriteId : " + favoriteId);
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("tenantId", userInfo.getTenantId());
		
		String restUrl = "/restezjournal/users/" + userId + "/favorites/" + favoriteId + "/users";
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray userList = (JSONArray) result.get("data");
			model.addAttribute("userList", userList);
			logger.debug("userList : " + userList);
		}
		logger.debug("getFavoriteUser ended");
		return "/ezJournal/journalFavoriteUser";
	}
	
	/**
	 * 즐겨찾기 수신자 적용
	 */
	@RequestMapping(value = "/ezJournal/applyFavoriteUser.do")
	@ResponseBody
	public String applyFavoriteUser(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) {
		logger.debug("applyFavoriteUser started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = request.getParameter("userId");
		if (userId == null || userId.equals("")) {
			userId = userInfo.getId();
		}
		String favoriteId = request.getParameter("favoriteId");
		logger.debug("favoriteId : " + favoriteId);
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("tenantId", userInfo.getTenantId());
		
		String restUrl = "/restezjournal/users/" + userId + "/favorites/" + favoriteId + "/users";
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray userList = (JSONArray) result.get("data");
			logger.debug("userList : " + userList);
			return JsonUtil.ListToJson(userList);
		}
		logger.debug("applyFavoriteUser ended");
		return JsonUtil.OneStringToJson("json");
	}
	
	/**
	 * 즐겨찾기 삭제
	 */
	@RequestMapping(value = "/ezJournal/deleteFavorite.do")
	@ResponseBody
	public String deleteFavorite(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) {
		logger.debug("deleteFavorite started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = request.getParameter("userId");
		if (userId == null || userId.equals("")) {
			userId = userInfo.getId();
		}
		String favoriteId = request.getParameter("favoriteId");
		logger.debug("favoriteId : " + favoriteId);
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("tenantId", userInfo.getTenantId());
		
		String restUrl = "/restezjournal/users/" + userId + "/favorites/" + favoriteId;
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request, "delete", null);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			
		}
		logger.debug("deleteFavorite ended");
		return JsonUtil.OneStringToJson("json");
	}
	
	/**
	 * 업무일지 양식 폼 호출
	 */
	@RequestMapping(value = "/ezJournal/journalGetForm.do", produces="application/json; charset=utf-8")
	@ResponseBody
	public String journalGetForm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("journalGetForm started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String formId = request.getParameter("formId");
		String typeId = request.getParameter("typeId");
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("tenantId", userInfo.getTenantId());
		param.put("companyId", userInfo.getCompanyID());
		
		String restUrl = "/restezjournal/types/" + typeId + "/forms/" + formId;
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONObject jsonResult = (JSONObject) result.get("data");
			param.clear();
			param.put("formName", jsonResult.get("formName"));
			param.put("formContent", jsonResult.get("formContent"));
			logger.debug("resultparam 확인 : " + param);
			return JsonUtil.MapToJson(param);
		}

		logger.debug("journalGetForm ended");
		return JsonUtil.OneStringToJson("json");
	}
	
	/**
	 * 업무일지 마지막 사용양식 아이디 가져오기
	 */
	@RequestMapping(value = "/ezJournal/journalGetLastForm.do", produces="application/json; charset=utf-8")
	@ResponseBody
	public String journalGetLastForm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("journalGetLastForm started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String formId = "last";
		String typeId = request.getParameter("typeId");
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("tenantId", userInfo.getTenantId());
		param.put("companyId", userInfo.getCompanyID());
//		param.put("userId", userInfo.getId());
		param.put("userId", "sbpark14");
		
		String restUrl = "/restezjournal/types/" + typeId + "/forms/" + formId;
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			String lastId = result.get("data").toString();
			logger.debug("lastFormId : " + lastId);
			return JsonUtil.OneStringToJson(lastId);
		}
		
		logger.debug("journalGetLastForm ended");
		return JsonUtil.OneStringToJson("json");
	}
}
