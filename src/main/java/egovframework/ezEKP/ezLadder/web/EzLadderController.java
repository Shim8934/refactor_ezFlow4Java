package egovframework.ezEKP.ezLadder.web;


import java.util.Arrays;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
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
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezLadder.service.EzLadderService;
import egovframework.ezEKP.ezLadder.vo.LadderBmUserVO;
import egovframework.ezEKP.ezLadder.vo.LadderBmVO;
import egovframework.ezEKP.ezLadder.vo.LadderLineVO;
import egovframework.ezEKP.ezLadder.vo.LadderOrderVO;
import egovframework.ezEKP.ezLadder.vo.LadderVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzLadderController {
	private static final Logger logger = LoggerFactory.getLogger(EzLadderController.class);
	
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
	
	@Resource(name="EzLadderService")
	private EzLadderService ezLadderService;
	
	@Autowired
	private SimpMessagingTemplate template;
	
	/**
	 * 사다리게임 메인 화면 호출 함수
	 */
	@RequestMapping(value="/ezLadder/ladderMainPage.do", method=RequestMethod.GET)
	public String qstMain(HttpServletRequest request, Model model) throws Exception{
		logger.debug("ladderMainPage Start");

		String leftFrameWidth = "220";
		int width = 0;

		if (request.getParameter("__wwidth") != null) {
			String widthParam = request.getParameter("__wwidth");

			try {
				width = Integer.parseInt(widthParam);

				leftFrameWidth = width < 1180 ? "0" : "220";
			} catch (NumberFormatException e) {
				width = 0;
			}
		}

		model.addAttribute("leftFrameWidth", leftFrameWidth);
		
		logger.debug("ladderMainPage End");
		return "/ezLadder/ladderMainPage";
	}
	
	/**
	 * 사다리게임 레프트 메뉴 화면 호출 함수
	 */
	@RequestMapping(value="/ezLadder/ladderLeft.do", method=RequestMethod.GET)
	public String qstLeft() throws Exception{
		logger.debug("ladderLeft Start");
		
		logger.debug("ladderLeft End");
		return "/ezLadder/ladderLeft";
	}
	
	/**
	 * 사다리 게임 호출
	 * */
	@RequestMapping(value = "/ezLadder/ladderMain.do", method=RequestMethod.GET)
	public String ladderMain(String mode, String currPage, String searchSelect, String searchInput, String sort, String sortFlag, String searching, @CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("ladderMain started.");
		
		String brdID = "7";
		
		if (request.getParameter("brdID") != null) {
			brdID = request.getParameter("brdID");
		}
		mode = mode != null ? mode : "all";
		currPage = currPage != null ? currPage : "1";
		searchSelect = searchSelect != null ? commonUtil.stripScriptTagsAndFunctions(searchSelect) : "";
		searchInput = searchInput != null ? searchInput : "";
		searching = searching != null ? searching : "";
		sort = sort != null ? sort : "basic";
		sortFlag = sortFlag != null ? sortFlag : "desc";
	
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String gwServerUrl = config.getProperty("config.ladderGwServerURL");
		String url = gwServerUrl + "/rest/ladder/ladder-list/users/" + userInfo.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		RestTemplate rest = new RestTemplate();
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
									.queryParam("tenant_id", userInfo.getTenantId())
									.queryParam("mode", mode)
									.queryParam("currPage", currPage)
									.queryParam("searchSelect", searchSelect)
									.queryParam("searchInput", searchInput)
									.queryParam("offset", userInfo.getOffset())
									.queryParam("lang", userInfo.getLang())
									.queryParam("sort", sort)
									.queryParam("sortFlag", sortFlag)
									.queryParam("companyID", userInfo.getCompanyID());
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);

		JSONParser jp = new JSONParser();
		JSONObject jsonResult = (JSONObject) jp.parse(result.getBody());
		
		JSONArray list = new JSONArray();
		String status = jsonResult.get("status").toString();
		String page = jsonResult.get("currPage").toString();
		String totalLadder = jsonResult.get("totalLadder").toString();
		String totalPage = jsonResult.get("totalPage").toString();
	
		searchInput = searchInput.replace("\\","\\\\");
		searchInput = searchInput.replace("\"", "\\" + "\"");
		
		if (status.equals("ok")) {
			list = (JSONArray) jsonResult.get("data");
			model.addAttribute("id", userInfo.getId());
			model.addAttribute("list", list);
			model.addAttribute("currPage", page);
			model.addAttribute("totalPage", totalPage);
			model.addAttribute("totalLadder", totalLadder);
			model.addAttribute("mode", mode);
			model.addAttribute("searchSelect", searchSelect);
			model.addAttribute("searchInput", searchInput);
			model.addAttribute("searching", searching);
			model.addAttribute("sort", sort);
			model.addAttribute("sortFlag", sortFlag);
			model.addAttribute("brdID", brdID);
		} else {
			return "error";
		}
		
		String retJSP = "";
		if(mode.equals("pre")) {
			if(searchSelect.equals("")) {
				retJSP = "ezLadder/ladderPreList";
			} else {
				retJSP = "json";
			}
		} else {
			retJSP = "ezLadder/ladderMain";
		}
		
		logger.debug("ladderMain ended.");
		
		return retJSP;
	}
	
	/**
	 * 사다리 게임 종류 선택
	 * */
	@RequestMapping(value = "/ezLadder/selectLadderType.do", method=RequestMethod.GET)
	public String ladderTypeView() {
		logger.debug("selectLadderType started.");
		logger.debug("selectLadderType ended.");
		
		return "ezLadder/selectLadderType";
	}
	
	/**
	 * 사다리 게임 설정 작성
	 * */
	@RequestMapping(value = "/ezLadder/setLadder.do", method = RequestMethod.GET)
	public String setLadderView(String type, String ladderId, Model model) throws Exception {
		logger.debug("setLadder started.");
		
		model.addAttribute("ladType", commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(type)));
		model.addAttribute("ladderId", ladderId);
		
		logger.debug("setLadder ended.");
		
		return "ezLadder/setLadder";
	}
	
	/** 
	 * 참여자 추가 (조직도 호출)
	 * */
	@RequestMapping(value = "/ezLadder/setLadderAttendantPopUp.do", method=RequestMethod.GET)
	public String setLadderAttendantPopUp(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception{
		logger.debug("setLadderAttendantPopUp started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
		
		model.addAttribute("userID", userInfo.getId());
		model.addAttribute("deptID", userInfo.getDeptID());
		model.addAttribute("companyID", userInfo.getCompanyID());
		model.addAttribute("domainName", domainName);
		model.addAttribute("primaryLang", primaryLang);
		
		logger.debug("setLadderAttendantPopUp ended.");
		
		return "ezLadder/ladderSetAttendant";
	}
	
	/**
	 * 사다리 게이머 바로 추가
	 * @throws ParseException 
	 * */
	@RequestMapping(value = "/ezLadder/setLadderAttendant.do", method=RequestMethod.POST)
	public String setLadderAttendant(@CookieValue("loginCookie") String loginCookie, String [] searchUserName, HttpServletRequest request, Model model) throws ParseException {
		logger.debug("setLadderAttendant started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String gwServerUrl = config.getProperty("config.ladderGwServerURL");
		String url = gwServerUrl + "/rest/ladder/ladders/writers/" + userInfo.getId() + "/searchUser";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(searchUserName, headers);
		
		RestTemplate rest = new RestTemplate();
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("tenant_id", userInfo.getTenantId())
				.queryParam("lang", userInfo.getLang())
				.queryParam("companyID", userInfo.getCompanyID());
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject jsonResult = (JSONObject) jp.parse(result.getBody());
		
		String status = jsonResult.get("status").toString();
		JSONArray resultSearchName = (JSONArray) jsonResult.get("data");
	
		if (status.equals("ok")) {
			model.addAttribute(resultSearchName);
		} else {
			return "error";
		}
		
		logger.debug("setLadderAttendant ended.");
		
		return "json";
	}
	
	/**
	 * 사다리 게임 추가 
	 * @throws Exception 
	 * */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezLadder/setLadder.do", method = RequestMethod.POST)
	public String setLadder(@CookieValue("loginCookie") String loginCookie, String title, String type, String secretFlag, String lineCnt, 
			String [] userIds, String [] userNames, String [] userName2s, String [] items,  String[] description, String[] description2,
			LadderVO ladVO, LadderLineVO ladLineVO, HttpServletRequest request, Model model) throws Exception {
		logger.debug("setLadder started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String gwServerUrl = config.getProperty("config.ladderGwServerURL");
		String url = gwServerUrl + "/rest/ladder/ladders/writers/" + userInfo.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		JSONObject jsonBodys = new JSONObject();
		jsonBodys.put("title", title);
		jsonBodys.put("type", type);
		jsonBodys.put("secretFlag", secretFlag);
		jsonBodys.put("lineCnt", lineCnt);
		jsonBodys.put("userIds", userIds);
		jsonBodys.put("userNames", userNames);
		jsonBodys.put("userName2s", userName2s);
		jsonBodys.put("descriptions", description);
		jsonBodys.put("descriptions2", description2);
		jsonBodys.put("items", items);
		jsonBodys.put("loginCookie", loginCookie);
		
		HttpEntity<?> entity = new HttpEntity<>(jsonBodys, headers);
		
		RestTemplate rest = new RestTemplate();
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("tenant_id", userInfo.getTenantId())
				.queryParam("lang", userInfo.getLang());
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject jsonResult = (JSONObject) jp.parse(result.getBody());
		
		String status = jsonResult.get("status").toString();
	
		if (!status.equals("ok")) {
			return "error";
		}
		
		logger.debug("setLadder ended.");
		
		return "redirect:/ezLadder/ladderMain.do?brdID=7";
	}
	
	/**
	 * 즐겨찾기 조회
	 * @throws Exception 
	 * */
	@RequestMapping(value = "/ezLadder/getLadderBM.do", method=RequestMethod.GET)
	public String getLadderBM(@CookieValue("loginCookie") String loginCookie, String ladderBmId, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getLadderBM started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);

		String gwServerUrl = config.getProperty("config.ladderGwServerURL");
		String url = "";
		
		if(ladderBmId == null || ladderBmId.equals("")) {
			url = gwServerUrl + "/rest/ladder/BMs/users/" + userInfo.getId();
		} else {
			url = gwServerUrl + "/rest/ladder/BMs/" + ladderBmId + "/users/" + userInfo.getId();
		}
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		RestTemplate rest = new RestTemplate();
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("tenant_id", userInfo.getTenantId())
				.queryParam("offset", userInfo.getOffset())
				.queryParam("lang", userInfo.getLang())
				.queryParam("companyID", userInfo.getCompanyID());
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);

		JSONParser jp = new JSONParser();
		JSONObject jsonResult = (JSONObject) jp.parse(result.getBody());
		
		JSONArray list = new JSONArray();
		String status = jsonResult.get("status").toString();
	
		if (status.equals("ok")) {
			list = (JSONArray) jsonResult.get("data");
			
			model.addAttribute("bmList", list);
		} else {
			return "error";
		}
		
		logger.debug("getLadderBM ended.");
		return "json";
	}
	
	/**
	 * 확인 팝업창들
	 * */
	@RequestMapping(value = "/ezLadder/ladderPopup.do", method=RequestMethod.GET)
	public String ladderPopup(String popupType, Model model) {
		logger.debug("ladderPopup started.");
		
		model.addAttribute("popupType", popupType);
		
		logger.debug("ladderPopup ended.");
		
		return "ezLadder/ladderPopup";
	}
	
	/**
	 * 즐겨찾기 추가, 수정, 삭제
	 * @throws Exception 
	 * */
	@RequestMapping(value = "/ezLadder/setLadderBM.do", method = RequestMethod.POST)
	public String setLadderBM(@CookieValue("loginCookie") String loginCookie, 
			LadderBmVO BMVO, LadderBmUserVO BMUserVO, String flag,
			HttpServletRequest request, Model model) throws Exception {
		logger.debug("setLadderBM started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String gwServerUrl = config.getProperty("config.ladderGwServerURL");
		String url = "";
		
		if(flag.equals("add")) {
			url = gwServerUrl + "/rest/ladder/BMs/users/" + userInfo.getId();
		} else {
			url = gwServerUrl + "/rest/ladder/BMs/" + BMVO.getLadderBmId() + "/users/" + userInfo.getId();
		}
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		RestTemplate rest = new RestTemplate();
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("tenant_id", userInfo.getTenantId())
				.queryParam("bmName", BMVO.getBmName())
				.queryParam("writerId", userInfo.getId())
				.queryParam("userIds", (Object[]) BMUserVO.getUserIds())
				.queryParam("userNames", (Object[]) BMUserVO.getUserNames())
				.queryParam("userName2s", (Object[]) BMUserVO.getUserName2s())
				.queryParam("lang", userInfo.getLang())
				.queryParam("offset", userInfo.getOffset())
				.queryParam("companyID", userInfo.getCompanyID())
				.queryParam("descriptions", (Object[]) BMUserVO.getDescriptions())
				.queryParam("descriptions2", (Object[]) BMUserVO.getDescriptions2());
		
		ResponseEntity<String> result = null;
		
		if(flag.equals("add")) {
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		} else if(flag.equals("modify")) {
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
		} else if(flag.equals("delete")){
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.DELETE, entity, String.class);
		}
		
		if (result != null) {
			JSONParser jp = new JSONParser();
			JSONObject jsonResult = (JSONObject) jp.parse(result.getBody());
			
			String status = jsonResult.get("status").toString();
		
			if (status.equals("ok")) {
				model.addAttribute("status", status);
			} else {
				return "error";
			}
		}
		
		logger.debug("getLadderBM ended.");
		
		return "json";
	}
	
	/**
	 * 추가, 수정 한 댓글 조회
	 * @throws Exception 
	 * */
	@RequestMapping(value = "/ezLadder/getLadderComment.do", method=RequestMethod.GET)
	public String getLadderComment(@CookieValue("loginCookie") String loginCookie, String ladderId, String commentId, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getLadderComment started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie); 

		String gwServerUrl = config.getProperty("config.ladderGwServerURL");
		String url = gwServerUrl + "/rest/ladder/ladders/" + ladderId + "/comment/users/" + userInfo.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		RestTemplate rest = new RestTemplate();
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("tenant_id", userInfo.getTenantId())
				.queryParam("id", commentId)
				.queryParam("offset", userInfo.getOffset())
				.queryParam("lang", userInfo.getLang());
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject jsonResult = (JSONObject) jp.parse(result.getBody());
		
		String status = jsonResult.get("status").toString();
	
		if (status.equals("ok")) {
			model.addAttribute("myComment", (JSONObject) jsonResult.get("data"));
		} else {
			return "error";
		}
		
		logger.debug("getLadderComment ended.");
		
		return "json";
	}

	/**
	 * 댓글 추가, 수정, 삭제
	 * @throws Exception 
	 * */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezLadder/setLadderComment.do", method = RequestMethod.POST)
	public String setLadderComment(@CookieValue("loginCookie") String loginCookie, String flag, String commentId, String ladderId, String comment, HttpServletRequest request, Model model) throws Exception {
		logger.debug("setLadderComment started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);

		String gwServerUrl = config.getProperty("config.ladderGwServerURL");
		String url = gwServerUrl + "/rest/ladder/ladders/" + ladderId + "/comment/users/" + userInfo.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		JSONObject jsonBodys = new JSONObject();
		jsonBodys.put("commentId", commentId);
		jsonBodys.put("comment", comment);
		jsonBodys.put("loginCookie", loginCookie);
		
		HttpEntity<?> entity = new HttpEntity<>(jsonBodys, headers);
		
		RestTemplate rest = new RestTemplate();
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("tenant_id", userInfo.getTenantId())
				.queryParam("lang", userInfo.getLang())
				.queryParam("offset", userInfo.getOffset());
		
		ResponseEntity<String> result = null;
		
		String retDestination = "";
		if(flag.equals("add")) {
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
			retDestination = "/lad/cmt/addCmt/" + ladderId;
		} else if(flag.equals("modify")) {
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
			retDestination = "/lad/cmt/modifyCmt/" + ladderId;
		} else if(flag.equals("delete")) {
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.DELETE, entity, String.class);
			retDestination = "/lad/cmt/deleteCmt/" + ladderId;
		}

		if (result != null) {
			JSONParser jp = new JSONParser();
			JSONObject jsonResult = (JSONObject) jp.parse(result.getBody());
			
			String status = jsonResult.get("status").toString();
		
			if (status.equals("ok")) {
				model.addAttribute("status", status);
				
				JSONObject commentInfo = new JSONObject();
				commentInfo.put("flag", flag);
				commentInfo.put("commentId", commentId);
				
				this.template.convertAndSend(retDestination, commentInfo);
			} else {
				return "error";
			}
		}
		
		logger.debug("setLadderComment ended.");
		
		return "json";
	}
	
	/**
	 * 이전 사다리 목록 순서 바꾸기
	 * @throws Exception 
	 * */
	@RequestMapping(value = "/ezLadder/setListOrder.do", method=RequestMethod.POST)
	public String setListOrder(@CookieValue("loginCookie") String loginCookie, LadderOrderVO ladOrderVO, String mode, String currPage, String searchSelect, String searchInput, HttpServletRequest request, Model model) throws Exception {
		logger.debug("setListOrder started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String gwServerUrl = config.getProperty("config.ladderGwServerURL");
		String url = gwServerUrl + "/rest/ladder/ladder-list/users/" + userInfo.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		RestTemplate rest = new RestTemplate();
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("tenant_id", userInfo.getTenantId())
				.queryParam("ladderIds", (Object[]) ladOrderVO.getLadderIds())
				.queryParam("changeLadderIds", (Object[]) ladOrderVO.getChangeLadderIds())
				.queryParam("mode", mode)
				.queryParam("currPage", currPage)
				.queryParam("searchSelect", searchSelect)
				.queryParam("searchInput", searchInput)
				.queryParam("offset", userInfo.getOffset())
				.queryParam("lang", userInfo.getLang())
				.queryParam("companyID", userInfo.getCompanyID());
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);

		JSONParser jp = new JSONParser();
		JSONObject jsonResult = (JSONObject) jp.parse(result.getBody());
		
		JSONArray list = new JSONArray();
		String status = jsonResult.get("status").toString();
	
		if (status.equals("ok")) {
			list = (JSONArray) jsonResult.get("data");
			
			model.addAttribute("list", list);
		} else {
			return "error";
		}
		
		logger.debug("setListOrder ended.");
		
		return "json";
	}
	
	/**
	 * 사다리 게임을 조회
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezLadder/getLadderGame.do", method = RequestMethod.GET)
	public String getLadderGame(@CookieValue("loginCookie") String loginCookie, String ladderId, String searchSelect, String searchInput, String mode, String currPage, String sort, String sortFlag, ModelMap modelMap, String back, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getLadderGame started.");
		
		mode = mode != null ? mode : "all";
		currPage = currPage != null ? currPage : "1";
		searchSelect = searchSelect != null ? searchSelect : "";
		searchInput = searchInput != null ? searchInput : "";
		sort = sort != null ? sort : "basic";
		sortFlag = sortFlag != null ? sortFlag : "desc";
		back = back != null ? back : "";
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String gwServerUrl = config.getProperty("config.ladderGwServerURL");
		String url = gwServerUrl + "/rest/ladder/ladderGame/" +ladderId + "/users/" + userInfo.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		RestTemplate rest = new RestTemplate();
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("mode",mode)
				.queryParam("tenant_id", userInfo.getTenantId())
				.queryParam("offset", userInfo.getOffset())
				.queryParam("lang", userInfo.getLang())
				.queryParam("back", back);
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject jsonResult = (JSONObject) jp.parse(result.getBody());
		
		String status = jsonResult.get("status").toString();
		
		JSONObject vo = (JSONObject) jsonResult.get("ladder");
		JSONArray list = (JSONArray) jsonResult.get("participant");
		JSONArray cmtlist = (JSONArray) jsonResult.get("cmtlist");
		
		if (status.equals("ok")) {
			model.addAttribute("id", userInfo.getId());
			model.addAttribute("searchSelect", searchSelect );
			model.addAttribute("searchInput", searchInput );
			model.addAttribute("mode", mode );
			model.addAttribute("currPage", currPage);
			model.addAttribute("sort", sort);
			model.addAttribute("sortFlag", sortFlag);
			model.addAttribute("back", "back");
			model.addAttribute("vo", vo); // ladder
			model.addAttribute("list", list);// ladder line list
			model.addAttribute("cmtlist", cmtlist); // ladder comment list
			model.addAttribute("companyID", userInfo.getCompanyID());
		} else {
			return "error";
		}
		
		logger.debug("getLadderGame ended.");
		
		if(mode.equals("pre") || mode.equals("json")) {
			return "json";
		} else {
			return "ezLadder/ladderGame";
		}
	}
	
	/**
	 * 사다리 게임을 삭제
	 * @throws Exception
	 *
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezLadder/deleteLadder.do", method=RequestMethod.GET)
	public String deleteLadderList(@RequestParam(value="allData") List<String> allData, @CookieValue("loginCookie") String loginCookie, String ladderId, HttpServletRequest request, Model model) throws Exception {
		logger.debug("deleteLadder started.");

		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String gwServerUrl = config.getProperty("config.ladderGwServerURL");
		String url = gwServerUrl + "/rest/ladder/ladders/delete/" + userInfo.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		JSONObject jsonBodys = new JSONObject();
		jsonBodys.put("ladderId", allData.get(0));
		jsonBodys.put("loginCookie", loginCookie);
		
		HttpEntity<?> entity = new HttpEntity<>(jsonBodys, headers);
		
		RestTemplate rest = new RestTemplate();
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);

		JSONParser jp = new JSONParser();
		JSONObject jsonResult = (JSONObject) jp.parse(result.getBody());
		
		String status = jsonResult.get("status").toString();

		logger.debug("deleteLadder ended.");
		
		if (status.equals("ok")) {
			logger.debug(allData.get(0) + "\n");
			logger.debug(allData.get(1) + "\n");
			logger.debug(allData.get(2) + "\n");
			logger.debug(allData.get(3) + "\n");
			logger.debug(allData.get(4) + "\n");
			logger.debug(allData.get(5) + "\n");
			if(allData.get(5).equals("back")) {
				return "redirect:/ezLadder/ladderMain.do?mode=" + allData.get(3) + ""
						+ "&currPage=" + allData.get(4) + "&searchSelect=" + allData.get(1) + "&searchInput=" + allData.get(2)  + "&sort=writeDate&sortFlag=desc";
			}
			return "json";
		} else {
			return "error";
		}
	}
	
	/**
	 * 참여자 순서 바꾸기
	 * @throws Exception
	 * 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezLadder/serUserOrder.do", method=RequestMethod.POST)
	public String setUserOrder(@CookieValue("loginCookie") String loginCookie, String ladderId, String firstUser, String firstUserOrder, String secondUser, 
			String secondUserOrder, String firstItem, String secondItem, HttpServletRequest request, Model model) throws Exception{
		logger.debug("serUserOrder started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);

		String gwServerUrl = config.getProperty("config.ladderGwServerURL");
		String url = gwServerUrl + "/rest/ladder/ladders/" + ladderId + "/users/" + userInfo.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		RestTemplate rest = new RestTemplate();
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("firstUser", firstUser)
				.queryParam("secondUser", secondUser)
				.queryParam("firstUserOrder", firstUserOrder)
				.queryParam("secondUserOrder", secondUserOrder)
				.queryParam("firstItem", firstItem)
				.queryParam("secondItem", secondItem)
				.queryParam("tenant_id", userInfo.getTenantId())
				.queryParam("lang", userInfo.getLang());
		
		String retDestination = "";
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
		retDestination = "/lad/userOrder/change/";

		JSONParser jp = new JSONParser();
		JSONObject jsonResult = (JSONObject) jp.parse(result.getBody());
		String status = jsonResult.get("status").toString();
		@SuppressWarnings("unused")
		JSONArray lines = new JSONArray();
		if (status.equals("ok")) {
			
			lines = (JSONArray) jsonResult.get("data");
			model.addAttribute("status", status);
			
			retDestination += ladderId;
			JSONObject retjson = new JSONObject();
			retjson.put("dragOrder", firstUserOrder);
			retjson.put("dropOrder", secondUserOrder);
			retjson.put("ladderWriter", userInfo.getId());
			this.template.convertAndSend(retDestination, retjson);
		} else {
			return "error";
		}
		
		logger.debug("serUserOrder ended.");
		
		return "json";
	}
	
	/**
	 * 사다리 게임 시작
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezLadder/setLadderStart.do", method = RequestMethod.POST)
	public String setLadderStart(@CookieValue("loginCookie") String loginCookie,  String[] allData, HttpServletRequest request, Model model) throws Exception {
		logger.debug("setLadderStart started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String gwServerUrl = config.getProperty("config.ladderGwServerURL");
		String url = gwServerUrl + "/rest/ladder/start/" + allData[0] + "/users/" + userInfo.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		JSONObject jsonBodys = new JSONObject();
		jsonBodys.put("size", allData[5]);
		jsonBodys.put("lineCnt", allData[6]);
		jsonBodys.put("loginCookie", loginCookie);
		
		HttpEntity<?> entity = new HttpEntity<>(jsonBodys, headers);
		
		RestTemplate rest = new RestTemplate();
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
	
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
		
		String retDestination = "/lad/start/" + allData[0];
		
		JSONParser jp = new JSONParser();
		JSONObject jsonResult = (JSONObject) jp.parse(result.getBody());
		
		String status = jsonResult.get("status").toString();
		
		if (status.equals("ok")) {
			this.template.convertAndSend(retDestination, userInfo.getId());
		} else {
			return "error";
		}
		
		logger.debug("setLadderStart ended.");
		
		return "json";
	}
}
