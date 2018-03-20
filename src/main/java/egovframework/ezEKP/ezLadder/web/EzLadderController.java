package egovframework.ezEKP.ezLadder.web;


import java.util.Arrays;
import java.util.List;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

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
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezLadder.service.EzLadderService;
import egovframework.ezEKP.ezLadder.vo.LadderLineVO;
import egovframework.ezEKP.ezLadder.vo.LadderVO;
import egovframework.let.user.login.service.LoginService;
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
	
	/**
	 * 사다리 게임 호출
	 * */
	@RequestMapping(value = "/ezLadder/ladderMain.do")
	public String ladderMain(String mode, String currPage, String searchSelect, String searchInput, @CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("ladderMain started.");
		logger.debug("mode : " + mode);
		logger.debug("currPage : " + currPage);
		logger.debug("searchSelect : " + searchSelect);
		logger.debug("searchInput : " + searchInput);
	

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String gwServerUrl = config.getProperty("config.ladderGwServerURL");
		String url = gwServerUrl + "/ladder/ladder-list/users/" + userInfo.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		RestTemplate rest = new RestTemplate();
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
									.queryParam("tenantId", userInfo.getTenantId())
									.queryParam("mode", mode)
									.queryParam("currPage", currPage)
									.queryParam("searchSelect", searchSelect)
									.queryParam("searchInput", searchInput);
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);

		JSONParser jp = new JSONParser();
		JSONObject jsonResult = (JSONObject) jp.parse(result.getBody());
		
		JSONArray list = new JSONArray();
		String status = jsonResult.get("status").toString();
		String page = jsonResult.get("currPage").toString();
		String totalLadder = jsonResult.get("totalLadder").toString();
		String totalPage = jsonResult.get("totalPage").toString();
	
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
			
		} else {
			return "error";
		}
		
		logger.debug("/ezLadder/ladderMain ended.");

		String retJSP = "";
		if(mode.equals("pre")) {
			retJSP = "ezLadder/ladderPreList";
		} else {
			retJSP = "ezLadder/ladderMain";
		}
		
		return retJSP;
	}
	

	/**
	 * 사다리 게임 종류 선택
	 * */
	@RequestMapping(value = "/ezLadder/selectLadderType.do")
	public String ladderTypeView() {
		logger.debug("selectLadderType.do started.");
		logger.debug("selectLadderType.do ended.");
		
		return "ezLadder/selectLadderType";
	}
	
	/**
	 * 사다리 게임 설정 작성
	 * */
	@RequestMapping(value = "/ezLadder/setLadder.do", method = RequestMethod.GET)
	public String setLadderView(@CookieValue("loginCookie") String loginCookie, String type, String ladderId, Model model, HttpServletRequest request) throws Exception {
		logger.debug("setLadder.do ended.");
		
		model.addAttribute("ladType", type);
		model.addAttribute("ladderId", ladderId);
		
		return "ezLadder/setLadder";
	}
	
	/** 
	 * 참여자 추가 (조직도 호출)
	 * */
	@RequestMapping(value = "/ezLadder/setLadderAttendant.do")
	public String setLadderAttendant(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		logger.debug("GET setLadderAttendant.do started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userID", userInfo.getId());
		model.addAttribute("deptID", userInfo.getDeptID());
		
		logger.debug("GET setLadderAttendant.do ended.");
		
		return "ezLadder/ladderSetAttendant";
	}
	
	/**
	 * 참여자 검색 시 이름 체크 팝업창
	 * */
	@RequestMapping(value = "/ezLadder/checkName.do")
	public String ladderCheckName() {
		return "ezLadder/ladderCheckName";
	}
	
	/**
	 * 사다리 게임 추가 
	 * @throws Exception 
	 * */
	@RequestMapping(value = "/ezLadder/setLadder.do", method = RequestMethod.POST)
	public String setLadder(@CookieValue("loginCookie") String loginCookie, 
			String title, String type, String secretFlag, String lineCnt,
			String [] userId, String [] userName, String [] userName2, 
			String [] item, String [] ladderOrder,
			HttpServletRequest request, Model model) throws Exception {
		logger.debug("POST setLadder.do started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String gwServerUrl = config.getProperty("config.ladderGwServerURL");
		String url = gwServerUrl + "/ladder/ladders/writers/" + userInfo.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		RestTemplate rest = new RestTemplate();
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("title", title)
				.queryParam("type", type)
				.queryParam("secretFlag", secretFlag)
				.queryParam("lineCnt", lineCnt)
				.queryParam("writerName", userInfo.getDisplayName())
				.queryParam("writerName2", userInfo.getDisplayName2())
				.queryParam("deptName", userInfo.getDeptName())
				.queryParam("deptName2", userInfo.getDeptName2())
				.queryParam("tenant_id", userInfo.getTenantId())
				.queryParam("userIds", userId)
				.queryParam("userNames", userName)
				.queryParam("userName2s", userName2)
				.queryParam("items", item)
				.queryParam("ladderOrders", ladderOrder);
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);

		JSONParser jp = new JSONParser();
		JSONObject jsonResult = (JSONObject) jp.parse(result.getBody());
		
		String data = jsonResult.get("data").toString();
		String status = jsonResult.get("status").toString();
	
		if (status.equals("ok")) {
			model.addAttribute("ladderid", data);
		} else {
			return "error";
		}
		
		logger.debug("POST setLadder.do ended.");
		return "ezLadder/ladderMain"; // redirect:조회창(ladderId값 파라미터로)
	}
	
	/**
	 * 즐겨찾기 조회
	 * @throws Exception 
	 * */
	@RequestMapping(value = "/ezLadder/getLadderBM.do")
	public String getLadderBM(@CookieValue("loginCookie") String loginCookie, String ladderBmId, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getLadderBM.do started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String gwServerUrl = config.getProperty("config.ladderGwServerURL");
		String url = "";
		
		if(ladderBmId == null || ladderBmId.equals("")) {
			url = gwServerUrl + "/ladder/BMs/users/" + userInfo.getId();
		} else {
			url = gwServerUrl + "/ladder/BMs/" + ladderBmId + "/users/" + userInfo.getId();
		}
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		RestTemplate rest = new RestTemplate();
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("tenant_id", userInfo.getTenantId())
				.queryParam("offset", userInfo.getOffset())
				.queryParam("lang", userInfo.getLang());
		
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
		
		logger.debug("getLadderBM.do ended.");
		return "json";
	}
	
	/**
	 * 즐겨찾기 추가 시 이름 입력 팝업
	 * */
	@RequestMapping(value = "/ezLadder/inputBmName.do")
	public String setBmName() {
		return "ezLadder/bmNamePopUp";
	}
	
	/**
	 * 즐겨찾기 추가, 수정, 삭제
	 * @throws Exception 
	 * */
	@RequestMapping(value = "/ezLadder/setLadderBM.do", method = RequestMethod.POST)
	public String setLadderBM(@CookieValue("loginCookie") String loginCookie, 
			String flag, String ladderBmId, String bmName, 
			String [] userIds, String [] userNames, String [] userName2s, 
			HttpServletRequest request, Model model) throws Exception {
		logger.debug("setLadderBM.do started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String gwServerUrl = config.getProperty("config.ladderGwServerURL");
		String url = "";
		
		if(flag.equals("add")) {
			url = gwServerUrl + "/ladder/BMs/users/" + userInfo.getId();
		} else {
			url = gwServerUrl + "/ladder/BMs/" + ladderBmId + "/users/" + userInfo.getId();
		}
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		RestTemplate rest = new RestTemplate();
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("tenant_id", userInfo.getTenantId())
				.queryParam("bmName", bmName)
				.queryParam("writerId", userInfo.getId())
				.queryParam("userIds", userIds)
				.queryParam("userNames", userNames)
				.queryParam("userName2s", userName2s)
				.queryParam("lang", userInfo.getLang())
				.queryParam("offset", userInfo.getOffset());
		
		ResponseEntity<String> result = null;
		
		if(flag.equals("add")) {
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		} else if(flag.equals("modify")) {
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
		} else if(flag.equals("delete")){
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.DELETE, entity, String.class);
		}
		
		JSONParser jp = new JSONParser();
		JSONObject jsonResult = (JSONObject) jp.parse(result.getBody());
		
		String status = jsonResult.get("status").toString();
	
		if (status.equals("ok")) {
			model.addAttribute("status", status);
		} else {
			return "error";
		}
		
		logger.debug("getLadderBM.do ended.");
		return "json";
	}
	
	/**
	 * 댓글 조회 : 사다리 조회 컨트롤러랑 합쳐져야함 
	 * @throws Exception 
	 * */
	@RequestMapping(value = "/ezLadder/getLadderComment.do")
	public String getLadderComment(@CookieValue("loginCookie") String loginCookie, String ladderId, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getLadderComment.do started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String gwServerUrl = config.getProperty("config.ladderGwServerURL");
		String url = gwServerUrl + "/ladder/ladders/" + ladderId + "/comment/users/" + userInfo.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		RestTemplate rest = new RestTemplate();
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);

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
		
		logger.debug("getLadderComment.do ended.");
		return "";
	}

	/**
	 * 댓글 추가, 수정, 삭제 : 웹소켓 이용... 수정될듯..
	 * @throws Exception 
	 * */
	@RequestMapping(value = "/ezLadder/setLadderComment.do")
	public String setLadderComment(@CookieValue("loginCookie") String loginCookie, String mark, String ladderId, String comment, HttpServletRequest request, Model model) throws Exception {
		logger.debug("setLadderComment.do started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String gwServerUrl = config.getProperty("config.ladderGwServerURL");
		String url = gwServerUrl + "/ladder/ladders/" + ladderId + "/comment/users/" + userInfo.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		RestTemplate rest = new RestTemplate();
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
		
		ResponseEntity<String> result = null;
		
		if(mark.equals("add")) {
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		} else if(mark.equals("modify")) {
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
		} else if(mark.equals("delete")) {
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.DELETE, entity, String.class);
		}

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
		
		logger.debug("setLadderComment.do ended.");
		return "json";
	}
	
	/**
	 * 이전 사다리 목록 조회 팝업창 -> get 
	 * @throws Exception 
	 * */
	/*@RequestMapping(value = "/ezLadder/getPreLadderList.do")
	public String getPreLadderList(@CookieValue("loginCookie") String loginCookie, String currPage, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getPreLadderList.do started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String gwServerUrl = config.getProperty("config.ladderGwServerURL");
		String url = gwServerUrl + "/ladder/ladder-list/users/" + userInfo.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		RestTemplate rest = new RestTemplate();
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);

		JSONParser jp = new JSONParser();
		JSONObject jsonResult = (JSONObject) jp.parse(result.getBody());
		
		JSONArray list = new JSONArray();
		String status = jsonResult.get("status").toString();
		String page = jsonResult.get("currPage").toString();
		String totalLadder = jsonResult.get("totalLadder").toString();
		String totalPage = jsonResult.get("totalPage").toString();
	
		if (status.equals("ok")) {
			list = (JSONArray) jsonResult.get("data");
			model.addAttribute("id", userInfo.getId());
			model.addAttribute("list", list);
			model.addAttribute("currPage", page);
			model.addAttribute("totalPage", totalPage);
			model.addAttribute("totalLadder", totalLadder);
		} else {
			return "error";
		}
		
		logger.debug("getPreLadderList.do ended.");
		
		return "ezLadder/ladderPreList";
	}*/
	
	/**
	 * 이전 사다리 미리보기
	 * @throws Exception 
	 * */
	@RequestMapping(value = "/ezLadder/getPreLadder.do")
	public String getPreLadder(@CookieValue("loginCookie") String loginCookie, String ladderId, HttpServletRequest request, Model model) throws Exception {
		logger.debug("setListOrder.do started.");
		
		// 게임페이지 조회하는 gwcontroller 가져오기
		
		logger.debug("setListOrder.do ended.");
		return "json";
	}
	
	/**
	 * 이전 사다리 목록 순서 바꾸기
	 * @throws Exception 
	 * */
	@RequestMapping(value = "/ezLadder/setListOrder.do")
	public String setListOrder(@CookieValue("loginCookie") String loginCookie, String [] ladderId, HttpServletRequest request, Model model) throws Exception {
		logger.debug("setListOrder.do started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String gwServerUrl = config.getProperty("config.ladderGwServerURL");
		String url = gwServerUrl + "/ladder/ladder-list/users/" + userInfo.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		RestTemplate rest = new RestTemplate();
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
		
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
		
		logger.debug("setListOrder.do ended.");
		return "json";
	}
	
	/** hyh	*/
	
	/**
	 * 사다리 게임을 조회
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezLadder/getLadderGame.do", method = RequestMethod.GET)
	public String getLadderGame(@CookieValue("loginCookie") String loginCookie, String[] allData, ModelMap modelMap, HttpServletRequest request, Model model) throws Exception {
		
		logger.debug("ezLadder/getLadderGame.do started.");
		logger.debug("ladderId : " + allData[0]);
		logger.debug("searchSelect : " + allData[1]);
		logger.debug("searchInput " + allData[2]);
		logger.debug("mode : " + allData[3]);
		logger.debug("currPage : " + allData[4]);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String gwServerUrl = config.getProperty("config.ladderGwServerURL");
		String url = gwServerUrl + "/ladder/ladderGame/" + allData[0] + "/users/" + userInfo.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		RestTemplate rest = new RestTemplate();
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url).queryParam("tenantId", userInfo.getTenantId());
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);

		JSONParser jp = new JSONParser();
		JSONObject jsonResult = (JSONObject) jp.parse(result.getBody());
		JSONArray list = new JSONArray();
		
		
		String status = jsonResult.get("status").toString();
	
		if (status.equals("ok")) {
			list = (JSONArray) jsonResult.get("participant");
			model.addAttribute("id", userInfo.getId());
			model.addAttribute("vo",jsonResult.get("data"));	// x번째 사다리 정보
			model.addAttribute("searchSelect", allData[1] );
			model.addAttribute("searchInput", allData[2] );
			model.addAttribute("mode", allData[3] );
			model.addAttribute("currPage", allData[4] );
			model.addAttribute("list", list); 			// ladderLineList
		} else {
			return "error";
		}
		
		logger.debug("ezLadder/getLadderGame.do ended.");
		
		String retJSP = "";
		if(allData[3].equals("pre")) {
			retJSP = "json";
		} else {
			retJSP = "ezLadder/ladderGame";
		}
		return retJSP;
	}
	
	/**
	 * 사다리 게임을 삭제
	 * @throws Exception
	 *
	 */
	@RequestMapping(value = "/ezLadder/deleteLadder.do")
	public String deleteLadderList(@RequestParam(value="allData") List<String> allData, @CookieValue("loginCookie") String loginCookie, String ladderId, HttpServletRequest request, Model model) throws Exception {
		logger.debug("ezLadder/deleteLadder started.");
		logger.debug("ladderId : " + allData.get(0));
		logger.debug("searchSelect : " + allData.get(1));
		logger.debug("searchInput " + allData.get(2));
		logger.debug("mode : " + allData.get(3));
		logger.debug("currPage : " + allData.get(4));
		logger.debug("back : " + allData.get(5));
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String gwServerUrl = config.getProperty("config.ladderGwServerURL");
		String url = gwServerUrl + "/ladder/ladders/delete/" + userInfo.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		RestTemplate rest = new RestTemplate();
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("ladderId", allData.get(0))
										.queryParam("searchSelect", allData.get(1))
										.queryParam("searchInput", allData.get(2))
										.queryParam("mode", allData.get(3))
										.queryParam("currPage", allData.get(4))
										.queryParam("tenantId", userInfo.getTenantId());
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);

		JSONParser jp = new JSONParser();
		JSONObject jsonResult = (JSONObject) jp.parse(result.getBody());
		
		JSONArray list = new JSONArray();
		String status = jsonResult.get("status").toString();

		if (status.equals("ok")) {
			if(allData.get(5).equals("back")) {
				return "redirect:/ezLadder/ladderMain.do?mode=" + allData.get(3) + ""
						+ "&currPage=" + allData.get(4) + "&searchSelect=" + allData.get(1) + "&searchInput=" + allData.get(2);
			}
			logger.debug("ezLadder/deleteLadder ended.");
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
	@RequestMapping(value = "/ezLadder/serUserOrder.do")
	public String setUserOrder(@CookieValue("loginCookie") String loginCookie, String ladderId, String firstUser, String secondUser, HttpServletRequest request, Model model) throws Exception{
		logger.debug("ezLadder/serUserOrder.do started.");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String gwServerUrl = config.getProperty("config.ladderGwServerURL");
		String url = gwServerUrl + "/ladder/ladders/" + ladderId + "users/" + userInfo.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		RestTemplate rest = new RestTemplate();
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
		
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
		
		logger.debug("ezLadder/serUserOrder.do ended.");
		return "json";
	}
	
	/**
	 * 사다리 게임 시작
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezladder/setLadderStart.do")
	public String setLadderStart(@CookieValue("loginCookie") String loginCookie, String ladderId,  String startDate,  HttpServletRequest request, Model model) throws Exception {
		logger.debug("ezLadder/setLadderStart.do started.");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String gwServerUrl = config.getProperty("config.ladderGwServerURL");
		String url = gwServerUrl + "/ladder/ladders/" + ladderId + "users/" + userInfo.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		RestTemplate rest = new RestTemplate();
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
		
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
		
		logger.debug("ezLadder/setLadderStart.do ended.");
		return "json";
	}
}
