package egovframework.ezMobile.ezBoard.web;

import java.util.List;
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
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.google.gson.Gson;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezMobile.ezBoard.service.MBoardService;
import egovframework.ezMobile.ezBoard.vo.MBoardInfoVO;
import egovframework.ezMobile.ezBoard.vo.MBoardItemVO;
import egovframework.ezMobile.ezSchedule.web.MScheduleController;
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
	public String boardItemList(@CookieValue("loginCookie") String loginCookie, MBoardInfoVO mBoardInfoVO, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("boardItemList started.");
		LOGGER.debug("boardID = " + mBoardInfoVO.getBoardID() + " || type = " + mBoardInfoVO.getType());
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		mBoardInfoVO = mBoardService.getBoardProperty(mBoardInfoVO.getBoardID(), userInfo.getPrimary(), userInfo.getTenantId());
		mBoardInfoVO = mBoardService.getBoardInfo(mBoardInfoVO, userInfo);
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String url = gwServerUrl + "/ezboard/"+mBoardInfoVO.getType()+"/boards/"+mBoardInfoVO.getBoardID()+"/list";
		
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
		LOGGER.debug("status : "+status);
		
		JSONArray list = new JSONArray();
		if (status.equals("ok")) {
			Gson gson = new Gson();
			list = gson.fromJson(gson.toJson(resultBody.get("data")), JSONArray.class);
			
			model.addAttribute("mBoardInfo", mBoardInfoVO);
			model.addAttribute("title", mBoardInfoVO.getBoardName());
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
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String primary = userInfo.getPrimary();
		int tenantID = userInfo.getTenantId();
		
		LOGGER.debug("type = " + mBoardInfoVO.getType() + " || boardID = " + mBoardInfoVO.getBoardID() + " || userID = " + userInfo.getId());
		
		mBoardInfoVO.setType("newBoardItemList");
		//mBoardInfoVO.setBoardID("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}");
		//mBoardInfoVO.setBoardID("{6d7b50a2-4777-96a3-4b3a-a670dcd703f1}");
		
		//게시판정보
		mBoardInfoVO = mBoardService.getBoardProperty(mBoardInfoVO.getBoardID(), primary, tenantID);
		mBoardInfoVO = mBoardService.getBoardInfo(mBoardInfoVO, userInfo);
		
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
		String url = gwServerUrl + "/ezboard/"+mBoardInfoVO.getType()+"/boards/"+mBoardInfoVO.getBoardID()+"/list";
		
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
		
		JSONArray list = new JSONArray();
		
		if (status.equals("ok")) {
			Gson gson = new Gson();
			list = gson.fromJson(gson.toJson(resultBody.get("data")), JSONArray.class);
			
			model.addAttribute("mBoardInfo", mBoardInfoVO);
			model.addAttribute("mBoardItemList", list);
		}
		/*JSONArray sample = rest.getForObject(builder.build().encode().toUri(), JSONArray.class);
System.out.println("sampleSize:"+sample.size());		
System.out.println("sample:"+sample);
		model.addAttribute("mBoardInfo", mBoardInfoVO);
		//model.addAttribute("mBoardItemList", mBoardItemList);
		model.addAttribute("mBoardItemList", sample);
		model.addAttribute("mBoardItemListSize", sample.size());*/
		
		LOGGER.debug("getBoardItemList ended.");
		
		return "json";
	}
	
	/**
	 * 모바일 게시판 글 상세화면조회
	 * 게시판종류별로 (일반, 그룹, 익명, 포토, 썸네일, Q&A)
	 */
	@RequestMapping(value = "/mobile/ezBoard/getBoardItem.do")
	public String getBoardItem() throws Exception {
		LOGGER.debug("getBoardItem started.");
		
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
	public String saveBoardItem() throws Exception {
		LOGGER.debug("saveBoardItem started.");
		
		/*if (boardID != null) {
			수정저장
		} else {
			쓰기저장
			
			쓰기 저장 success 에서 알림메일 전송
		}*/
		
		LOGGER.debug("saveBoardItem ended.");
		
		return "";
	}
	
	/**
	 * 모바일 게시판 글 삭제
	 */
	@RequestMapping(value = "/mobile/ezBoard/deleteBoardItem.do")
	public String deleteBoardItem() throws Exception {
		LOGGER.debug("deleteBoardItem started.");
		
		LOGGER.debug("deleteBoardItem ended.");
		
		return "";
	}
}
