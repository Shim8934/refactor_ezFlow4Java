package egovframework.ezEKP.ezMemo.web;

import java.util.HashMap;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;









import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezLadder.web.EzLadderController;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzMemoController {
	private static final Logger logger = LoggerFactory.getLogger(EzMemoController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	private SimpMessagingTemplate template;
	
	/**
	 * 메모 호출
	 * */
	@RequestMapping(value = "/ezMemo/memoMain.do")
	public String memoMain(String order, String searchInput, String startDate, String endDate, @CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("memoMain started.");
		
		String brdID = "8";
		order = order != null ? order : "0";		// 메모함 선택
		searchInput = searchInput != null ? searchInput : "";		// 검색 사용 시 검색 단어
		startDate = startDate != null ? startDate : "";				// 검색 사용 시 시작일
		endDate = endDate != null ? endDate : "";					// 검색 사용 시 종료일
		
		if (request.getParameter("brdID") != null) {
			brdID = request.getParameter("brdID");
		}
		
		logger.debug("order : " + order + ", searchInput : " + searchInput + ", startDate : " + startDate + ", endDate : " + endDate);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("company_id",userInfo.getCompanyID());
		param.put("tenant_id", userInfo.getTenantId());
		param.put("user_Id",userInfo.getId());
		param.put("order", order);
		param.put("searchInput", searchInput);
		param.put("startDate", startDate);
		param.put("endDate", endDate);
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/memo-list/users/" + userInfo.getId(), param, request, "get", null);		
		
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {		
				JSONArray memoList = (JSONArray) resultBody.get("memoList");
				
				model.addAttribute("memoList", memoList);
		}
		
		
		logger.debug("memoMain ended");
		return "ezMemo/memoMain";
	}
	
	@RequestMapping(value = "/ezMemo/getMemoFoldersInfo.do")
	public String memoFoldersInfo(@CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("memoFoldersInfo started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("company_id",userInfo.getCompanyID());
		param.put("user_Id",userInfo.getId());
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/folders/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBody.get("status").toString();
		String memoCount = resultBody.get("memoCount").toString();
		if (status.equals("ok")) {		
				JSONArray folders = (JSONArray) resultBody.get("data");
				model.addAttribute("folders", folders);
				model.addAttribute("memoCount", memoCount);
		}
			
		logger.debug("memoFoldersInfo ended");
		return "json";
	}
	
	@RequestMapping(value = "/ezMemo/memoFolderManage.do")
	public String memoFolderManage(@CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, Model model) throws Exception {
		return "ezMemo/memoFolderManage";

	}
	
	@RequestMapping(value = "/ezMemo/memoRead.do")
	public String memoDetailView(@CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("memoRead started.");
		
		logger.debug("memoRead ended.");
		return "ezMemo/memoRead";

	}
}
