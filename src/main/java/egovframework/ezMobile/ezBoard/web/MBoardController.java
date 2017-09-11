package egovframework.ezMobile.ezBoard.web;

import java.util.List;
import java.util.Properties;
import java.util.UUID;

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
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

//import com.google.gson.Gson;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezMobile.ezBoard.service.MBoardService;
import egovframework.ezMobile.ezBoard.vo.MBoardInfoVO;
import egovframework.ezMobile.ezBoard.vo.MBoardListVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class MBoardController {
	private static final Logger LOGGER = LoggerFactory.getLogger(MBoardController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name = "EzBoardService")
	private EzBoardService ezBoardService;
	
	@Resource(name = "EzBoardAdminService")
	private EzBoardAdminService ezBoardAdminService;
	
	@Resource(name = "MBoardService")
	private MBoardService mBoardService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	final public int mobileListSize = 20;
	final public String newBoardID = "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}";
	
	/**
	 * 모바일 게시판 게시판그룹목록 조회
	 * 1. 즐겨찾기 게시판목록
	 * 2. 분류별 게시판목록
	 * getBoardTree 참조  (권한체크)
	 */
	@RequestMapping("/mobile/ezBoard/getBoardList.do")
	public String getBoardList() throws Exception {
		LOGGER.debug("getBoardList started.");
		
		LOGGER.debug("getBoardList ended.");
		
		return "";
	}
	
	/**
	 * 모바일 게시판 해당게시판글목록화면
	 */
	@RequestMapping(value = "/mobile/ezBoard/boardItemList.do")
	public String boardItemList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp,Model model) throws Exception {
		LOGGER.debug("boardItemList started.");
		String type = "";
		String boardID = "";
		
		if (request.getParameter("type") != null && !request.getParameter("type").equals("")) {
			type = request.getParameter("type");
		}
		if (request.getParameter("boardID") != null && !request.getParameter("boardID").equals("")) {
			boardID = request.getParameter("boardID");
		}
		LOGGER.debug("boardID = " + boardID + " || type = " + type);
		
		//임시
		type ="newBoardItemList";
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String url = gwServerUrl + "/mobile/ezboard/boards/"+boardID+"/list";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userID", userInfo.getId())
				.queryParam("deptPathCode", userInfo.getDeptPathCode());
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject)jp.parse(result.getBody());
				
		String status = resultBody.get("status").toString();
		LOGGER.debug("status : "+status);

		JSONArray list = new JSONArray();
		Object boardInfo = "";
		if (status.equals("ok")) {
			list = (JSONArray)resultBody.get("data");
			boardInfo = resultBody.get("data2");
			
			LOGGER.debug("listSize:"+list.size());
			
			model.addAttribute("mBoardInfo", boardInfo);
			model.addAttribute("listSize", list.size());
		}
		
		LOGGER.debug("boardItemList ended.");
		
		return "/mobile/ezBoard/mBoardItemList";
	}
	
	/**
	 * 모바일 게시판 해당게시판 정보조회
	 * 상위 게시판 및 그룹 조회
	 */
	@RequestMapping(value = "/mobile/ezBoard/getBoardInfo.do")
	public String getBoardInfo() throws Exception {
		LOGGER.debug("getBoardInfo started.");
		
		LOGGER.debug("getBoardInfo ended.");
		
		return "";
	}
	
	/**
	 * 모바일 게시판 해당게시판글목록조회
	 */
	@RequestMapping(value = "/mobile/ezBoard/getBoardItemList.do")
	public String getBoardItemList(@CookieValue("loginCookie") String loginCookie, MBoardInfoVO mBoardInfoVO, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("getBoardItemList started.");
		
		String type = "";
		String boardID = "";
		
		if (request.getParameter("type") != null && !request.getParameter("type").equals("")) {
			type = request.getParameter("type");
		}
		if (request.getParameter("boardID") != null && !request.getParameter("boardID").equals("")) {
			boardID = request.getParameter("boardID");
		}
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		LOGGER.debug("type = " + type + " || boardID = " + boardID + " || userID = " + userInfo.getId());
		
		mBoardInfoVO.setType("newBoardItemList");
		mBoardInfoVO.setBoardID("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}");
		//mBoardInfoVO.setBoardID("{6d7b50a2-4777-96a3-4b3a-a670dcd703f1}");
		
		//게시판정보
		//mBoardInfoVO = mBoardService.getBoardProperty(mBoardInfoVO.getBoardID(), primary, tenantID);
		//mBoardInfoVO = mBoardService.getBoardInfo(mBoardInfoVO, userInfo);
		
		//리스트
		/*List<MBoardItemVO> mBoardItemList = null;
		
		if (mBoardInfoVO.getType().equals("newBoardItemList")) {
			//새 게시물리스트
			mBoardItemList = mBoardService.getNewBoarditemList(mBoardInfoVO, userInfo);
		} else {
			//해당게시판 글목록
			mBoardItemList = mBoardService.getBoardItemList(mBoardInfoVO, userInfo);
		}*/
		
//		if (boardType.equals("4")) { // 썸네일 
//			resultXML = getThumbList(boardVO, userInfo, type);
//		} else if (boardType.equals("5")) { //Q&A
//			resultXML = getQnAListItem(boardVO, userInfo, type, boardInfo.getBoardAdmin_FG());
//		} else if (boardType.equals("M")) { //마이게시판
//			resultXML = getMyboardList(boardVO, userInfo, mode);
//		} else if (boardType.equals("A")) { //게시판승인
//			resultXML = getApprboardList(boardVO, userInfo, mode, type);
//		} else {
//			if (boardID.equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")) {
//				boardVO.setBoardType("N");
//				resultXML = getNewItemList(boardVO, userInfo);
//			} else {
//				resultXML = getBoardListItem(boardVO, userInfo, type);
//			}
//		}
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");		
		String url = gwServerUrl + "/mobile/ezboard/boards/"+mBoardInfoVO.getBoardID()+"/list";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userID", userInfo.getId())
				.queryParam("deptPathCode", userInfo.getDeptPathCode());
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject)jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		JSONArray list = new JSONArray();
		
		if (status.equals("ok")) {
			
			list = (JSONArray)resultBody.get("data");
			
			model.addAttribute("mBoardInfo", mBoardInfoVO);
			model.addAttribute("mBoardItemList", list);
		}
		/*JSONArray sample = rest.getForObject(builder.build().encode().toUri(), JSONArray.class);

		model.addAttribute("mBoardInfo", mBoardInfoVO);
		//model.addAttribute("mBoardItemList", mBoardItemList);
		model.addAttribute("mBoardItemList", sample);
		model.addAttribute("mBoardItemListSize", sample.size());*/
		
		LOGGER.debug("getBoardItemList ended.");
		
		return "json";
	}
	
	/**
	 * 모바일 게시판 즐겨찾기에 등록된 게시판 폴더 리스트
	 */
	@RequestMapping(value = "/mobile/ezBoard/getFavoriteList.do")
	public String getFavoriteList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("getFavoriteList started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String url = gwServerUrl + "/mobile/ezboard/favorite-list/users/"+userInfo.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject)jp.parse(result.getBody());
				
		String status = resultBody.get("status").toString();
		LOGGER.debug("status : "+status);

		JSONArray list = new JSONArray();

		if (status.equals("ok")) {
			list = (JSONArray)resultBody.get("data");

			model.addAttribute("favoriteList", list);
		}
		
		LOGGER.debug("getFavoriteList ended.");
		
		return "json";
	}
	
	/**
	 * 모바일 게시판 글 상세화면조회
	 * 게시판종류별로 (일반, 그룹, 익명, 포토, 썸네일, Q&A)
	 */
	@RequestMapping(value = "/mobile/ezBoard/getBoardItem.do")
	public String getBoardItem(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("getBoardItem started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String type = request.getParameter("type");
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		String url = gwServerUrl + "/mobile/ezboard/"+type+"/boards/"+boardID+"/contents/"+itemID;
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userID", userInfo.getId());
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<JSONObject> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, JSONObject.class);
		
		JSONObject resultBody = result.getBody();
		
		String status = resultBody.get("status").toString();
		
		Object mBoardItem = "";
		if (status.equals("ok")) {
			mBoardItem = resultBody.get("data");
			
			model.addAttribute("mBoardItem", mBoardItem);
		}
System.out.println("mBoardItem:"+mBoardItem);
		LOGGER.debug("getBoardItem ended.");
		
		return "/mobile/ezBoard/mBoardItem";
	}
	
	/**
	 * 모바일 게시판 글 쓰기/수정화면조회
	 * itemID 보고
	 * 1.쓰기
	 * 2.수정
	 * 게시판종류보고 
	 * 포토 (multi 찾아봐야함)
	 */
	@RequestMapping(value = "/mobile/ezBoard/editBoardItem.do")
	public String editBoardItem() throws Exception {
		LOGGER.debug("editBoardItem started.");
		
		LOGGER.debug("editBoardItem ended.");
		
		return "";
	}
	
	/**
	 * 모바일 게시판 글 쓰기/수정 저장
	 */
	@RequestMapping(value = "/mobile/ezBoard/saveBoardItem.do")
	public void saveBoardItem(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response,MBoardListVO boardListVO) throws Exception {
		LOGGER.debug("saveBoardItem started.");
		
		/*if (boardID != null) {
			수정저장
		} else {
			쓰기저장
			
			쓰기 저장 success 에서 알림메일 전송
		}*/
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String type = request.getParameter("type");
		String itemID = request.getParameter("itemID");
		String url = "";
		
		//String boardID = request.getParameter("boardID");
		
		String boardID = "{c2a62f97-263c-d60a-2c2f-c20815843514}";
		
		//String mode = request.getParameter("mode");
		String mode = "new";
		String guBun = request.getParameter("guBun");
		
		if (type != null && type.equals("modify")) {
			url = gwServerUrl + "/mobile/ezboard/boards/"+boardID+"/contents"+itemID; 
		} else {
			url = gwServerUrl + "/mobile/ezboard/boards/contents";
		}
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		boardListVO.setTitle("테스트제목");
		boardListVO.setTenantID(userInfo.getTenantId());
		boardListVO.setUserID(userInfo.getId());
		boardListVO.setBoardID(boardID);
		boardListVO.setItemID("{"+UUID.randomUUID().toString()+"}");
		//Gson gson = new Gson();
		//JSONObject jsonParam = gson.fromJson(gson.toJson(boardListVO), JSONObject.class);
		
		RestTemplate rest = new RestTemplate();
		
		//ResponseEntity<JSONObject> result = rest.postForEntity(url, entity, JSONObject.class);
		//ResponseEntity<JSONObject> result = rest.exchange(url, HttpMethod.PUT, entity, JSONObject.class);
		
		//JSONObject resultBody = result.getBody();
		
		//String status = resultBody.get("status").toString();
		
		//LOGGER.debug("status : "+status);
		
		LOGGER.debug("saveBoardItem ended.");
		
	}
	
	/**
	 * 모바일 게시판 글 삭제
	 */
	@RequestMapping(value = "/mobile/ezBoard/deleteBoardItem.do")
	public void deleteBoardItem(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LOGGER.debug("deleteBoardItem started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String boardId = request.getParameter("boardID");
		String contentId = request.getParameter("itemID");
		
		boardId = "{6d7b50a2-4777-96a3-4b3a-a670dcd703f1}";
		contentId = "{e0110954-7485-4613-8638-85a31377a3be}";
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String url = gwServerUrl + "/mobile/ezboard/boards/"+boardId+"/contents/"+contentId;
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);

		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)		        
		        .queryParam("userId", userInfo.getId());
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<JSONObject> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.DELETE, entity, JSONObject.class);
		
		JSONObject resultBody = result.getBody();
		
		String status = resultBody.get("status").toString();
		
		LOGGER.debug("deleteBoardItem ended.");
	}
	
	/**
	 * 모바일 게시판 좌측메뉴 리스트
	 */
	@RequestMapping(value = "/mobile/ezBoard/getLeftMenu.do")
	public String getLeftMenu(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		LOGGER.debug("getLeftMenu started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String boardID = request.getParameter("rootBoardID");
		String excludeBoardID = request.getParameter("excludeBoardID");
		String selectBy = request.getParameter("selectBy");
		String subFlag = request.getParameter("subFlag");
		String url = gwServerUrl + "/mobile/ezboard/folder-list";
		
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userInfo.getId())
				.queryParam("rootBoardId", boardID)
				.queryParam("selectBy", selectBy)
				.queryParam("excludeBoardId", excludeBoardID)
				.queryParam("subFlag", subFlag);
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<JSONObject> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, JSONObject.class);
		
		JSONObject resultBody = result.getBody();
		
		String status = resultBody.get("status").toString();
		
		Object mBoardItem = "";
		if (status.equals("ok")) {
			mBoardItem = resultBody.get("data");
System.out.println("mBoardItem:"+mBoardItem);
			model.addAttribute("mBoardItem", mBoardItem);
		}
		
		LOGGER.debug("getLeftMenu ended.");
		
		return "json";
	}
	
	/**
	 * 모바일 게시판 메인리스트 호출 테스트
	 */
	@RequestMapping(value = "/mobile/ezBoard/mainList.do")
	public String mainList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("boardItemList started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String url = gwServerUrl + "/mobile/ezboard/new-list/"+userInfo.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
				
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<JSONObject> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, JSONObject.class);
		
		JSONObject resultBody = result.getBody();
				
		String status = resultBody.get("status").toString();
		LOGGER.debug("status : "+status);

		JSONArray list = new JSONArray();
		Object boardInfo = "";
		if (status.equals("ok")) {
System.out.println("newList:"+resultBody.get("data"));
			//Gson gson = new Gson();
			//list = gson.fromJson(gson.toJson(resultBody.get("data")), JSONArray.class);
			
			LOGGER.debug("listSize:"+list.size());
			
			model.addAttribute("mBoardInfo", boardInfo);
			model.addAttribute("listSize", list.size());
		}
		
		LOGGER.debug("boardItemList ended.");
		
		return "";
	}
}
