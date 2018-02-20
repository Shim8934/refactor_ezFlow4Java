package egovframework.ezEKP.ezLadder.web;

import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezCircular.service.EzCircularService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezLadder.service.EzLadderService;
import egovframework.ezEKP.ezLadder.vo.LadderVO;
import egovframework.ezEKP.ezSchedule.service.EzScheduleService;
import egovframework.ezMobile.ezApprovalG.web.MApprovalGController;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzLadderController {
//	@Autowired
//	private CommonUtil commonUtil;
//	
//	@Autowired
//	private Properties config;
//	
//	@Resource(name="loginService")
//	private LoginService loginService;
//	
//	@Resource(name = "EzBoardService")
//	private EzBoardService ezBoardService;
//	
//	@Resource(name = "EzCommonService")
//    private EzCommonService ezCommonService;
//	
//	@Resource(name="egovMessageSource")
//	private EgovMessageSource egovMessageSource;
//	
//	@Resource(name="EzLadderService")
//	private EzLadderService ezLadderService;
//	
//	@RequestMapping("/ezLadder/ladderList.do")
//	public String ladderList(Model model) throws Exception {
//		List<LadderVO> list = ezLadderService.getLadderList();
//		
//		model.addAttribute("list", list);
//		return "ezLadder/ezLadderMain";
//	}
	
	private static final Logger LOGGER = LoggerFactory.getLogger(EzLadderController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@Resource(name = "EzBoardService")
	private EzBoardService ezBoardService;
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzLadderService")
	private EzLadderService ezLadderService;
	
	@RequestMapping("/ezLadder/ladderMain.do")
	public String ladderList(@CookieValue("loginCookie") String loginCookie,ModelMap modelMap, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		
		LOGGER.debug("/ezLadder/ladderMain.do started.");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String gwServerUrl = config.getProperty("config.ladderGwServerURL");
		String url = gwServerUrl + "/ladder/list/" + userInfo.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		RestTemplate rest = new RestTemplate();
		
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		System.out.println(result.toString());
		
		JSONParser jp = new JSONParser();
		JSONObject jsonResult = (JSONObject) jp.parse(result.getBody());
		
		JSONArray list = new JSONArray();
		String status = jsonResult.get("status").toString();
		
	
		if (status.equals("ok")) {
			list = (JSONArray) jsonResult.get("data");
			
			model.addAttribute("list", list);
		} else {

			return "에러페이지라고 하면 될려나";
		}
		
		LOGGER.debug("/ezLadder/ladderMain.do ended.");

		return "ezLadder/ezLadderMain";
	}
}
