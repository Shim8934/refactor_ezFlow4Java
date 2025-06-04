package egovframework.ezEKP.ezJournal.web;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import egovframework.ezEKP.ezJournal.vo.JournalCompanyVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
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
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

import static egovframework.ezEKP.ezOrgan.vo.OrganAuth.AdminAuth;

/**
 * @Description [Controller] 업무일지 관리자
 * @author 오픈솔루션팀 박성빈
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2018.01.18    박성빈    신규작성
 *
 * @see
 */

@Controller
public class EzJournalAdminController {

	private static final Logger logger = LoggerFactory.getLogger(EzJournalAdminController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;

	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	/**
	 * 관리자 업무일지  메인 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezJournal/journalMain.do", method = RequestMethod.GET)
	public String portalMain(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("journalMain started");

		userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		logger.debug("journalMain ended");
		return "/admin/ezJournal/journalMain";
	}
	
	/**
	 * 관리자 업무일지  좌측 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezJournal/leftTop.do", method = RequestMethod.GET)
	public String leftTop(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("leftTop started");

		userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		logger.debug("leftTop ended");
		return "/admin/ezJournal/leftTop";
	}
	
	/**
	 * 관리자 일지함 관리
	 */
	@RequestMapping(value = "/admin/ezJournal/formType.do", method = RequestMethod.GET)
	public String formTypeManage(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("formType started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		HashMap<String, Object> param = new HashMap<String, Object>();
		String companyId =null;
		if (request.getParameter("companyId") != null) {
			companyId = request.getParameter("companyId");
		} else{
			companyId = userInfo.getCompanyID();
		}
		
		param.put("companyId",companyId);
		param.put("userId",userInfo.getId());

		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/types", param, request, "get", null);
		String status = resultBody.get("status").toString();

		if (status.equals("ok")) {		
			JSONArray typeList = (JSONArray) resultBody.get("data");
			model.addAttribute("typeList", typeList);
		}

		model.addAttribute("selectedCompany" , companyId);
		
		logger.debug("formType ended");
		return "admin/ezJournal/formType";
	}
	
	/**
	 * 관리자 일지함 사용여부 변경
	 */
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value = "/admin/ezJournal/updatreFormType.do", method = RequestMethod.POST)
	public JSONObject formTypeUpdate(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie){
		logger.debug("formTypeUpdate started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		JSONObject parameter = new JSONObject();
		parameter.put("companyId", request.getParameter("companyId"));
		parameter.put("userId", userInfo.getId());
		
		Map<String, String[]> paramMap = request.getParameterMap();
		JSONArray journaltypeList = new JSONArray();
		for(String key : paramMap.keySet()){
			if (key.contains("ezJournal")) {
				JSONObject type = new JSONObject();
				type.put("typeId", key);
				type.put("used", paramMap.get(key)[0]);
				journaltypeList.add(type);
			}
		}
		parameter.put("journaltypeList", journaltypeList);
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/types", null, request, "put", parameter);
		
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {		
		}
		
		logger.debug("formTypeUpdate ended");
		
		return resultBody;
	}
	
	/**
	 * 관리자 업무일지 양식리스트 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezJournal/form.do", method = RequestMethod.GET)
	public String formMain(HttpServletRequest request, ModelMap model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("formMain started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		Map<String, Object> param = new HashMap<String, Object>();

		String companyId = "";
		if (request.getParameter("companyId") != null) {
			companyId = request.getParameter("companyId");
		}

		param.put("userId", userInfo.getId());
		param.put("companyId", companyId);
		param.put("used", "use");

		String restUrl = "/rest/ezjournal/types";
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);

		String status = result.get("status").toString();
		
		String useJp = "";
		String useZh = "";
		String useId = "";
		String useVi = "";
		
		if (status.equals("ok")) {
			JSONArray typeList = (JSONArray) result.get("data");
			model.addAttribute("typeList", typeList);
			JSONArray useLangList = (JSONArray) result.get("useLangList");
			if (useLangList != null && !useLangList.isEmpty()) {
				JSONObject langInfo = (JSONObject) useLangList.get(0);
				useJp = (String) langInfo.get("useJP");
				useZh = (String) langInfo.get("useZh");
				useId = (String) langInfo.get("useId");
				useVi = (String) langInfo.get("useVi");
			}
		}

		model.addAttribute("useJp", useJp);
		model.addAttribute("useZh", useZh);
		model.addAttribute("useId", useId);
		model.addAttribute("useVi", useVi);
		model.addAttribute("selectedCompany" , companyId);
		logger.debug("formMain ended");
		return "/admin/ezJournal/formMain";
	}
	
	/**
	 * 관리자 업무일지 일지함의 양식리스트 가져오기
	 */
	@RequestMapping(value = "/admin/ezJournal/getFormList.do", method = RequestMethod.POST)
	public String getFormList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, Locale locale) {
		logger.debug("getFormList started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String typeId = request.getParameter("typeId");
		String companyId = request.getParameter("companyId");
	
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("companyId", companyId);
		param.put("userId", userInfo.getId());
		param.put("locale", locale);
		
		String restUrl = "/rest/ezjournal/types/" + typeId + "/forms";
		
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray formList = (JSONArray) result.get("data");
			model.addAttribute("formList", formList);
		//  logger.debug("formList : " + formList);
		}
		
		logger.debug("getFormList ended");
		return "/admin/ezJournal/formList";
	}
	
	/**
	 * 관리자 업무일지 양식등록 양식추가, 양식수정 화면호출함수
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezJournal/insertForm.do", method = RequestMethod.GET)
	public String insertForm(HttpServletRequest request, ModelMap model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("insertForm started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String companyId = request.getParameter("companyId");
		String typeId = request.getParameter("typeId");
		String useEditor = commonUtil.getTenantConfigRest("EDITOR", userInfo.getId(), request);
		
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
			/*System.out.println(typeList);*/
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
				JSONArray useDepts = null;
				if (jsonResult.get("depts") != null) {
					useDepts = (JSONArray) jsonResult.get("depts");
				}
				
				String formContent = jsonResult.get("formContent").toString();
				Gson gson = new Gson();
//				JournalFormInfoVO journalFormInfo = gson.fromJson(jsonResult.toString(), JournalFormInfoVO.class);
				model.addAttribute("formId", jsonResult.get("formId"));
				model.addAttribute("formName", jsonResult.get("formName"));
				model.addAttribute("formInfo", jsonResult.get("formInfo"));
				model.addAttribute("formContent", gson.toJson(formContent));
				model.addAttribute("useDepts", useDepts);
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
					state.put("opened", "true");
					dept.put("state", state);
				}
			}
			model.addAttribute("deptList", deptList);
		}
		
		logger.debug("insertForm ended");
		return "/admin/ezJournal/insertForm";
	}
	
	/**
	 * 업무일지 양식등록 양식등록,양식수정 양식작성기 저장 실행 함수
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezJournal/formSave.do", method = RequestMethod.POST)
	@ResponseBody
	public String formSave (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
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
		
		logger.debug("formName:" + formName + ",formDescript:" + formDescript + ",useDept:" + useDept + ",isDeptChanged:" + isDeptChanged);
		
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
		if (formId != null && !formId.trim().equals("")) {
			param.put("formId", formId);
			restUrl = "/rest/ezjournal/types/" + typeId + "/forms/" + formId;
			result = commonUtil.getJsonFromRestApi(restUrl, null, request, "put", param);
			status = result.get("status").toString();
		} else {
			restUrl = "/rest/ezjournal/types/" + typeId + "/forms";
			result = commonUtil.getJsonFromRestApi(restUrl, null, request, "post", param);
			status = result.get("status").toString();
		}
		
		logger.debug("formSave ended.");         
		return status;
	}
	
	/**
	 * 업무일지 양식관리 양식삭제 실행함수
	 */
	@RequestMapping(value = "/admin/ezJournal/deleteForm.do", method = RequestMethod.POST)
	@ResponseBody
	public String deleteForm (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
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
		return status;
	}	
	
	/**
	 * 관리자 열람 권한 관리
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezJournal/author.do", method = RequestMethod.GET)
	public String authorMain(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie){
		logger.debug("authorMain started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		HashMap<String, Object> param = new HashMap<String, Object>();
		String companyId =null;
		if (request.getParameter("companyId") != null) {
			companyId = request.getParameter("companyId");
		} else{
			companyId = userInfo.getCompanyID();
		}

		param.put("companyId",companyId);
		param.put("userId", userInfo.getId());

		/*System.out.println("companyId = "+companyId);*/
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/authors", param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {		
			JSONArray authList = (JSONArray) resultBody.get("data");
			for (int i = 0; i < authList.size(); i++) {				
				JSONObject jo = (JSONObject) authList.get(i);
				String [] authDeptArr = jo.get("authDept").toString().split("%");
				if (authDeptArr.length > 1) {
					jo.replace("authDept", commonUtil.cleanValue(authDeptArr[0]) + egovMessageSource.getMessage("ezJournal.t124", userInfo.getLocale()) + (authDeptArr.length - 1));
				} else {
					jo.replace("authDept", commonUtil.cleanValue(authDeptArr[0]));
				}
			}
			model.addAttribute("authList", authList);
		}

		model.addAttribute("selectedCompany" , companyId);
		logger.debug("authorMain ended");
		
		return "admin/ezJournal/author";
	}
	
	/**
	 * 열람권한 화면
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @return
	 */
	@RequestMapping(value="/admin/ezJournal/authorView.do", method = RequestMethod.GET)
	public String authorView(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie){
		logger.debug("authorView started");
		if (request.getParameter("userId")!=null) {
			logger.debug(request.getParameter("userId")+"dassfasdad"+request.getParameter("userName"));
			model.addAttribute("selectedUser", request.getParameter("userId"));
			model.addAttribute("selectedUserName", request.getParameter("userName"));
			
			JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/users/"+request.getParameter("userId")+"/author-depts?lang="+commonUtil.userInfo(loginCookie).getLang(), null, request,"get",null);
			
			String status = resultBody.get("status").toString();
			
			if (status.equals("ok")) {			
				JSONArray deptList = (JSONArray) resultBody.get("data");
				
				model.addAttribute("deptList", deptList);
			//	logger.debug("모델 어트리뷰트 확인" + model.containsAttribute("selectedUser"));
			}
		}
		model.addAttribute("companyId",request.getParameter("companyId"));
		
		logger.debug("authorView ended");
		
		return "admin/ezJournal/authorView";
	}
	
	/**
	 * 관리자 열람 권한 세부 리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezJournal/authorDetail.do", method = RequestMethod.GET)
	public String authorDetail(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie){
		logger.debug("authorDetail started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		String userId =null;
		if (request.getParameter("userId")!=null) {
			userId = request.getParameter("userId");
			model.addAttribute("selectedUser",userId.trim());
		}else{
			userId = userInfo.getId();
		}
		
		param.put("userId",userId);
		param.put("companyId", request.getParameter("companyId"));
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/depts", param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {			
			JSONArray deptList = (JSONArray) resultBody.get("data");
			
			for (int i = 0; i < deptList.size(); i++) {
				JSONObject dept =  (JSONObject) deptList.get(i);
				if (dept.get("isComp").equals("comp")) {
					dept.put("icon", "icon-company");
				} else{
					dept.put("icon", "icon-dept");
				}
				if (dept.get("myDept").equals("yes")) {
					JSONObject state = new JSONObject();
					state.put("opened", "true");
					state.put("selected", "true");
					dept.put("state", state);
				}
			}
			model.addAttribute("deptList", deptList);
			model.addAttribute("companyId",request.getParameter("companyId"));
		}
		logger.debug("authorDetail ended");
		
		return "admin/ezJournal/authorDetail";
	}
	
	/**
	 * 관리자 열람 권한 부서 선택하기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezJournal/selectAuthorDept.do", method = RequestMethod.GET)
	public String selectAuthorDept(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie){
		logger.debug("selectAuthorDept started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		String userId =null;
		if (request.getParameter("userId")!=null) {
			userId = request.getParameter("userId");
			model.addAttribute("selectedUser",userId.trim());
		}else{
			userId = userInfo.getId();
		}
		
		param.put("userId",userId);
		param.put("companyId", request.getParameter("companyId"));
		param.put("lang", commonUtil.userInfo(loginCookie).getLang());
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/depts", param, request,"get",null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {			
			JSONArray deptList = (JSONArray) resultBody.get("data");
			
			for (int i = 0; i < deptList.size(); i++) {
				JSONObject dept =  (JSONObject) deptList.get(i);
				if (dept.get("isComp").equals("comp")) {
					dept.put("icon", "icon-company");
				} else{
					dept.put("icon", "icon-dept");
				}
				if (dept.get("myDept").equals("yes")) {
					JSONObject state = new JSONObject();
					state.put("opened", "true");
					state.put("selected", "true");
					dept.put("state", state);
				}
			}
			model.addAttribute("deptList", deptList);
		}
		
		logger.debug("selectAuthorDept ended");
		
		return "admin/ezJournal/selectAuthorDept";
	}
	
	/**
	 * 사원리스트
	 */
	@RequestMapping(value = "/admin/ezJournal/userList.do", method = RequestMethod.POST)
	public String userList(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie){
		logger.debug("userList started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		String key = request.getParameter("key");
		param.put("key", key);
		param.put("value", request.getParameter("value"));
		param.put("userId", userInfo.getId());
		param.put("companyId", request.getParameter("companyId"));
		param.put("curPage", request.getParameter("curPage"));

		logger.debug("key : " + request.getParameter("key"));
		logger.debug("value : " + request.getParameter("value"));
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/users", param, request, "get", null);
		String status = resultBody.get("status").toString();
		if (status.equals("ok")) {		
			JSONArray userList = (JSONArray) resultBody.get("data");
			model.addAttribute("listType", request.getParameter("listType"));
			model.addAttribute("userList", userList);
			
			String keyword = "";
			if (key.equals("DEPARTMENT")) {
//				keyword = (String) ((JSONObject)userList.get(0)).get("deptName");
				keyword = request.getParameter("deptName");
			} else{
				keyword = egovMessageSource.getMessage("ezJournal.t170", userInfo.getLocale());
			}
			
			model.addAttribute("keyword",keyword);
			model.addAttribute("key", key);
			model.addAttribute("totalCount", resultBody.get("totalCount"));
			model.addAttribute("totalCount2", resultBody.get("totalCount2"));
			model.addAttribute("containLow", resultBody.get("containLow"));
		}
		
		logger.debug("userList ended");
		return "admin/ezJournal/userList";
	}
	
	/**
	 * 해당사원이 열람 할 수 있는 부서 리스트
	 */
	@RequestMapping(value = "/admin/ezJournal/authorDeptList.do", method = RequestMethod.POST)
	public String authorDeptList(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie){
		logger.debug("authorDeptList started");
		String userId = request.getParameter("userId");
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/users/"+userId+"/author-depts", null, request, "get", null);
		String status = resultBody.get("status").toString();
		if (status.equals("ok")) {		
			JSONArray authorDeptList = (JSONArray) resultBody.get("data");
			
			model.addAttribute("authorDeptList", authorDeptList);
		}
		
		logger.debug("authorDeptList ended");
		return "admin/ezJournal/authorDeptList";
	}
	
	/**
	 * 열람 권한 저장
	 * @param request
	 * @param loginCookie
	 * @param response
	 * @throws IOException 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezJournal/saveAuthor.do", method = RequestMethod.POST)
	@ResponseBody
	public String saveAuthor(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie) throws IOException{
		logger.debug("saveAuthor started");
		
		JSONObject jsonString = new JSONObject();
		String userId = request.getParameter("userId");
		String depts = request.getParameter("depts");
		jsonString.put("userId", userId);
		jsonString.put("depts", depts);
		jsonString.put("admin", "Y");
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/authors", null, request, "post", jsonString);
		
		String status = resultBody.get("status").toString();
		
		logger.debug("saveAuthor ended");
		return status;
	}
	
	/**
	 * 선택된 유저의 열람권한 부서 리스트 삭제
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping(value = "/admin/ezJournal/deleteAuthor.do", method = RequestMethod.POST)
	@ResponseBody
	public String deleteAuthor(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie) throws IOException{
		logger.debug("deleteAuthor started");
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", request.getParameter("userId"));
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/authors", param, request, "delete", null);
		String status = resultBody.get("status").toString();
		
		logger.debug("deleteAuthor ended");
		return status;
	}
	
	// 2025-05-30 황인경 - 업무일지 기본양식 다국어 처리 > 관리자 > 업무일지 > 양식관리 > select box 언어 선택 > 적용
	@RequestMapping(value = "/admin/ezJournal/journulListLangChanege.do", method = RequestMethod.POST)
	@ResponseBody
	public String journulListLangChanege(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie) throws IOException{
		logger.debug("journulListLangChanege started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId",userInfo.getId());

		String companyId = request.getParameter("companyId");
		String form_lang = request.getParameter("form_lang");
		param.put("companyId", companyId);
		param.put("form_lang",form_lang);
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/journulListLangChanege", param, request, "post", null);
		
		String status = resultBody.get("status").toString();
		
		logger.debug("journulListLangChanege ended");
		return status;
	}
}
