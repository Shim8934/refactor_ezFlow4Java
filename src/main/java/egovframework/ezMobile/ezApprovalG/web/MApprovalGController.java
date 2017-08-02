package egovframework.ezMobile.ezApprovalG.web;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

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
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.google.gson.Gson;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezMobile.ezApprovalG.service.MApprovalGService;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGTLVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/** 
 * @Description [Controller] 전자결재 모바일
 * @author 오픈솔루션팀 황윤진
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2017.06.01    황윤진    신규작성
 *
 * @see
 */

@Controller
public class MApprovalGController {
	private static final Logger LOGGER = LoggerFactory.getLogger(MApprovalGController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;

	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name = "EzApprovalGService")
	private EzApprovalGService ezApprovalGService;
	
	@Resource(name = "EzEmailService")
	private EzEmailService ezEmailService;
	
	@Resource(name = "MApprovalGService")
	private MApprovalGService MApprovalGService;
	
	/**
	 * 모바일 전자결재G 결재할문서 호출 Method
	 */
	@RequestMapping(value = "/mobile/ezApprovalG/mApproveList.do")
	public String mApproveList() throws Exception {
		LOGGER.debug("mApproveList started");
		LOGGER.debug("mApproveList ended");
		
		return "mobile/ezApprovalG/mApprGdoApproveList";
	}
	
	@RequestMapping(value = "/mobile/ezApprovalG/mGetApproveList.do")
	public String mGetApproveList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, String pType, String pSearchText, String pLastDate) throws Exception {
		LOGGER.debug("mGetApproveList started");
		LOGGER.debug("type : " + pType);
		LOGGER.debug("searchText : " + pSearchText);
		
		//세션 대신 임시
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String url = gwServerUrl + "/ezapproval/" + pType + "/list/users/" + userInfo.getId();
		
		if (pLastDate == null || pLastDate.equals("")) {
			pLastDate = commonUtil.getTodayUTCTime("");
		}
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
		        .queryParam("searchText", pSearchText)
		        .queryParam("listSize", 20)
				.queryParam("lastDate", pLastDate);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<JSONObject> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, JSONObject.class);
		
		String status = result.getBody().get("status").toString();
		JSONArray approveList = new JSONArray();
		
		if (status.equals("ok")) {
			Gson gson = new Gson();
			approveList = gson.fromJson(gson.toJson(result.getBody().get("data")), JSONArray.class);
			
			model.addAttribute("approvalList", approveList);
		} else {
			return "에러페이지라고 하면 될려나";
		}
		
		LOGGER.debug("mGetApproveList ended");
		
		return "json";
	}
	
	@RequestMapping(value = "/mobile/ezApprovalG/mGetApproveListCount.do")
	public String mGetApproveListCount(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, String pType, String pSearchText) throws Exception {
		LOGGER.debug("mGetApproveListCount started");
		LOGGER.debug("type : " + pType);
		LOGGER.debug("searchText : " + pSearchText);

		//세션 대신 임시
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String url = gwServerUrl + "/ezapproval/" + pType + "/list-count/users/" + userInfo.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
		        .queryParam("searchText", pSearchText);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<JSONObject> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, JSONObject.class);
		
		String status = result.getBody().get("status").toString();
		
		if (status.equals("ok")) {
			int listCount = Integer.parseInt(result.getBody().get("data").toString());
			
			model.addAttribute("listCount", listCount);
		} else {
			return "에러페이지라고 하면 될려나";
		}
		
		LOGGER.debug("mGetApproveListCount ended");
		
		return "json";
	}
	
	/**
	 * 모바일 전자결재G 문서보기 호출 Method
	 */
	@RequestMapping(value = "/mobile/ezApprovalG/mApproveDoc.do")
	public String mApproveDoc(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, String pDocID, String pType) throws Exception {
		LOGGER.debug("mApproveDoc started");
		LOGGER.debug("docID : " + pDocID);
		LOGGER.debug("type : " + pType);
		
		//세션 대신 임시
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String url1 = gwServerUrl + "/ezapproval/docs/" + pDocID;
		String url2 = gwServerUrl + "/ezapproval/docs/" + pDocID + "/line-list";
		String url3 = gwServerUrl + "/ezapproval/docs/" + pDocID + "/attach-list";
		String url4 = gwServerUrl + "/ezapproval/docs/" + pDocID + "/opinion-count";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder1 = UriComponentsBuilder.fromHttpUrl(url1)
				.queryParam("userId", userInfo.getId())
				.queryParam("docID", pDocID);
		UriComponentsBuilder builder2 = UriComponentsBuilder.fromHttpUrl(url2)
				.queryParam("userId", userInfo.getId())
				.queryParam("docID", pDocID);
		UriComponentsBuilder builder3 = UriComponentsBuilder.fromHttpUrl(url3)
				.queryParam("userId", userInfo.getId())
				.queryParam("type", pType)
				.queryParam("docID", pDocID);
		UriComponentsBuilder builder4 = UriComponentsBuilder.fromHttpUrl(url4)
				.queryParam("userId", userInfo.getId())
				.queryParam("type", pType)
				.queryParam("docID", pDocID);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<JSONObject> result1 = rest.exchange(builder1.build().encode().toUri(), HttpMethod.GET, entity, JSONObject.class);
		ResponseEntity<JSONObject> result2 = rest.exchange(builder2.build().encode().toUri(), HttpMethod.GET, entity, JSONObject.class);
		ResponseEntity<JSONObject> result3 = rest.exchange(builder3.build().encode().toUri(), HttpMethod.GET, entity, JSONObject.class);
		ResponseEntity<JSONObject> result4 = rest.exchange(builder4.build().encode().toUri(), HttpMethod.GET, entity, JSONObject.class);
		
		String status1 = result1.getBody().get("status").toString();
		String status2 = result2.getBody().get("status").toString();
		String status3 = result3.getBody().get("status").toString();
		String status4 = result4.getBody().get("status").toString();
		
		if (status1.equals("ok") && status2.equals("ok") && status3.equals("ok") && status4.equals("ok")) {
			String bodyHTML = result1.getBody().get("data").toString();
			String photoPath = result2.getBody().get("photoPath").toString();
			String opinionCount = result4.getBody().get("data").toString();
			
			JSONArray approveLineList = new JSONArray();
			Gson gson = new Gson();
			approveLineList = gson.fromJson(gson.toJson(result2.getBody().get("data")), JSONArray.class);
			
			JSONArray approveAttachList = new JSONArray();
			approveAttachList = gson.fromJson(gson.toJson(result3.getBody().get("data")), JSONArray.class);
				
			model.addAttribute("aprAttachList", approveAttachList);
			model.addAttribute("aprLineList", approveLineList);
			model.addAttribute("photoPath", photoPath);
			model.addAttribute("opinionCount", opinionCount);
			model.addAttribute("docID", pDocID);
			model.addAttribute("bodyHTML", bodyHTML);
		} else {
			return "에러페이지라고 하면 될려나";
		}

		LOGGER.debug("mApproveDoc ended");
		
		return "mobile/ezApprovalG/mApprGdoApproveDetail";
	}
	
	@RequestMapping(value = "/mobile/ezApprovalG/mGetOpinionInfo.do")
	public String mGetOpinionInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, String pDocID) throws Exception {
		LOGGER.debug("mGetOpinionInfo started");
		LOGGER.debug("docID : " + pDocID);
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String url = gwServerUrl + "/ezapproval/docs/" + pDocID + "/opinion";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userInfo.getId());
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<JSONObject> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, JSONObject.class);
		
		String status = result.getBody().get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray approveOpinionList = new JSONArray();
			Gson gson = new Gson();
			approveOpinionList = gson.fromJson(gson.toJson(result.getBody().get("data")), JSONArray.class);
			
			model.addAttribute("opinionList", approveOpinionList);
			model.addAttribute("userID", userInfo.getId());
		} else {
			return "에러페이지라고 하면 될려나";
		}

		LOGGER.debug("mGetOpinionInfo ended");
		
		return "json";
	}
	
	@RequestMapping(value = "/mobile/ezApprovalG/mSetOpinionInfo.do")
	public String mSetOpinionInfo(@CookieValue("loginCookie") String loginCookie, String pDocID, String pContent, String pOpinionGB, String pType, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("mSetOpinionInfo started");
		LOGGER.debug("docID : " + pDocID);
		LOGGER.debug("content : " + pContent);
		LOGGER.debug("opinionGB : " + pOpinionGB);
		LOGGER.debug("type : " + pType);
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String url = gwServerUrl + "/ezapproval/docs/" + pDocID + "/opinion";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userInfo.getId())
				.queryParam("opinionGB", pOpinionGB)
				.queryParam("content", pContent);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<JSONObject> result = null;
		
		if (pType.equals("INSERT")) {
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, JSONObject.class);
		} else if (pType.equals("UPDATE")) {
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, JSONObject.class);
		} else if (pType.equals("DELETE")) {
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.DELETE, entity, JSONObject.class);
		}
		
		String status = result.getBody().get("status").toString();
		
		if (status.equals("ok")) {
			String code = result.getBody().get("code").toString();
			
			//code로 삽입, 삭제, 수정이 잘되었는지 확인하기
			model.addAttribute("code", code);
		} else {
			return "에러페이지라고 하면 될려나";
		}
		
		LOGGER.debug("mSetOpinionInfo ended");
		
		return "json";
	}

	/**
	 * 모바일 전자결재G 부재자설정 호출 Method
	 */
	@RequestMapping(value = "/mobile/ezApprovalG/mAbsenteeInfo.do")
	public String mAbsenteeInfo() throws Exception {
		LOGGER.debug("mAbsenteeInfo started");
		LOGGER.debug("mAbsenteeInfo ended");
		
		return "mobile/ezApprovalG/mApprGAbsenteeInfo";
	}

	/**
	 * 모바일 전자결재G 부재자설정 표출 Method
	 */
	@RequestMapping(value = "/mobile/ezApprovalG/mGetAbsenteeInfo.do")
	public String mGetAbsenteeInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("mGetAbsenteeInfo started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String url = gwServerUrl + "/ezapproval/absentee/users/" + userInfo.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<JSONObject> result = rest.exchange(url, HttpMethod.GET, entity, JSONObject.class);
		
		String status = result.getBody().get("status").toString();
		
		if (status.equals("ok")) {
			String code = result.getBody().get("code").toString();
			
			if (code != null && code.equals("0")) {
				JSONParser jsonParser = new JSONParser();
				JSONObject jsonObject = (JSONObject) jsonParser.parse(result.getBody().get("data").toString());
				
				String absenteeId = jsonObject.get("absenteeId").toString();
				String absenteeName = jsonObject.get("absenteeName").toString();
				String startDate = jsonObject.get("startDate").toString();
				String endDate = jsonObject.get("endDate").toString();
				
				model.addAttribute("absenteeId", absenteeId);
				model.addAttribute("absenteeName", absenteeName);
				model.addAttribute("startDate", startDate);
				model.addAttribute("endDate", endDate);
			}
		} else {
			return "에러페이지라고 하면 될려나";
		}

		LOGGER.debug("mGetAbsenteeInfo ended");
		
		return "json";
	}
	
	/**
	 * 모바일 전자결재G 부재자설정 셋 Method
	 */
	@RequestMapping(value = "/mobile/ezApprovalG/mSetAbsenteeInfo.do")
	public String mSetAbsenteeInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, String absenteeId, String absenteeName, String startDate, String endDate) {
		LOGGER.debug("mSetAbsenteeInfo started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String url = gwServerUrl + "/ezapproval/absentee/users/" + userInfo.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("absenteeId", absenteeId)
				.queryParam("absenteeName", absenteeName)
				.queryParam("startDate", startDate)
				.queryParam("endDate", endDate);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<JSONObject> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, JSONObject.class);
		
		String status = result.getBody().get("status").toString();
		
		if (status.equals("ok")) {
			
		} else {
			return "에러페이지라고 하면 될려나";
		}

		LOGGER.debug("mSetAbsenteeInfo ended");
		
		return "json";
	}

	/**
	 * 모바일 전자결재G 비밀번호확인 호출 Method
	 */
	@RequestMapping(value = "/mobile/ezApprovalG/mPWCheck.do")
	public String mPWCheck() throws Exception {
		LOGGER.debug("mPWCheck started");
		LOGGER.debug("mPWCheck ended");
		
		return "mobile/ezApprovalG/mApprGPWCheck";
	}
	
	/**
	 * 모바일 전자결재G 비밀번호확인 표출 Method
	 */
	@RequestMapping(value = "/mobile/ezApprovalG/mCheckPassword.do")
	public String checkPassword(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, String password) throws Exception {
		LOGGER.debug("mCheckPassword started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String url = gwServerUrl + "/ezapproval/pwd-check/users/" + userInfo.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("password", password);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<JSONObject> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, JSONObject.class);
		
		String status = result.getBody().get("status").toString();
		
		if (status.equals("ok")) {
			String resultCode = result.getBody().get("data").toString();
			
			if (resultCode != null && resultCode.equals("1")) {
				model.addAttribute("resultCode", "SUCCESS");
			} else {
				model.addAttribute("resultCode", "FAIL");
			}
		} else {
			return "에러페이지라고 하면 될려나";
		}

		LOGGER.debug("mCheckPassword ended");
		
		return "json";
	}
	
	@RequestMapping(value = "/mobile/ezApprovalG/mDoApprove.do")
	public String mDoApprove(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, String type, String docId) throws Exception {
		LOGGER.debug("mDoApprove started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String url = gwServerUrl + "/ezapproval/docs/" + docId + "/approve/" + type;
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userInfo.getId());
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<JSONObject> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, JSONObject.class);
		
		String status = result.getBody().get("status").toString();
		
		if (status.equals("ok")) {
			String resultCode = result.getBody().get("data").toString();
			
			if (resultCode != null && resultCode.equals("1")) {
				model.addAttribute("resultCode", "SUCCESS");
			} else {
				model.addAttribute("resultCode", "FAIL");
			}
		} else {
			return "에러페이지라고 하면 될려나";
		}

		LOGGER.debug("mDoApprove ended");
		
		return "json";
	}
	
	@RequestMapping(value = "/mobile/ezApprovalG/getTimeLineList.do")
	public String getTimeLineList(@CookieValue("loginCookie") String loginCookie, HttpSession session, Model model, String pTempFlag) throws Exception {
		LOGGER.debug("getTimeLineList started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String sessionDate = "";
		
		if (pTempFlag.equals("0")) {
			sessionDate = commonUtil.getTodayUTCTime("");
			session.setAttribute("timeLineStartDate", sessionDate);
		} else {
			sessionDate = (String) session.getAttribute("timeLineStartDate");
		}
		
		LOGGER.debug("sessionDate : " + sessionDate);
		
		List<MApprovalGTLVO> mApprovalGTLVOs = MApprovalGService.getTimeLineList(userInfo, sessionDate);
		

		//메일 조인 부분
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String password = userIdAndPassword.get(1);
	      
		List<Map<String, String>> mailList = ezEmailService.getMailListT(userInfo, password, sessionDate, 20);
		//sender, receivedDate, title
		
		for (Map<String, String> maps : mailList) {
			MApprovalGTLVO mApprovalGTLVO = new MApprovalGTLVO();
			mApprovalGTLVO.setTitle(maps.get("subject"));
			mApprovalGTLVO.setStartDate(maps.get("receivedDate"));
			mApprovalGTLVO.setModule("메일");
			mApprovalGTLVO.setWriterName(maps.get("sender"));
			
			mApprovalGTLVOs.add(mApprovalGTLVO);
		}
		
		Collections.sort(mApprovalGTLVOs, new Comparator<MApprovalGTLVO>() {
			@Override
			public int compare(MApprovalGTLVO o1, MApprovalGTLVO o2) {
				return o2.getStartDate().compareTo(o1.getStartDate());
			}
		});
		
		sessionDate = mApprovalGTLVOs.get(mApprovalGTLVOs.size() - 1).getStartDate();
		
		if (mApprovalGTLVOs.size() > 0) {
			session.setAttribute("timeLineStartDate", sessionDate);
		}

		model.addAttribute("timeLineList", mApprovalGTLVOs);
		
		LOGGER.debug("getTimeLineList ended");
		
		return "json";
	}
}
