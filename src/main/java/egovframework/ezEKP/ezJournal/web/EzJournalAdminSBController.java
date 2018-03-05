package egovframework.ezEKP.ezJournal.web;

import java.io.IOException;
import java.util.HashMap;
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
import org.springframework.jdbc.core.support.SqlLobValue;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzJournalAdminSBController {

	private static final Logger logger = LoggerFactory.getLogger(EzJournalAdminController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	/**
	 * 관리자 일지함 관리
	 */
	@RequestMapping(value = "/admin/ezJournal/formType.do")
	public String formTypeManage(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse response) throws Exception {
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
		param.put("userId", userInfo.getId());
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/companies", param, request,"get",null);
		String status = resultBody.get("status").toString();
			
		if (status.equals("ok")) {			
			JSONArray compList = (JSONArray) resultBody.get("data");
			model.addAttribute("compList", compList);
		}
		
		param.put("userId",userInfo.getId() );
		
		resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/types", param, request,"get",null);
		status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {		
			JSONArray typeList = (JSONArray) resultBody.get("data");
			model.addAttribute("typeList", typeList);
		}
		
		logger.debug("formType ended");
		return "admin/ezJournal/formType";
	}
	
	/**
	 * 관리자 일지함 사용여부 변경
	 */
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value = "/admin/ezJournal/updatreFormType.do")
	public JSONObject formTypeUpdate(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse response){
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
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/types", null, request,"put",parameter);
		
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {		
		}
		
		logger.debug("formTypeUpdate ended");
		
		return resultBody;
	}
	
	
	/**
	 * 관리자 열람 권한 관리
	 */
	@RequestMapping(value = "/admin/ezJournal/author.do")
	public String authorMain(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse response){
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
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/companies", param, request,"get",null);
		String status = resultBody.get("status").toString();
			
		if (status.equals("ok")) {			
			JSONArray compList = (JSONArray) resultBody.get("data");
			model.addAttribute("compList", compList);
		}
		
		System.out.println("companyId = "+companyId);
		resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/authors", param, request,"get",null);
		status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {		
			JSONArray authList = (JSONArray) resultBody.get("data");
			for (int i = 0; i < authList.size(); i++) {				
				JSONObject jo = (JSONObject) authList.get(i);
				String [] authDeptArr = jo.get("authDept").toString().split("%");
				if (authDeptArr.length>1) {
					jo.replace("authDept", authDeptArr[0]+" 외 "+(authDeptArr.length-1));
				}
			}
			model.addAttribute("authList", authList);
		}
		
		logger.debug("authorMain ended");
		
		return "admin/ezJournal/author";
	}
	
	/**
	 * 열람권한 화면
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/admin/ezJournal/authorView.do")
	public String authorView(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse response){
		logger.debug("authorView started");
		if (request.getParameter("userId")!=null) {
			logger.debug(request.getParameter("userId")+"dassfasdad"+request.getParameter("userName"));
			model.addAttribute("selectedUser", request.getParameter("userId"));
			model.addAttribute("selectedUserName", request.getParameter("userName"));
			
			JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/users/"+request.getParameter("userId")+"/author-depts", null, request,"get",null);
			
			String status = resultBody.get("status").toString();
			
			if (status.equals("ok")) {			
				JSONArray deptList = (JSONArray) resultBody.get("data");
				
				model.addAttribute("deptList", deptList);
				logger.debug("모델 어트리뷰트 확인"+model.containsAttribute("selectedUser"));
			}
		}
		model.addAttribute("companyId",request.getParameter("companyId"));
		
		logger.debug("authorView ended");
		
		return "admin/ezJournal/authorView";
	}
	
	/**
	 * 관리자 열람 권한 세부 리스트
	 */
	@RequestMapping(value = "/admin/ezJournal/authorDetail.do")
	public String authorDetail(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse response){
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
		
		logger.debug("authorDetail ended");
		
		return "admin/ezJournal/authorDetail";
	}
	
	/**
	 * 관리자 열람 권한 부서 선택하기
	 */
	@RequestMapping(value = "/admin/ezJournal/selectAuthorDept.do")
	public String selectAuthorDept(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse response){
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
		
//		logger.debug(request.getParameter("userId")+"dassfasdad");
//		model.addAttribute("selectedUser", userId);
//		
//		resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/users/"+userId+"/author-depts", null, request,"get",null);
//		
//		status = resultBody.get("status").toString();
//		
//		if (status.equals("ok")) {			
//			JSONArray deptList = (JSONArray) resultBody.get("data");
//			
//			model.addAttribute("authDeptList", deptList);
//		}
		
		logger.debug("selectAuthorDept ended");
		
		return "admin/ezJournal/selectAuthorDept";
	}
	
	/**
	 * 사원리스트
	 */
	@RequestMapping(value = "/admin/ezJournal/userList.do")
	public String userList(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse response){
		logger.debug("userList started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		String key = request.getParameter("key");
		param.put("key",key );
		param.put("value", request.getParameter("value"));
		param.put("userId", userInfo.getId());
		logger.debug(request.getParameter("key"));
		logger.debug(request.getParameter("value"));
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/users", param, request,"get",null);
		String status = resultBody.get("status").toString();
		if (status.equals("ok")) {		
			JSONArray userList = (JSONArray) resultBody.get("data");
			
			model.addAttribute("userList", userList);
			
			String keyword = "";
			if (key.equals("DEPARTMENT") && userList.size()!=0) {
				keyword = (String) ((JSONObject)userList.get(0)).get("deptName");
			} else{
				keyword = "검색";
			}
			logger.debug("키워드키워드키우드***********"+keyword);
			int userCount = 0;
			if (userList.size()==0) {
				keyword = "결과없음";
			} else {
				userCount = userList.size();
			}
			model.addAttribute("keyword",keyword);
			model.addAttribute("userCount",userCount);
		}
		
		logger.debug("userList ended");
		return "admin/ezJournal/userList";
	}
	
	/**
	 * 해당사원이 열람 할 수 있는 부서 리스트
	 */
	@RequestMapping(value = "/admin/ezJournal/authorDeptList.do")
	public String authorDeptList(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse response){
		logger.debug("authorDeptList started");
		String userId = request.getParameter("userId");
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/users/"+userId+"/author-depts", null, request,"get",null);
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
	 * @param model
	 * @param loginCookie
	 * @param response
	 * @throws IOException 
	 */
	@RequestMapping(value = "/admin/ezJournal/saveAuthor.do")
	public void saveAuthor(@RequestBody JSONObject jsonString,HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse response) throws IOException{
		logger.debug("saveAuthor started");
		
		String result = "";
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/authors", null, request,"post",jsonString);
		
		String status = resultBody.get("status").toString();
		if (status.equals("ok")) {	
			result="save complete";
		} else {
			result="save failed";
		}
		
		logger.debug("saveAuthor ended");
		response.getWriter().println(result);
	}
	
	/**
	 * 선택된 유저의 열람권한 부서 리스트 삭제
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping(value = "/admin/ezJournal/deleteAuthor.do")
	public void deleteAuthor(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse response) throws IOException{
		logger.debug("deleteAuthor started");
		
		String result = "";
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("userId", request.getParameter("userId"));
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/authors", param, request,"delete",null);
		
		String status = resultBody.get("status").toString();
		if (status.equals("ok")) {	
			result="delete complete";
		} else {
			result="delete failed";
		}
		
		logger.debug("deleteAuthor ended");
		response.getWriter().println(result);
	}
}
