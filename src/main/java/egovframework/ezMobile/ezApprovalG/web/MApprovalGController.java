package egovframework.ezMobile.ezApprovalG.web;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

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
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGAprLineInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGOpinionInfoVO;
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
	public String doApprovList() throws Exception {
		LOGGER.debug("doApprovList started");
		LOGGER.debug("doApprovList ended");
		
		return "mobile/ezApprovalG/mApprGdoApproveList";
	}
	
	@RequestMapping(value = "/mobile/ezApprovalG/mGetApproveList.do")
	public String mGetApproveList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, String pType, String pSearchText, String pLastDate) throws Exception {
		LOGGER.debug("mGetApproveList started");
		LOGGER.debug("listType : " + pType);
		LOGGER.debug("searchText : " + pSearchText);
		
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
		LOGGER.debug("listType : " + pType);
		LOGGER.debug("searchText : " + pSearchText);

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String url = gwServerUrl + "/ezapproval/" + pType + "/list-count/users/" + userInfo.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
		        .queryParam("searchText", pSearchText)
		        .queryParam("listSize", 20);
		
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
	@RequestMapping(value = "/mobile/ezApprovalG/doApprovalGDetail.do")
	public String doApprovalGDetail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, String pDocID, String pListType) throws Exception {
		LOGGER.debug("doApprovalGDetail started");
		LOGGER.debug("docID : " + pDocID);
		LOGGER.debug("listType : " + pListType);
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String realPath = commonUtil.getRealPath(request);
		
		//임시 결재할문서 타입
		pListType = "1";

		//결재선
		List<MApprovalGAprLineInfoVO> approvalGAprLineInfoVOs = MApprovalGService.getAprLineInfo(pDocID, pListType, userInfo);
		String photoPath = commonUtil.getUploadPath("upload_personal.PHOTO", userInfo.getTenantId());
		
		//본문
		String domain = request.getServerName() + ":" + request.getServerPort();
		String bodyHTML = MApprovalGService.getMHTBody(pDocID, pListType, realPath, domain, userInfo);
		
		//의견갯수
		String commentCount = MApprovalGService.getAprCommentCount(pDocID, pListType, userInfo);
		
		model.addAttribute("aprLineList", approvalGAprLineInfoVOs);
		model.addAttribute("photoPath", photoPath);
		model.addAttribute("bodyHTML", bodyHTML);
		model.addAttribute("commentCount", commentCount);
		model.addAttribute("docID", pDocID);

		LOGGER.debug("doApprovalGDetail ended");
		
		return "mobile/ezApprovalG/mApprGdoApproveDetail";
	}
	
	@RequestMapping(value = "/mobile/ezApprovalG/getOpinionInfo.do")
	public String getOpinionInfo(@CookieValue("loginCookie") String loginCookie, Model model, String pDocID, String pListType) throws Exception {
		LOGGER.debug("getOpinionInfo started");
		LOGGER.debug("docID : " + pDocID);
		LOGGER.debug("listType : " + pListType);
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);

		List<MApprovalGOpinionInfoVO> approvalGOpinionInfoVOs = MApprovalGService.getOpinionInfo(pDocID, pListType, userInfo);

		model.addAttribute("opinionList", approvalGOpinionInfoVOs);
		model.addAttribute("userID", userInfo.getId());
		
		LOGGER.debug("getOpinionInfo ended");
		
		return "json";
	}
	
	@RequestMapping(value = "/mobile/ezApprovalG/saveOpinionInfo.do")
	public void saveOpinionInfo(@CookieValue("loginCookie") String loginCookie, String pDocID, String pContent, String pOpinionGB, HttpServletResponse response) throws Exception {
		LOGGER.debug("saveOpinionInfo started");
		LOGGER.debug("docID : " + pDocID);
		LOGGER.debug("content : " + pContent);
		LOGGER.debug("opinionGB : " + pOpinionGB);
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		MApprovalGService.saveOpinionInfo(pDocID, pContent, pOpinionGB, userInfo);

		LOGGER.debug("saveOpinionInfo ended");
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
