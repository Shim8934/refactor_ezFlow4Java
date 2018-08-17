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
	public String memoMain(@CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("memoMain started.");
		
		String brdID = "8";
		
		if (request.getParameter("brdID") != null) {
			brdID = request.getParameter("brdID");
		}
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/memo-list/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {			
		
		/*	JSONArray list = (JSONArray) resultBody.get("data");
			model.addAttribute("list", list);*/
			
		}
		
		
		logger.debug("memoMain ended");
		return "ezMemo/memoMain";
	}
	
	@RequestMapping(value = "/ezMemo/memoFolderManage.do")
	public String memoFolderManage(@CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, Model model) throws Exception {
		return "ezMemo/memoFolderManage";
	}
}
