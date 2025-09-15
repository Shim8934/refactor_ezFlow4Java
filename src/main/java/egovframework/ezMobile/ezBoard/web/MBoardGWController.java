package egovframework.ezMobile.ezBoard.web;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.security.PrivateKey;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Base64;
import java.util.Base64.Decoder;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.StringJoiner;
import java.util.UUID;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.mail.internet.InternetAddress;
import javax.servlet.http.HttpServletRequest;

import egovframework.ezEKP.ezBoard.dao.EzBoardDAO;
import egovframework.ezEKP.ezBoard.vo.BoardItemVO;
import egovframework.ezMobile.ezBoard.dao.MBoardDAO;
import egovframework.ezEKP.ezBoard.vo.BoardKeywordVO;
import egovframework.let.user.login.vo.LoginVO;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezBoard.vo.BoardAccessVO;
import egovframework.ezEKP.ezBoard.vo.BoardLineReplyVO;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezBoard.vo.MealDataVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EmailImportance;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPersonal.type.NotiPlatform;
import egovframework.ezEKP.ezPersonal.type.NotiType;
import egovframework.ezMobile.ezBoard.service.MBoardService;
import egovframework.ezMobile.ezBoard.vo.MBoardAttachVO;
import egovframework.ezMobile.ezBoard.vo.MBoardFavoriteVO;
import egovframework.ezMobile.ezBoard.vo.MBoardInfoVO;
import egovframework.ezMobile.ezBoard.vo.MBoardItemVO;
import egovframework.ezMobile.ezBoard.vo.MBoardListVO;
import egovframework.ezMobile.ezBoard.vo.MBoardNewListVO;
import egovframework.ezMobile.ezBoard.vo.MBoardTreeVO;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezOption.vo.MOptionVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@RestController
public class MBoardGWController {
	private static final Logger logger = LoggerFactory.getLogger(MBoardGWController.class);
	
	public static final int BUFF_SIZE = 2048;
	
	@Autowired
	private CommonUtil commonUtil;

	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name = "EzBoardService")
	private EzBoardService ezBoardService;
	
	@Resource(name = "EzBoardAdminService")
	private EzBoardAdminService ezBoardAdminService;
	
	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	@Resource(name = "EzOrganAdminService")
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name = "EzEmailService")
	private EzEmailService ezEmailService;
	
	@Resource(name = "MBoardService")
	private MBoardService mBoardService;
	

	@Resource(name = "EzPersonalService")
	private EzPersonalService ezPersonalService;

	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name="MOptionService")
	private MOptionService mOptionService;
	
	@Resource(name = "jspw")
	private String jspw;

	@Resource(name = "MBoardDAO")
	private MBoardDAO mBoardDAO;
	
	/**
	 * 모바일 G/W 게시판 [GET] 새게시물 리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/new-list/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object getBoardMainList(@PathVariable String userId, HttpServletRequest request, Model model) {		
		logger.debug("MOBILE G/W BOARD [GET /mobile/ezboard/new-list/{userId}] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String boardId = request.getParameter("boardID");
			String lastDate = request.getParameter("lastDate");
			String pSearchText = request.getParameter("pSearchText");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			MOptionVO mobileInfo = mOptionService.optionInfo(userId, info.getTenantId());
			String primary = commonUtil.getPrimaryData(mobileInfo.getLang(), info.getTenantId());
			
			logger.debug("serverName = " + serverName + " | boardId = " + boardId + " | lastDate = " + lastDate + " | pSearchText = " + pSearchText + " | primary = " + primary);
			
			MBoardInfoVO boardInfo = new MBoardInfoVO();
			/* 2018-07-05 홍승비 - deptPath에 자신의 ID 빠져있는 부분 추가 */
			String deptPathCode = info.getUserId() + "," + mBoardService.getDeptPathCode(info.getDeptId(), info.getTenantId());
			
			logger.debug("deptPathCode = " + deptPathCode);
			
			boardInfo = mBoardService.getBoardProperty(boardId, primary, info.getTenantId(), info.getUserId());
			boardInfo = mBoardService.getBoardInfo(boardInfo, info.getRollInfo(), deptPathCode, info);

			/* 2018-07-03 홍승비 - 새게시물 리스트 표시 시 deptID, companyID 조건 추가 */
			List<MBoardNewListVO> list = mBoardService.getNewBoardList(userId, commonUtil.getDateStringInUTC(lastDate, info.getOffSet(), true), info.getDeptId(), info.getCompanyId(), info.getTenantId(), info.getOffSet(),pSearchText);
			
			/* 2018-07-03 홍승비 - 새게시물 카운트 표시 시 companyID 조건 추가 */
			int listCount = mBoardService.getNewBoardListCount(userId, "", info.getCompanyId(), info.getTenantId(), pSearchText);
			logger.debug("listCount ="+listCount);
			
			JSONObject data = new JSONObject();
			data.put("list", list);
			data.put("boardInfo", boardInfo);
			data.put("listCount", listCount);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		logger.debug("MOBILE G/W BOARD [GET /mobile/ezboard/new-list/{userId}] ended.");
		
		return result;
	}
	
	
	/**
	 * 모바일 G/W 게시판 [GET] 게시판 리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/boards/{boardId}/list", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object getBoardItemList(@PathVariable String boardId, HttpServletRequest request, Model model) {		
		logger.debug("MOBILE G/W BOARD [GET /ezboard/{type}/boards/{boardId}/list] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userID = request.getParameter("userID");
			String lastDate = request.getParameter("lastDate");
			String add = request.getParameter("add");
			String parentWriteDate = request.getParameter("parentWriteDate");
			String upperitemidtree = request.getParameter("upperitemidtree");
			String pSearchText = request.getParameter("pSearchText");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userID);
			MOptionVO mobileInfo = mOptionService.optionInfo(userID, info.getTenantId());
			String primary = commonUtil.getPrimaryData(mobileInfo.getLang(), info.getTenantId());
			
			logger.debug("serverName = " + serverName + " | userID = " + userID + " | lastDate = " + lastDate + " | add = " + add + " | parentWriteDate = " + parentWriteDate + 
					" | upperitemidtree = " + upperitemidtree + " | pSearchText = " + pSearchText + " | primary = " + primary);
			
			MBoardInfoVO boardInfo = new MBoardInfoVO();
			String deptPathCode = info.getUserId() + "," + mBoardService.getDeptPathCode(info.getDeptId(), info.getTenantId());
			
			logger.debug("deptPathCode = "+deptPathCode);
			
			boardInfo = mBoardService.getBoardProperty(boardId, primary, info.getTenantId(), info.getUserId());
			boardInfo = mBoardService.getBoardInfo(boardInfo, info.getRollInfo(), deptPathCode, info);
			
			List<MBoardItemVO> list = mBoardService.getBoardItemList(boardInfo, info, commonUtil.getDateStringInUTC(lastDate, info.getOffSet(), true),info.getUserId(),add,pSearchText, parentWriteDate, upperitemidtree);
			
			int listCount = 0;
			if (boardInfo.getGuBun() != null && boardInfo.getGuBun().equals("5")) { // qna 게시판
				listCount = mBoardService.getQNABoardItemListCount(boardId, boardInfo, userID, boardInfo.getGuBun(), info.getTenantId(), pSearchText);
			} else {
				listCount = mBoardService.getBoardItemListCount(boardId, userID, boardInfo.getGuBun(), info.getTenantId(), pSearchText, boardInfo.getVersionManage());
			}
			
			for (int i=0; i<list.size(); i++) {
				int listSize = list.size();
				parentWriteDate = list.get(listSize-1).getParentWriteDate();
				upperitemidtree = list.get(listSize-1).getUpperItemIDTree();
			}
			
			//즐겨찾기 여부
			String favoriteYN = mBoardService.checkFavorite(userID, boardId, info.getTenantId());
			logger.debug("listCount : "+listCount);
			
			JSONObject data = new JSONObject();
			data.put("list", list);
			data.put("boardInfo", boardInfo);
			data.put("listCount", listCount);
			data.put("favoriteYN", favoriteYN);
			data.put("parentWriteDate", parentWriteDate);
			data.put("upperitemidtree", upperitemidtree);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		logger.debug("MOBILE G/W BOARD [GET /ezboard/{type}/boards/{boardId}/list] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 게시판 [GET] 즐겨찾기에 등록된 게시판 폴더 리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/favorite-list/users/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object getFavoriteList(@PathVariable String userId,HttpServletRequest request) throws Exception {		
		logger.debug("MOBILE G/W BOARD [GET /ezboard/favorite-list/users/{userId}] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			MOptionVO mobileInfo = mOptionService.optionInfo(userId, info.getTenantId());
			String primary = commonUtil.getPrimaryData(mobileInfo.getLang(), info.getTenantId());
			
			logger.debug("serverName = " + serverName + " | primary = " + primary);
			
			/* 2018-07-03 홍승비 - 게시판 즐겨찾기 리스트에 companyID 조건 추가 */
			List<MBoardFavoriteVO> resultList = mBoardService.getFavoriteList(userId, info.getCompanyId(), info.getTenantId(), primary);

			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", resultList);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}		
		logger.debug("MOBILE G/W BOARD [GET /ezboard/favorite-list/users/{userId}] ended.");
		
		return result;
	}
	
	
	/* 게시물 리스트보기/접근/읽기권한 없을 시 여기에서 예외처리해야 한다. */
	/**
	 * 모바일 G/W 게시판 [GET] 게시물 상세정보
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/{type}/boards/{boardId}/contents/{contentId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object boardDetail(@PathVariable String type,@PathVariable String boardId, @PathVariable String contentId,HttpServletRequest request,Locale locale) throws Exception {		
		logger.debug("MOBILE G/W BOARD [GET /ezboard/{type}/boards/{boardId}/contents/{contentId}] started.");
		
		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		
		try {
			String userID = request.getParameter("userID");
			String serverName = request.getHeader("x-user-host");
			String acScrap = request.getParameter("acScrapBoard");
			
			MCommonVO info = mOptionService.commonInfo(serverName, userID);
			MOptionVO mobileInfo = mOptionService.optionInfo(userID, info.getTenantId());
			
			MBoardItemVO boardItem = mBoardService.getBrdItemInfo(contentId, commonUtil.getPrimaryData(info.getLang(), info.getTenantId()), info.getTenantId());

			String authorization = request.getHeader("Authorization");
			String password = StringUtils.isNotBlank(authorization) ? new String(java.util.Base64.getDecoder().decode(StringUtils.removeStart(authorization, "Basic "))) : "";
			
			
			if (boardItem == null) {
				result.put("status", "empty");
				result.put("code", -1);			
				result.put("data", "");
				return result;
			}
			
			boardItem.setWriteDate(commonUtil.getDateStringInUTC(boardItem.getWriteDate(), info.getOffSet(), false));
			boardItem.setNotiStart(commonUtil.getDateStringInUTC(boardItem.getNotiStart(), info.getOffSet(),false));
			boardItem.setNotiEnd(commonUtil.getDateStringInUTC(boardItem.getNotiEnd(), info.getOffSet(),false));
			boardItem.setUpdateDate(commonUtil.getDateStringInUTC(boardItem.getUpdateDate(), info.getOffSet(),false));
			
			String primary = commonUtil.getPrimaryData(mobileInfo.getLang(), info.getTenantId());
			
			logger.debug("serverName = " + serverName + " | userID = " + userID + " | primary = " + primary);
			
			MBoardInfoVO boardInfo = new MBoardInfoVO();
			
			// 현재 사용자의 부서 경로(자기ID+부서ID+회사ID 전부 ,로 나누어 붙인 문자열) 받아온다.
			String deptPathCode = info.getUserId() + "," + mBoardService.getDeptPathCode(info.getDeptId(), info.getTenantId());
			String attachFileNameMaxLength = ezCommonService.getTenantConfig("attachFileNameMaxLength", info.getTenantId());
			
			logger.debug("deptPathCode = " + deptPathCode + " | attachFileNameMaxLength = " + attachFileNameMaxLength);
			
			boardInfo = mBoardService.getBoardProperty(boardId, primary, info.getTenantId(), info.getUserId());
			boardInfo = mBoardService.getBoardInfo(boardInfo, info.getRollInfo(), deptPathCode, info);
			//상세보기일때 type boardItem으로 지정
			boardInfo.setType("boardItem");
			
			// 해당 게시물 읽기권한 없다면 리턴
			if (!accessCheck(boardId, contentId, deptPathCode, info, password)) {
				result.put("status", "no");
				return result;
			}
		
			if (!boardInfo.getRead_FG().equals("true")) {
				result.put("status", "no");
				return result;
			}
			
			/* 2022-11-16 홍승비 - 모바일 게시물 보기 시 댓글기능 추가 (댓글 카운트 전달) */
			String commentCount = "0";
			if (boardInfo.getOneLineReply() != null && !boardInfo.getOneLineReply().equals("") && !boardInfo.getOneLineReply().equals("0")) {
				commentCount = ezBoardService.getOneLineReplyCount(boardId, contentId, info.getTenantId());
			}
			
			//mht 파일 가져오기
			String realPath = commonUtil.getRealPath(request);
			String domain = request.getServerName() + ":" + request.getServerPort();
	        String scheme = "http://";
			
	    	if (request.getHeader("HTTPS") != null && request.getHeader("HTTPS").toString().toLowerCase().equals("on")) {
	    		scheme = "https://";
	    	}
	    	
			String mhtContent = mBoardService.getMhtContent(realPath, domain, info, boardItem.getContentLocation(), locale, scheme);
			
			// 2025-01-23 게시판 > 게시물 미리보기 > 게시물 평가하기 기능 추가
			Map<String, Object> itemStarRating = ezBoardService.getItemStarRating(contentId, info.getUserId(), info.getTenantId());
			
			//새게시물 눌렀을때, read테이블에 들어가게함.
			mBoardService.setAsRead(info, boardId, contentId);
			
			// 20180824 조진호 - 모바일 viewerflag 값 추가
        	String useMobileViewer = ezCommonService.getTenantConfig("useMobileViewer", info.getTenantId());
			
			List<String> keywords = new ArrayList<>();
			if (boardInfo.getUseKeyword()!= null && boardInfo.getUseKeyword().equals("Y")) {
				List<BoardKeywordVO> keywordsObj = ezBoardService.selectBoardKeywordByBoardItem(contentId, boardId, info.getTenantId());
				keywords = keywordsObj.stream().map(BoardKeywordVO::getKeywordName).collect(Collectors.toList());
			}
			/* 2023-11-22 기민혁 - 해당 게시물에 대해 사용자가 스크랩을 했는지 체크 */
			String isScrap = ezBoardService.getScrapItemCount(userID, contentId, boardId, info.getCompanyId(), info.getTenantId());
			String myBoardScrapFlag = ezCommonService.getTenantConfig("MyBoardScrapFlag", info.getTenantId());
			
        	logger.debug("realPath = " + realPath + " | domain = " + domain + " | scheme = " + scheme + " | useMobileViewer = " + useMobileViewer);
        	
        	data.put("useMobileViewer", useMobileViewer);
			data.put("boardItem", boardItem);
			data.put("content", mhtContent);
			data.put("boardInfo", boardInfo);
			data.put("attachFileNameMaxLength", attachFileNameMaxLength);
			data.put("commentCount", commentCount);
			data.put("keywords", keywords);
			data.put("acScrap", acScrap);
			data.put("myBoardScrapFlag", myBoardScrapFlag);
			data.put("isScrap", isScrap);
			data.put("itemStarRating", itemStarRating);
			
			if ("9".equals(boardInfo.getGuBun())) { // fileViewer 게시판
				BoardItemVO satBoardInfo = ezBoardService.getMsatCallUrl(request, boardInfo, info);
				data.put("satBoardInfo", satBoardInfo);
			}
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}		
		
		logger.debug("MOBILE G/W BOARD [GET /ezboard/{type}/boards/{boardId}/contents/{contentId}] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 게시판 [GET] 포토게시물 상세정보
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/photo/boards/{boardId}/contents/{contentId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object photoBoardDetail(@PathVariable String boardId, @PathVariable String contentId,HttpServletRequest request,Locale locale) throws Exception {		
		logger.debug("MOBILE G/W BOARD [GET /ezboard/photo/boards/{boardId}/contents/{contentId}] started.");
		
		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		
		try {
			String userID = request.getParameter("userID");
			String serverName = request.getHeader("x-user-host");
			String acScrap = request.getParameter("acScrapBoard");
			
			MCommonVO info = mOptionService.commonInfo(serverName, userID);
			MOptionVO mobileInfo = mOptionService.optionInfo(userID, info.getTenantId());
			
			MBoardItemVO boardItem = mBoardService.getBrdItemInfo(contentId, commonUtil.getMultiData(info.getLang(), info.getTenantId()), info.getTenantId());

			String authorization = request.getHeader("Authorization");
			String password = StringUtils.isNotBlank(authorization) ? new String(Base64.getDecoder().decode(StringUtils.removeStart(authorization, "Basic "))) : "";
			
			if (boardItem == null) {
				result.put("status", "empty");
				result.put("code", -1);			
				result.put("data", "");
				return result;
			}
			boardItem.setWriteDate(commonUtil.getDateStringInUTC(boardItem.getWriteDate(), info.getOffSet(), false));
			boardItem.setUpdateDate(commonUtil.getDateStringInUTC(boardItem.getUpdateDate(), info.getOffSet(),false));
			
			//boardInfo
			String primary = commonUtil.getPrimaryData(mobileInfo.getLang(), info.getTenantId());
			
			logger.debug("serverName = " + serverName + " | userID = " + userID + " | primary = " + primary);
			
			MBoardInfoVO boardInfo = new MBoardInfoVO();
			String deptPathCode = info.getUserId() + "," + mBoardService.getDeptPathCode(info.getDeptId(), info.getTenantId());
			
			logger.debug("deptPathCode = "+deptPathCode);
			
			boardInfo = mBoardService.getBoardProperty(boardId, primary, info.getTenantId(), info.getUserId());
			boardInfo = mBoardService.getBoardInfo(boardInfo, info.getRollInfo(), deptPathCode, info);
			
			//썸네일게시판일때 게시물
			boardInfo.setType("photoBoardItem");
			
			// 해당 게시물 읽기권한 없다면 리턴
			if (!accessCheck(boardId, contentId, deptPathCode, info, password)) {
				result.put("status", "no");
				return result;
			}
		
			// getBoardInfo 메서드에서 rollInfo 포함하여 권한 체크+플래그 설정한다.
			if (!boardInfo.getRead_FG().equals("true")) {
				result.put("status", "no");
				return result;
			}
			
			/* 2022-11-16 홍승비 - 모바일 게시물 보기 시 댓글기능 추가 (댓글 카운트 전달) */
			String commentCount = "0";
			if (boardInfo.getOneLineReply() != null && !boardInfo.getOneLineReply().equals("") && !boardInfo.getOneLineReply().equals("0")) {
				commentCount = ezBoardService.getOneLineReplyCount(boardId, contentId, info.getTenantId());
			}
			
			// 2025-01-23 게시판 > 게시물 미리보기 > 게시물 평가하기 기능 추가
			Map<String, Object> itemStarRating = ezBoardService.getItemStarRating(contentId, info.getUserId(), info.getTenantId());
			
			List<MBoardAttachVO> photoList = mBoardService.photoViewDB(contentId, boardId, info.getTenantId());
			
			List<String> keywords = new ArrayList<>();
			if (boardInfo.getUseKeyword() != null && boardInfo.getUseKeyword().equals("Y")) {
				List<BoardKeywordVO> keywordsObj = ezBoardService.selectBoardKeywordByBoardItem(contentId, boardId, info.getTenantId());
				keywords = keywordsObj.stream().map(BoardKeywordVO::getKeywordName).collect(Collectors.toList());
			}
			for (MBoardAttachVO photo : photoList) {
				photo.setFilePath(photo.getFilePath());
			}
				
			String attachFileNameMaxLength = ezCommonService.getTenantConfig("attachFileNameMaxLength", info.getTenantId());
			
			logger.debug("photoList:"+photoList);
			
			mBoardService.setAsRead(info, boardId, contentId);

			/* 2023-11-22 기민혁 - 해당 게시물에 대해 사용자가 스크랩을 했는지 체크 */
			String isScrap = ezBoardService.getScrapItemCount(userID, contentId, boardId, info.getCompanyId(), info.getTenantId());
			String myBoardScrapFlag = ezCommonService.getTenantConfig("MyBoardScrapFlag", info.getTenantId());


			data.put("boardItem", boardItem);
			data.put("boardInfo", boardInfo);
			data.put("photoList", photoList);
			data.put("commentCount", commentCount);
			data.put("keywords", keywords);
			data.put("acScrap", acScrap);
			data.put("myBoardScrapFlag", myBoardScrapFlag);
			data.put("isScrap", isScrap);
			data.put("attachFileNameMaxLength", attachFileNameMaxLength);
			data.put("itemStarRating", itemStarRating);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}		
		
		logger.debug("MOBILE G/W BOARD [GET /ezboard/photo/boards/{boardId}/contents/{contentId}] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 게시판 [GET] 등록화면 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/boards/{boardId}/contents", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object insertBoardSelect(@PathVariable String boardId, HttpServletRequest request,Locale locale) throws Exception {		
		logger.debug("MOBILE G/W BOARD [GET /mobile/ezboard/boards/{boardId}/contents] started.");
		
		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		
		try {
			String userID = request.getParameter("userID");
			String serverName = request.getHeader("x-user-host");
			
			MCommonVO info = mOptionService.commonInfo(serverName, userID);
			MOptionVO mobileInfo = mOptionService.optionInfo(userID, info.getTenantId());
			
			//boardInfo
			String primary = commonUtil.getPrimaryData(mobileInfo.getLang(), info.getTenantId());
			
			logger.debug("serverName = " + serverName + " | userID = " + userID + " | primary = " + primary);
			
			MBoardInfoVO boardInfo = new MBoardInfoVO();
			String deptPathCode = info.getUserId() + "," + mBoardService.getDeptPathCode(info.getDeptId(), info.getTenantId());
			String attachFileNameMaxLength = ezCommonService.getTenantConfig("attachFileNameMaxLength", info.getTenantId());
			
			logger.debug("deptPathCode = " + deptPathCode + " | attachFileNameMaxLength = " + attachFileNameMaxLength);
			
			boardInfo = mBoardService.getBoardProperty(boardId, primary, info.getTenantId(), info.getUserId());
			boardInfo = mBoardService.getBoardInfo(boardInfo, info.getRollInfo(), deptPathCode, info);

			data.put("boardInfo", boardInfo);
			data.put("attachFileNameMaxLength", attachFileNameMaxLength);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}		
		
		logger.debug("MOBILE G/W BOARD [GET /mobile/ezboard/boards/{boardId}/contents] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 게시판 [POST] 게시물 등록
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/boards/contents", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject insertBoard(@RequestBody JSONObject jsonParam, HttpServletRequest request, Locale locale) throws Exception {		
		logger.debug("MOBILE G/W BOARD [POST /ezboard/boards/{boardId}/contents] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName,  jsonParam.get("userID").toString());
			String realPath = commonUtil.getRealPath(request);
			String content = jsonParam.get("mainContent").toString();
			content = content.replaceAll("%(?![0-9a-fA-F]{2})", "%25");
			content = content.replaceAll("\\+", "%2B");
			content = URLDecoder.decode(content, "utf-8");
			
			String scheme = "http://";
	    	if (request.getHeader("HTTPS") != null && request.getHeader("HTTPS").toString().toLowerCase().equals("on")) {
	    		scheme = "https://";
	    	}
	    	
	    	logger.debug("serverName = " + serverName + " | realPath = " + realPath + " | scheme = " + scheme);
			
			content = content.replace("replace_" + scheme, scheme);
			
			logger.debug("content = " + content);
			
			//html -> mht변환
			String mhtData = ezCommonService.startHtml2Mht(content, realPath, locale);
			
			mBoardService.insertBrdItem(jsonParam, info, realPath, mhtData);
			
	        result.put("status", "ok");
			result.put("code", 0);			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
		}	
		
		logger.debug("MOBILE G/W BOARD [POST /ezboard/boards/{boardId}/contents] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 게시판 [PUT] 게시물 수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/boards/{boardId}/contents/{contentId:.+}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject updateBoard(@RequestBody JSONObject jsonParam, HttpServletRequest request, Locale locale) throws Exception {		
		logger.debug("MOBILE G/W BOARD [PUT /ezboard/boards/{boardId}/contents] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName,  jsonParam.get("userID").toString());
			String realPath = commonUtil.getRealPath(request);
			String content = jsonParam.get("mainContent").toString();
			content = content.replaceAll("%(?![0-9a-fA-F]{2})", "%25");
			content = content.replaceAll("\\+", "%2B");
			content = URLDecoder.decode(content, "utf-8");
			
			String scheme = "http://";
	    	if (request.getHeader("HTTPS") != null && request.getHeader("HTTPS").toString().toLowerCase().equals("on")) {
	    		scheme = "https://";
	    	}
	    	
	    	logger.debug("serverName = " + serverName + " | realPath = " + realPath + " | scheme = " + scheme);
	    	
	    	content = content.replace("replace_" + scheme, scheme);
	    	
	    	logger.debug("content = " + content);
			
			//html -> mht변환
			String mhtData = ezCommonService.startHtml2Mht(content, realPath, locale);
			
			mBoardService.updateItem(jsonParam, info, realPath,mhtData);
			
	        result.put("status", "ok");
			result.put("code", 0);			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
		}	
		
		logger.debug("MOBILE G/W BOARD [PUT /ezboard/boards/{boardId}/contents] ended.");
		return result;
	}
	
	/**
	 * 모바일 G/W 게시판 [DELETE] 게시물 삭제
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/boards/{boardId}/contents/{contentId:.+}", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject deleteBoard(@PathVariable String boardId, @PathVariable String contentId, HttpServletRequest request) throws Exception {		
		logger.debug("MOBILE G/W BOARD [DELETE /ezboard/boards/{boardId}/contents] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName,  userId);
			
			logger.debug("serverName = " + serverName + " | userId = " + userId);
			
			/* 2021-08-13 홍승비 - 모바일 게시물 삭제 전에 답변 존재여부 확인 */
			String checkIfHasReply = ezBoardService.brdCheckIfHasReply(contentId, info.getTenantId());
			if (checkIfHasReply.equals("FALSE")) {
				mBoardService.deleteItem(contentId, boardId, info.getTenantId());
				result.put("status", "ok");
				result.put("code", 0);
				result.put("hasReply", "NO");
			} else {
				result.put("status", "ok");
				result.put("code", 0);
				result.put("hasReply", "YES");
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("hasReply", "ERROR");
		}	
		
		logger.debug("MOBILE G/W BOARD [DELETE /ezboard/boards/{boardId}/contents] ended.");
		return result;
	}
	
	/**
	 * 모바일 G/W 게시판 [GET] 좌측메뉴 리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/folder-list", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object getLeftMenu(HttpServletRequest request) throws Exception {		
		logger.debug("MOBILE G/W BOARD [GET /ezboard/folder-list] started.");
		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			String rootBoardID = request.getParameter("rootBoardId");
			int mode = 0;
			String selectBy = request.getParameter("selectBy");
			String excludeBoardID = request.getParameter("excludeBoardId");
			String subFlag = request.getParameter("subFlag");
			
			logger.debug("serverName = " + serverName + " | userId = " + userId + " | rootBoardID = " + rootBoardID + " | selectBy = " + selectBy + " | excludeBoardID " + excludeBoardID +
					" | subFlag = " + subFlag + " | mode = " + mode);
			
			// 여기에 테넌트나 companyID 등의 정보가 담긴다.
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			
			/* 2018-07-03 홍승비 - 좌측메뉴 리스트 표시 시 companyID 조건 추가 */
			List<MBoardTreeVO> list = mBoardService.getBoardTree(rootBoardID, mode, Integer.parseInt(subFlag), Integer.parseInt(selectBy), excludeBoardID, info);
			/* 2018-07-03 홍승비 - 좌측메뉴 리스트 새게시물 카운트 표시 시 companyID 조건 추가 */
			int listCount = mBoardService.getNewBoardListCount(userId, "", info.getCompanyId(), info.getTenantId(), "");
			int listCount2 = mBoardService.getAllNewBoardListCount(userId, "", info.getCompanyId(), info.getTenantId(), "");
			
			int allListCount = mBoardService.getAllBoardItemListCount(userId, info.getCompanyId(), info.getTenantId()); 
			
			// rootBoardId의 guBun 값 전달 > 카테고리게시판인 경우 동작을 막기위함
			if (!rootBoardID.equals("top")) {
				String guBun = mBoardService.getGubun(rootBoardID);
				result.put("guBun",guBun);
			}
			
			String myBoardScrapFlag = ezCommonService.getTenantConfig("MyBoardScrapFlag", info.getTenantId());

			data.put("list", list);
			data.put("listCount", listCount);
			data.put("listCount2", listCount2);

			data.put("allListCount", allListCount);
			data.put("myBoardScrapFlag", myBoardScrapFlag);
			
			if (myBoardScrapFlag.equals("TYPE1")) {
				/* 모바일 스크랩 게시판 게시물 카운트*/
				Map<String, ArrayList<String>> scrapBoardListReadView_FG = mBoardService.getScrapBoardListReadView_FG(info);
				ArrayList<String> scrapBoardListView_FG =  scrapBoardListReadView_FG.get("scrapBoardListView_FG");
				
				int myBoardScrapCount = mBoardService.getScrapBoardListCount(userId, info.getCompanyId(), info.getTenantId(), "", scrapBoardListView_FG);
				data.put("myBoardScrapCount", myBoardScrapCount);
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		logger.debug("MOBILE G/W BOARD [GET /ezboard/folder-list] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 게시판 [POST] 즐겨찾기 설정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/boards/{boardId}/favorite", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject insertFavorite(@PathVariable String boardId,HttpServletRequest request) throws Exception {		
		logger.debug("MOBILE G/W BOARD [POST /ezboard/boards/{boardId}/favorite] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName,  userId);
			String isAllGroupBoard = "";
			
			/* 2018-10-25 홍승비 - 모바일 그룹사게시판 즐겨찾기 분기 추가 */
			BoardPropertyVO boardProp = ezBoardService.getBoardProperty(boardId, info.getTenantId());
			if (boardProp.getBoardGroupID() != null) {
				String boardGroupID = boardProp.getBoardGroupID();
				
				BoardPropertyVO boardGroupProp = ezBoardService.getBoardProperty(boardGroupID, info.getTenantId());
				
				if (boardGroupProp.getGuBun() != null && boardGroupProp.getGuBun().equals("99")) {
					isAllGroupBoard = "Y";
				}
			}
			
			logger.debug("serverName = " + serverName + " | userId = " + userId + " | isAllGroupBoard = " + isAllGroupBoard);
			
			/* 2018-07-04 홍승비 - 모바일 게시판 즐겨찾기 추가 시 companyID 삽입 */
			mBoardService.insertFavorite(info.getUserId(), boardId, info.getCompanyId(), info.getTenantId(), isAllGroupBoard);
			
	        result.put("status", "ok");
			result.put("code", 0);			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
		}	
		
		logger.debug("MOBILE G/W BOARD [POST /ezboard/boards/{boardId}/favorite] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 게시판 [DELETE] 즐겨찾기 해제
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/boards/{boardId}/favorite", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject deleteFavorite(@PathVariable String boardId,HttpServletRequest request) throws Exception {		
		logger.debug("MOBILE G/W BOARD [DELETE /ezboard/boards/{boardId}/favorite] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName,  userId);
			
			logger.debug("serverName = " + serverName + " | userId = " + userId);
			
			mBoardService.deleteFavorite(info.getUserId(), boardId, info.getTenantId());
			
	        result.put("status", "ok");
			result.put("code", 0);			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
		}	
		
		logger.debug("MOBILE G/W BOARD [DELETE /ezboard/boards/{boardId}/favorite] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 게시판 [GET] 게시물 첨부파일 리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/boards/{boardId}/contents/{contentId}/attach-list", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getAttachList(@PathVariable String contentId, HttpServletRequest request) throws Exception {		
		logger.debug("MOBILE G/W BOARD [GET /ezboard/boards/{boardId}/contents/{contentId}/attach-list] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName,  userId);
			
			logger.debug("serverName = " + serverName + " | userId = " + userId);
			
			List<MBoardAttachVO> list = mBoardService.getAttachList(contentId, info.getTenantId());
			
			//파일사이즈 단위 수정
			String fileSize = "";
			for (int i=0; i<list.size(); i++) {
				fileSize = list.get(i).getFileSize();
				
				/* 2023-08-16 홍승비 - 모바일 게시판 > KB, MB 등 단위을 변환하지 않고 사용하기 위한 첨부파일 사이즈(바이트) 추가 */
				list.get(i).setRealFileSize(fileSize);
				
				double fs = Double.parseDouble(fileSize);
				
				if (fs / 1024 / 1024 > 1) {
					fileSize = Math.floor(fs / 1024 / 1024 * 10) / 10 + "MB";
				} else if ((fs / 1024) > 1) {
					fileSize = (int)(fs/1024) + "KB"; 
				} else {
					fileSize = Integer.parseInt(fileSize) + "B";
				}
				
				list.get(i).setFileSize(fileSize);
				//filePath 및 fileName 인코딩
				list.get(i).setEncodeFilePath(URLEncoder.encode(list.get(i).getFilePath(), "UTF-8"));
				list.get(i).setEncodeFileName(URLEncoder.encode(list.get(i).getFileName(), "UTF-8"));
			}
			
	        result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", list);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}	
		
		logger.debug("MOBILE G/W BOARD [GET /ezboard/boards/{boardId}/contents/{contentId}/attach-list] ended.");
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezboard/fileupload", method=RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject mFileUpload(HttpServletRequest request, @RequestBody JSONObject jsonObject) throws Exception {
		logger.debug("MOBILE G/W BOARD [GET /mobile/ezboard/fileupload] started.");
		
		String serverName = request.getHeader("x-user-host");
		
		JSONParser jp = new JSONParser();
		jsonObject = (JSONObject) jp.parse(jsonObject.toJSONString());
		
		JSONObject result = new JSONObject();
		
		try {
			JSONArray fileArray = new JSONArray();
			
			String boardID = "";
			String userID = "";
			int cnt = 0;
			int maxSize = 0;
			
			if (jsonObject.get("fileArray") != null) {
				fileArray = (JSONArray) jsonObject.get("fileArray");
			}
			
			if (jsonObject.get("cnt") != null) {
				cnt =  ((Long) jsonObject.get("cnt")).intValue();
			}
			
			if (jsonObject.get("maxSize") != null) {
				maxSize =  ((Long) jsonObject.get("maxSize")).intValue();
			}
			
			if (jsonObject.get("userID") != null) {
				userID = (String) jsonObject.get("userID");
			}
			
			if (jsonObject.get("boardID") != null) {
				boardID = (String) jsonObject.get("boardID");
			}
			
			logger.debug("cnt = " + cnt + " | maxSize = " + maxSize + " | userID = " + userID);
			logger.debug("serverName = " + serverName + " | boardID = " + boardID);
			
			MCommonVO info = mOptionService.commonInfo(serverName, userID);
			
			String[] pFileName = new String[cnt];
			String realPath = commonUtil.getRealPath(request);
			String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", info.getTenantId());
			String[] sGUID = new String[cnt];
			String[] pUploadSN = new String[cnt];
			Long[] fileSize = new Long[cnt];
			String[] resultUpload = new String[cnt];
			String[] fileLocation = new String[cnt];
			String[] extList = new String[cnt];
			
			 for (int i = 0; i < cnt; i++) {
		            resultUpload[i] = "false";
		            sGUID[i] = UUID.randomUUID().toString();
		            pUploadSN[i] = "{" + sGUID[i] + "}";
		        }
			
			if (useExtension == null) {
				useExtension = "";
			}
			

	        if (((JSONObject)fileArray.get(0)).get("originalFilename") != null && StringUtils.isNotBlank((String) ((JSONObject)fileArray.get(0)).get("originalFilename"))) {
	            for (int i = 0; i < cnt; i++) {
	                String _pFileName = (String) ((JSONObject)fileArray.get(i)).get("originalFilename");
	                
	                if (_pFileName.indexOf(commonUtil.separator) > 0) {
	                    _pFileName = _pFileName.split("/")[_pFileName.split("/").length - 1];
	                }
	                pFileName[i] = _pFileName;
	            }
	        }
			
			String pDirPath = commonUtil.getUploadPath("upload_board.ROOT", info.getTenantId());
			pDirPath = realPath + pDirPath;
			
			if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
	        	pDirPath = pDirPath + commonUtil.separator;
	        }
			
			File file = new File(pDirPath);
	        File file2 = new File(pDirPath + boardID + commonUtil.separator + "uploadFile");
	        
	        if (!file.exists()) {
	        	file.mkdirs();
	        	file2.mkdirs();
	        }
			
	        for (int i = 0; i < cnt; i++) {
	        	fileSize[i] = (Long) ((JSONObject)fileArray.get(i)).get("fileSize");

	            if (fileSize[i] > maxSize) {
	                resultUpload[i] = "overflow";
	            } else {
					// dhlee : 20220527 - 파일 업로드 시 .으로 끝나는 파일(예: .jsp.)이 무조건 업로드 허용되는 문제 수정
					String extStr = pFileName[i].substring(pFileName[i].lastIndexOf(".") + 1).toString().toLowerCase();

                    if ((extStr.isEmpty() || useExtension.toLowerCase().indexOf(extStr) == -1) && !useExtension.equals("*")) {
                        resultUpload[i] = "denied";
                    } else {
                        String pAttachPath = realPath + commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", info.getTenantId()) + commonUtil.separator;
                        File fTemp = new File(pAttachPath, sGUID[i] + "." + extStr);
                        
                        if (!file.exists()) {
                        	fTemp.mkdirs();
                        }
                        
                        mobileBoardWriteUploadedFile((String)((JSONObject)fileArray.get(i)).get("bytes"), sGUID[i] + "." + extStr, pAttachPath);
                        
                        fileLocation[i] = commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", info.getTenantId()) + commonUtil.separator + sGUID[i] + "." + extStr;
                        resultUpload[i] = "true";
						extList[i] = extStr;
                    }
	            }
	        }
			
	        StringBuffer strXML = new StringBuffer();

	        strXML.append("<ROOT><NODES>");
	        
	        for (int i = 0; i < cnt; i++) {
	            strXML.append("<NODE><PUPLOADSN><![CDATA[" + sGUID[i] + "." + extList[i] + "]]></PUPLOADSN>");
	            strXML.append("<RESULTUPLOADA><![CDATA[" + resultUpload[i] + "]]></RESULTUPLOADA>");
	            strXML.append("<PFILENAME><![CDATA[" + pFileName[i] + "]]></PFILENAME>");
	            strXML.append("<FILESIZE>" + fileSize[i] + "</FILESIZE>");
	            strXML.append("<FILELOCATION><![CDATA[" + fileLocation[i] + "]]></FILELOCATION>");
	            strXML.append("</NODE>");
	        }
	        
	        strXML.append("</NODES></ROOT>");
	        
	        result.put("data", strXML);
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("data", "");
			result.put("status", "error");
			result.put("code", 1);
			
			return result;
		} 
		
		logger.debug("MOBILE G/W BOARD [GET /mobile/ezboard/fileupload] ended.");
		
		return result;
	}
	
	/**
     * 첨부파일을 서버에 저장한다.
     *
     * @param bytearray
     * @param newName
     * @param stordFilePath
     * @throws Exception
     */
    public void mobileBoardWriteUploadedFile(String bytearray, String newName, String stordFilePath) throws Exception {
    	logger.debug("mobileBoardWriteUploadedFile");
    	
		InputStream stream = null;
		OutputStream bos = null;
		String stordFilePathReal = (stordFilePath==null?"":stordFilePath);
		
		try {
		    File cFile = new File(stordFilePathReal);
	
		    if (!cFile.isDirectory()) {
				boolean _flag = cFile.mkdirs();
				if (!_flag) {
				    throw new IOException("Directory creation Failed ");
				}
		    }
	
		    bos = new FileOutputStream(stordFilePathReal + File.separator + newName);
		    logger.debug("stordFilePathReal = " + stordFilePathReal + File.separator + newName);
		    Decoder decoder = Base64.getDecoder();

		    bos.write(decoder.decode(bytearray));

		} catch (FileNotFoundException fnfe) {
			logger.debug("fnfe: {}", fnfe);
		} catch (IOException ioe) {
			logger.debug("ioe: {}", ioe);
		} catch (Exception e) {
			logger.debug("e: {}", e);
		} finally {
		    if (bos != null) {
				try {
				    bos.close();
				} catch (Exception ignore) {
					logger.debug("IGNORED: {}", ignore.getMessage());
				}
		    }
		    if (stream != null) {
				try {
				    stream.close();
				} catch (Exception ignore) {
					logger.debug("IGNORED: {}", ignore.getMessage());
				}
		    }
		}
    }
    
    /**
	 * 게시판 게시판권한체크 표출 Method(EzBoardController 참고)
	 */
	public boolean accessCheck(String boardID, String contentID, String deptPath, MCommonVO info, String password) throws Exception {
		logger.debug("accessCheck started");
		
		String rollInfo = info.getRollInfo();
		BoardPropertyVO boardProp = ezBoardService.getBoardProperty(boardID, info.getTenantId());
		MBoardItemVO boardItem = mBoardService.getBrdItemInfo(contentID, commonUtil.getMultiData(info.getLang(), info.getTenantId()), info.getTenantId());
		String boardGroupID = "";
		String isAllGroupBoard = "N";

		/* 2025-08-11 비회원 읽기권한(전체공개) 게시판인 경우 pass */
		String useBoardGuestPermit = ezCommonService.getTenantConfig("useBoardGuestPermit", info.getTenantId());
		if ("YES".equals(useBoardGuestPermit) && ezBoardService.checkGuestPerm(contentID, info.getTenantId(), "I")) {
			return true;
		}
		
		/* 2019-06-10 홍승비 - 게시판그룹의 관리자권한 체크를 위한 쿼리 파라미터 추가(게시판그룹의 관리자권한과 하위게시판의 관리자권한 혼용 방지) */
		boolean isBoardGroup = false;
		if (boardProp.getBoardGroupID() != null) { // 하위게시판
			boardGroupID = boardProp.getBoardGroupID();
			BoardPropertyVO strGroupProp = ezBoardService.getBoardProperty(boardGroupID, info.getTenantId());
			if (strGroupProp.getGuBun() != null && strGroupProp.getGuBun().equals("99")) {
				isAllGroupBoard = "Y";
			}
			isBoardGroup = false;
		} else { // 게시판그룹
			isBoardGroup = true;
		}
		
		StringBuilder deptPathOrgan = new StringBuilder();
		List<String> addJobDeptList = new ArrayList<String>();
		
		/* 2019-09-24 홍승비 - 개인ID 이후, 부서ID 이전 위치에 직위+직책ID (사내겸직 직위 포함) 추가 */
		String userJJID = ezBoardService.getUserJJID(info.getUserId(), info.getCompanyId(), info.getTenantId());
		
		for (int ch = 0; ch < deptPath.split(",").length; ch++) {
			if (ch == 0) { // 0 : userID
				deptPathOrgan.append(deptPath.split(",")[ch].trim());
				deptPathOrgan.append(",").append(userJJID);
			} else {
				deptPathOrgan.append(",").append(deptPath.split(",")[deptPath.split(",").length - (ch)].trim());
			}
		}
		
		String userDeptPath = deptPathOrgan.toString();
		addJobDeptList.add(userDeptPath);
		
		logger.debug("accessCheck userDeptPath in mobile    ::    " + userDeptPath);
		
		List<String> addJobList = ezBoardService.getPDOAddJobDeptID(info.getUserId(), info.getCompanyId(), info.getTenantId());
		StringJoiner addJobStr = new StringJoiner(",");
		addJobStr.add(info.getDeptId());
		if (addJobList != null && addJobList.size() > 0) {
			for (int i = 0; i < addJobList.size(); i++) {
				addJobStr.add(addJobList.get(i));
				String upperDept = ezBoardService.getUpperDeptID(addJobList.get(i), info.getTenantId());
				
				if (upperDept != null && !upperDept.equals("")) {
					boolean loopContinue = true;
					StringJoiner upperDeptStr = new StringJoiner(",");
					upperDeptStr.add(upperDept);
					
					while (loopContinue) {
						String upperDeptLoop = ezBoardService.getUpperDeptID(upperDept, info.getTenantId());
						if (upperDeptLoop != null && !upperDeptLoop.equals("")) {
							upperDeptStr.add(upperDeptLoop);
							upperDept = upperDeptLoop;
						} else {
							loopContinue = false;
						}
					}
					addJobDeptList.add(addJobList.get(i) + "," + upperDeptStr.toString());
				}
			}
		}
		
		Set<String> readFGSetDept = new HashSet<String>();
		Set<String> readFGSetJJ = new HashSet<String>();
		Set<String> userJJIDSet = new HashSet<String>(Arrays.asList(userJJID.split(",")));
		
		boolean rtv = false;
		boolean isUserHasACL = false;
		String tempDeptList = addJobStr.toString();
		int addJobDeptListSize = addJobDeptList.size();
		for (int jl = 0; jl < addJobDeptListSize; jl++) {
			if (isUserHasACL == false) {
				int addJobDeptListPathSize = addJobDeptList.get(jl).split(",").length;
				for (int i = 0; i < addJobDeptListPathSize; i++) {
					int isEqualDept = 0;
					for (int j = 0; j < tempDeptList.split(",").length; j++) {
						if(addJobDeptList.get(jl).split(",")[i].trim().equalsIgnoreCase(tempDeptList.split(",")[j])) {
							isEqualDept = 1;
							break;
						} else {
							isEqualDept = 0;
						}
					}
					
					int isDept = ezBoardService.isDeptChk(addJobDeptList.get(jl).split(",")[i].trim(), info.getTenantId());
					
					/* 2019-09-25 홍승비 - 권한그룹을 포함하여 게시판그룹 관리자권한 체크 */
					// 권한그룹 적용 시 개인권한이 다수 존재 가능하므로, 권한을 리스트로 가져온 뒤 '허용(OK)'기준으로 취합한다.
					String boardGroupAdmin_FG_New = "";
					List<String> boardGroupAdmin_FG_List = ezBoardService.checkIfBoardGroupAdminNew(boardID, addJobDeptList.get(jl).split(",")[i].trim(), info.getTenantId(), isDept, isEqualDept, isBoardGroup);
					if (boardGroupAdmin_FG_List != null && boardGroupAdmin_FG_List.size() > 0) { // 권한이 없으면 공백값을 유지 > 다음 루프 진행
						if (boardGroupAdmin_FG_List.contains("OK")) { // 동일한 우선순위의 권한에 대해서, OK가 하나라도 존재한다면 OK로 판정
							boardGroupAdmin_FG_New = "OK";
						} else {
							boardGroupAdmin_FG_New = "NO";
						}
					}
					
					if (rollInfo != null && ((commonUtil.isAdmin(info.getUserId(), info.getTenantId(), info.getRollInfo(), "c") || boardGroupAdmin_FG_New.equals("OK")) ||
							(isAllGroupBoard.equals("N") && commonUtil.isAdmin(info.getUserId(), info.getTenantId(), info.getRollInfo(), "n;k")))) {
						logger.debug("user has admin roll, accessCheck ended");
						return true;
					} else {
						List<String> resultNewList = new ArrayList<String>();
						boolean resultNew = false;
						
						/* 2019-09-24 홍승비 - 권한그룹 적용하여 읽기권한 '허용' 기준으로 취합을 위해 리스트로 리턴 */
						resultNewList = ezBoardService.getCheckItemIDNew(contentID, "GENERAL", addJobDeptList.get(jl).split(",")[i].trim(), info.getTenantId(), isDept, isEqualDept);
						
						if (resultNewList != null && resultNewList.size() > 0) { // 넘겨준 ACCESSID에  대하여 읽기권한 레코드가 존재
							if (resultNewList.contains("true")) { // 읽기권한 '허용' 기준으로 취합
								resultNew = true;
							} else { // '허용'이 아예 없는 경우 '불가'로 판정
								resultNew = false;
							}
							
							/* 2019-09-24 홍승비 - 읽기권한 체크를 숫자가 아닌 문자열(true/false)로 수정 */
							if (addJobDeptList.get(jl).split(",")[i].equals(info.getUserId())) { // 개인권한
								rtv = resultNew;
								isUserHasACL = true;
								break;
							}
							else if (userJJIDSet.contains(addJobDeptList.get(jl).split(",")[i].trim())) { // 직위, 직책권한
								readFGSetJJ.add(String.valueOf(resultNew));
								// 직위, 직책권한은 전부 루프돌때까지 break 안함
							}
							else { // 부서권한
								readFGSetDept.add(String.valueOf(resultNew));
								break;
							}
						} // 권한이 아예 존재하지 않는 경우, 다음 루프 진행
					}
				}
			}
		}
		
		// 개인권한이 존재하지 않고, 각 사내겸직의 부서경로에 대하여 가져온 읽기권한 중 하나라도 true이면 true 리턴
		if (isUserHasACL == false) {
			if (readFGSetJJ.size() > 0 && readFGSetJJ.contains("true")) { // 직책, 직위권한이 존재
				rtv = true;
			}
			else if (readFGSetJJ.size() == 0 && readFGSetDept.contains("true")) { // 직책, 직위권한 없고 부서권한이 존재
				rtv = true;
			}
		} // 개인, 직위/직책, 부서권한 전부 존재하지 않는다면 false 리턴 (rtv는 디폴트 값이 false임)

		// 2024-11-19 비공개 게시판의경우 관리자와 글쓴이만 접근 가능 - 관리자일경우는 return true 됨
		if (rtv && "N".equals(boardItem.getPublicFlag())) {
			// 익명일 경우 비번 체크
			if ("2".equals(boardProp.getGuBun())) {
				rtv = ezBoardService.chkPasswordAnonymous(boardItem.getItemID(), password, info.getTenantId());
			} else {
				rtv = boardItem.getWriterID().equalsIgnoreCase(info.getUserId());
			}
		}
		
		logger.debug("rtv = " + rtv);
		logger.debug("accessCheck ended2");
		return rtv;
    }
	
	/**
	 * 2019-05-14 홍승비 - 모바일 G/W 게시판 [GET] 동영상게시물 상세정보
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/movie/boards/{boardId}/contents/{contentId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object movieBoardDetail(@PathVariable String boardId, @PathVariable String contentId,HttpServletRequest request,Locale locale) throws Exception {		
		logger.debug("MOBILE G/W BOARD [GET /ezboard/movie/boards/{boardId}/contents/{contentId}] started.");
		
		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		
		try {
			String userID = request.getParameter("userID");
			String serverName = request.getHeader("x-user-host");
			String acScrap = request.getParameter("acScrapBoard");
			
			MCommonVO info = mOptionService.commonInfo(serverName, userID);
			MOptionVO mobileInfo = mOptionService.optionInfo(userID, info.getTenantId());
			
			MBoardItemVO boardItem = mBoardService.getBrdItemInfo(contentId, commonUtil.getMultiData(info.getLang(), info.getTenantId()), info.getTenantId());

			String authorization = request.getHeader("Authorization");
			String password = StringUtils.isNotBlank(authorization) ? new String(Base64.getDecoder().decode(StringUtils.removeStart(authorization, "Basic "))) : "";
			
			if (boardItem == null) {
				result.put("status", "empty");
				result.put("code", -1);			
				result.put("data", "");
				return result;
			}
			
			boardItem.setWriteDate(commonUtil.getDateStringInUTC(boardItem.getWriteDate(), info.getOffSet(), false));
			boardItem.setUpdateDate(commonUtil.getDateStringInUTC(boardItem.getUpdateDate(), info.getOffSet(),false));
			
			String primary = commonUtil.getPrimaryData(mobileInfo.getLang(), info.getTenantId());
			
			logger.debug("serverName = " + serverName + " | userID = " + userID + " | primary = " + primary);
			
			MBoardInfoVO boardInfo = new MBoardInfoVO();
			String deptPathCode = info.getUserId() + "," + mBoardService.getDeptPathCode(info.getDeptId(), info.getTenantId());
			
			logger.debug("deptPathCode = "+deptPathCode);
			
			boardInfo = mBoardService.getBoardProperty(boardId, primary, info.getTenantId(), info.getUserId());
			boardInfo = mBoardService.getBoardInfo(boardInfo, info.getRollInfo(), deptPathCode, info);
			
			// 동영상 게시판 타입
			boardInfo.setType("movieBoardItem");
			
			// 해당 게시물 읽기권한 없다면 리턴
			if (!accessCheck(boardId, contentId, deptPathCode, info, password)) {
				result.put("status", "no");
				return result;
			}
		
			// getBoardInfo 메서드에서 rollInfo 포함하여 권한 체크+플래그 설정한다.
			if (!boardInfo.getRead_FG().equals("true")) {
				result.put("status", "no");
				return result;
			}
			
			/* 2022-11-16 홍승비 - 모바일 게시물 보기 시 댓글기능 추가 (댓글 카운트 전달) */
			String commentCount = "0";
			if (boardInfo.getOneLineReply() != null && !boardInfo.getOneLineReply().equals("") && !boardInfo.getOneLineReply().equals("0")) {
				commentCount = ezBoardService.getOneLineReplyCount(boardId, contentId, info.getTenantId());
			}
			
			// 2025-01-23 게시판 > 게시물 미리보기 > 게시물 평가하기 기능 추가
			Map<String, Object> itemStarRating = ezBoardService.getItemStarRating(contentId, info.getUserId(), info.getTenantId());
			
			List<MBoardAttachVO> movieAttachVO = mBoardService.photoViewDB(contentId, boardId, info.getTenantId());

			List<String> keywords = new ArrayList<>();
			if (boardInfo.getUseKeyword() != null && boardInfo.getUseKeyword().equals("Y")) {
				List<BoardKeywordVO> keywordsObj = ezBoardService.selectBoardKeywordByBoardItem(contentId, boardId, info.getTenantId());
				keywords = keywordsObj.stream().map(BoardKeywordVO::getKeywordName).collect(Collectors.toList());
			}
			
			String attachFileNameMaxLength = ezCommonService.getTenantConfig("attachFileNameMaxLength", info.getTenantId());
			
			logger.debug("movieAttachVO : " + movieAttachVO.get(0));
			
			mBoardService.setAsRead(info, boardId, contentId);

			/* 2023-11-22 기민혁 - 해당 게시물에 대해 사용자가 스크랩을 했는지 체크 */
			String isScrap = ezBoardService.getScrapItemCount(userID, contentId, boardId, info.getCompanyId(), info.getTenantId());
			String myBoardScrapFlag = ezCommonService.getTenantConfig("MyBoardScrapFlag", info.getTenantId());

			data.put("boardItem", boardItem);
			data.put("boardInfo", boardInfo);
			data.put("movieAttachVO", movieAttachVO.get(0));
			data.put("commentCount", commentCount);
			data.put("keywords", keywords);
			data.put("acScrap", acScrap);
			data.put("myBoardScrapFlag", myBoardScrapFlag);
			data.put("isScrap", isScrap);
			data.put("attachFileNameMaxLength", attachFileNameMaxLength);
			data.put("itemStarRating", itemStarRating);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}		
		
		logger.debug("MOBILE G/W BOARD [GET /ezboard/movie/boards/{boardId}/contents/{contentId}] ended.");
		
		return result;
	}
	
	/**
     * 2021-09-07 홍승비 - 게시판의 게시관리자에게 게시알림메일 발송
     */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/boards/{boardId}/sendnoti/admin", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public Object sendBoardAlertNotiAdmin(@PathVariable String boardId, HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W BOARD [POST /mobile/ezboard/boards/{boardId}/sendnoti/admin] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userID = request.getParameter("userID");
			String itemID = request.getParameter("itemID");
			String serverName = request.getHeader("x-user-host");
			
			MCommonVO info = mOptionService.commonInfo(serverName, userID);
			MOptionVO mobileInfo = mOptionService.optionInfo(userID, info.getTenantId());
			String primary = commonUtil.getPrimaryData(mobileInfo.getLang(), info.getTenantId());
			Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(info.getLang()));
			
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = userID + "@" + domainName;
			String password = jspw;
			
			MBoardInfoVO boardInfo = mBoardService.getBoardProperty(boardId, primary, info.getTenantId(), info.getUserId());
			MBoardItemVO boardItem = mBoardService.getBrdItemInfo(itemID, commonUtil.getMultiData(info.getLang(), info.getTenantId()), info.getTenantId());
			
			logger.debug("serverName = " + serverName + " | userID = " + userID + " | itemID = " + itemID + " | primary = " + primary);
			
			String strURL = "Item_View_New('" + boardId + "','" + itemID + "','" + boardInfo.getGuBun() + "');";
	        strURL = "<span id='board_a' style=\"color:blue;cursor:pointer;text-decoration:underline;\" onClick=\"" + strURL + "\">";
			
	        String strDate = commonUtil.getDateStringInUTC(boardItem.getWriteDate(), info.getOffSet(), false); 
	        strDate += "( " + info.getOffSet().split("\\|")[1] + " )";
	        
	        StringBuilder bodyContent = new StringBuilder();

	        /* 2018-10-26 홍승비 - 게시판 게시알림 메일 전송 시 폰트 다국어 설정, 특문처리 추가 */
	        bodyContent.append("<br>" + egovMessageSource.getMessage("ezBoard.t250", locale) + "<br><br>");
	        bodyContent.append("<br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t251", locale) + commonUtil.cleanValue(boardInfo.getBoardName()));
	        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t252", locale) + strDate);
	        
	        if (boardInfo.getGuBun().equals("2")) {
	        	bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t253", locale) + boardItem.getWriterName());
	        } else {
	        	if (primary.equals("1")) {
	        		bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t253", locale) + info.getUserName() + "(" + (info.getTitle() == null || "null".equals(info.getTitle()) ? "" : info.getTitle()) + ", " + info.getDeptName() + ", " + info.getCompanyName() + ")");
	        	} else {
	        		bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t253", locale) + info.getUserName2() + "(" + (info.getTitle2() == null || "null".equals(info.getTitle2()) ? "" : info.getTitle2()) + ", " + info.getDeptName2() + ", " + info.getCompanyName2() + ")");
	        	}
	        }
	        
	        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t254", locale) + strURL + commonUtil.cleanValue(boardItem.getTitle()) + "</a>");
	        
	        String content = commonUtil.createNotiMailContent(bodyContent.toString(), mobileInfo.getTenantId(), locale);
	        String subject = "[" + egovMessageSource.getMessage("ezBoard.t255", locale) + boardInfo.getBoardName() + "] " + boardItem.getTitle();
	        String notiContent = "[" + egovMessageSource.getMessage("ezNotification.hth35", locale) + "]"+ boardInfo.getBoardName() + " - " + boardItem.getTitle();

	        InternetAddress[] toArray = new InternetAddress[1]; // 한번에 한 사람에게만 발송
	        List<BoardAccessVO> list = ezBoardService.getPostNotiMailUserList(boardId, primary, mobileInfo.getTenantId());
	        
	        List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();
	        logger.debug("Sending mail starts");

	        for (BoardAccessVO vo : list) {
	        	Map<String, Object> recipientMap = new HashMap<String, Object>();
				recipientMap.put("userType", "PERSON");
				recipientMap.put("companyId", info.getCompanyId());
				recipientMap.put("cn", vo.getAccessID());
				notiRecipientList.add(recipientMap);
				
	        	try {
	        		InternetAddress from = new InternetAddress();

		        	// 익명게시판의 경우, 관리자에게 게시알림 메일발송 시 게시자 표출명과 임의의 이메일을 사용
		        	if (boardInfo.getGuBun().equals("2")) {
		        		from.setPersonal(boardItem.getWriterName(), "UTF-8");
		        		from.setAddress("AnonyBoardMail@boardmail");
		        	} else {
		        		if (primary.equals("1")) {
		        			from.setPersonal(info.getUserName(), "UTF-8");
		        		} else {
		        			from.setPersonal(info.getUserName2(), "UTF-8");
		        		}
		        		from.setAddress(info.getEmail());
		        	}

		        	String mail = "";

		        	try {
		        		OrganUserVO AccessUserInfo = ezOrganAdminService.getUserInfo(vo.getAccessID(), primary, info.getTenantId());

		        		mail = AccessUserInfo.getMail();
		        		logger.debug("user sendMail : " + mail);
					} catch (Exception e) {
						try {
							OrganDeptVO accessDeptInfo = ezOrganService.getDeptInfo(vo.getAccessID(), primary, info.getTenantId());

							mail = accessDeptInfo.getMail();
							logger.debug("dept sendMail : " + mail);
						} catch (Exception e2) {
							logger.error(e2.getMessage(), e2);
							logger.debug("error in accessID : " + vo.getAccessID()); // 직위, 직책, 권한그룹에 대해 메일발송되지 않음 (2021-09-08 기준 웹 그룹웨어와 동일 스펙)
							continue;
						}
					}

		        	InternetAddress to = new InternetAddress();
		        	to.setPersonal(vo.getAccessName(), "UTF-8");
		        	to.setAddress(mail);

		        	toArray[0] = to;

		        	ezEmailService.sendMail(userEmail, password, locale, from, toArray, null, null, subject, content, false, EmailImportance.NORMAL);
	        	} catch (Exception e) {
	        		logger.debug(e.getMessage());
	        		logger.debug("Sending board mail is failed : " + vo.getAccessID());
	        		continue;
	        	}
	        }
	        
	        logger.debug("Sending mail ends");

	        if (notiRecipientList == null || notiRecipientList.size() == 0) {
				result.put("status", "ok");
				result.put("code", 0);
				result.put("data", null);
				return result;
			}

	        // 2024-03-29 한태훈 - 모바일 > 게시판 > 관리자 신규 게시 통합알림 추가
 			String boardStatus = "";
			String boardType = boardInfo.getGuBun();
			String linkUrl = "";
			String linkUrlMobile = "";

			String tempItemID = encodeURIComponent(itemID);
			String tempBoardID = encodeURIComponent(boardId);
			String tempBoardStatus = encodeURIComponent(boardStatus);
			if (boardType != null && (boardType.equals("4") || boardType.equals("3"))) {
				tempBoardStatus = "photoBoardItem";
			}

			if (boardId.equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")) {
				tempBoardStatus = "newBoardItemList";
			} else {
				tempBoardStatus = "boardItemList";
			}

			switch (boardType) {
			case "3":
			case "4":
				linkUrl += "/ezBoard/boardItemViewPhoto.do?itemID=" + (tempItemID) + "&boardID=" + (tempBoardID);
				linkUrlMobile += "/mobile/ezBoard/photoBoardItem.do?boardID=" + (tempBoardID) + "&itemID=" + (tempItemID) + "&type=photoBoardItem&boardItemListType=" + (tempBoardStatus);
				break;
			case "7":
				linkUrl += "/ezBoard/boardItemViewMovie.do?itemID=" + (tempItemID) + "&boardID=" + (tempBoardID);
				linkUrlMobile += "/mobile/ezBoard/movieBoardItem.do?boardID=" + (tempBoardID) + "&itemID=" + (tempItemID) + "&type=movieBoardItem&boardItemListType=" + (tempBoardStatus);
				break;
			default:
				linkUrl += "/ezBoard/boardItemView.do?itemID=" + (tempItemID) + "&boardID=" + (tempBoardID);
				linkUrlMobile += "/mobile/ezBoard/boardItem.do?boardID=" + (tempBoardID) + "&itemID=" + (tempItemID) + "&type=boardItem&boardItemListType=" + (tempBoardStatus);
				break;
			}

 			Map<String, Object> data = new HashMap<String, Object>();
 			data.put("notiRecipientParam", notiRecipientList);
 			data.put("notiContent", notiContent);
 			data.put("linkUrl", linkUrl);
 			data.put("linkUrlMobile",linkUrlMobile);
 			data.put("etcData", "notChkSetting");
 			data.put("boardType", boardType);

			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
		}		
		
		logger.debug("MOBILE G/W BOARD [GET /ezboard/movie/boards/{boardId}/sendnoti/admin] ended.");
		
		return result;
	}
	
	/**
     * 2021-09-07 홍승비 - 게시판의 일반 사용자들에게 메일 발송
     */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/boards/{boardId}/sendnoti", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public Object sendBoardAlert(@PathVariable String boardId, HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W BOARD [POST /mobile/ezboard/boards/{boardId}/sendnoti] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userID = request.getParameter("userID");
			String itemID = request.getParameter("itemID");
			String mode = request.getParameter("mode");
			String isAllGroupBoard = request.getParameter("isAllGroupBoard");
			String serverName = request.getHeader("x-user-host");
			
			MCommonVO info = mOptionService.commonInfo(serverName, userID);
			MOptionVO mobileInfo = mOptionService.optionInfo(userID, info.getTenantId());
			int tenantID = info.getTenantId();
			String primary = commonUtil.getPrimaryData(mobileInfo.getLang(), tenantID);
			Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(info.getLang()));
			
			String domainName = ezCommonService.getTenantConfig("DomainName", tenantID);
			String userEmail = userID + "@" + domainName;
			String password = jspw;
			List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();
			boolean disableMail = false;

			// 게시판 옵션에서 메일알림을 사용하는 경우에만 발송한다.
			MBoardInfoVO boardInfo = mBoardService.getBoardProperty(boardId, primary, tenantID, info.getUserId());
			MBoardItemVO boardItem = mBoardService.getBrdItemInfo(itemID, commonUtil.getMultiData(info.getLang(), tenantID), tenantID);
			List<HashMap<String, String>> possibleUserInfo = new ArrayList<HashMap<String, String>>();
			HashMap<String, String> recipientIDs = new HashMap<String, String>();
			List<String> notiRecipientIds = new ArrayList<String>();
			String companyID = isAllGroupBoard.equals("Y") ? "" : boardInfo.getCompanyID(); // 회사ID의 경우, 그룹사게시판이 아닌 경우에만 게시판이 속한 회사ID로 세팅한다.
			
			logger.debug("serverName = " + serverName + " | userID = " + userID + " | itemID = " + itemID + " | primary = " + primary);
			

			// 신규 게시물 등록, 수정 알림에 대한 수신인 ID 리턴
			if ((mode.equals("new") && boardInfo.getMailFG_Post() != null && boardInfo.getMailFG_Post().equals("Y")) || (mode.equals("modify") && boardInfo.getMailFG_Mod() != null && boardInfo.getMailFG_Mod().equals("Y"))) {
				List<OrganUserVO> favoriteBoardUserList = ezBoardService.getFavoriteBoardUserList(boardId, info.getCompanyId(), info.getTenantId());
				for (int i = 0; i < favoriteBoardUserList.size(); i++) {
					String writerID = favoriteBoardUserList.get(i).getCn();
					String value = favoriteBoardUserList.get(i).getDisplayName() + ";;" + favoriteBoardUserList.get(i).getMail();
					int tenantId = favoriteBoardUserList.get(i).getTenantId();
					disableMail = ezPersonalService.hasNotiDiableItem(writerID, mode.equals("new") ? NotiType.BOARD_NEW : NotiType.BOARD_MODIFY, NotiPlatform.MAIL, tenantId);
					if (!disableMail) {
				        recipientIDs.put(writerID, value);
					}

					if (!notiRecipientIds.contains(writerID)) {
						notiRecipientIds.add(writerID);
						Map<String, Object> recipientMap = new HashMap<String, Object>();
						recipientMap.put("userType", "PERSON");
						recipientMap.put("companyId", info.getCompanyId());
						recipientMap.put("cn", writerID);
						notiRecipientList.add(recipientMap);
					}
				}
			} else if (mode.equals("comment") && boardInfo.getMailFG_Comment() != null && boardInfo.getMailFG_Comment().equals("Y")) {
				possibleUserInfo = ezBoardService.getCommentNoticeMail(boardId, itemID, info.getLang(), info.getTenantId());

				for (int i = 0; i < possibleUserInfo.size(); i++) {
					String writerID = possibleUserInfo.get(i).get("WRITERID");
					String writerName = possibleUserInfo.get(i).get("WRITERNAME");
					String mail = possibleUserInfo.get(i).get("MAIL");
					int tenantId = Integer.parseInt(possibleUserInfo.get(i).get("TENANT_ID"));
					String value = writerName + ";;" + mail;
					disableMail = ezPersonalService.hasNotiDiableItem(writerID, NotiType.BOARD_COMMENT, NotiPlatform.MAIL, tenantId);
					if (!recipientIDs.containsKey(writerID) && !disableMail) {
						recipientIDs.put(writerID, value);
					}

					notiRecipientIds.add(writerID);
					Map<String, Object> recipientMap = new HashMap<String, Object>();
					recipientMap.put("userType", "PERSON");
					recipientMap.put("companyId", info.getCompanyId());
					recipientMap.put("cn", writerID);
					notiRecipientList.add(recipientMap);
				}
			}
			// 메일발송 하지 않는 경우, 바로 리턴
			else {
				logger.debug("sendBoardAlert ended. (Sending alert is not used for mode [" + mode + "])");
				result.put("status", "ok");
				result.put("code", 0);
				return result;
			}
			
			// 게시물 링크, 게시일 정보 등 생성
			String strURL = "Item_View_New('" + boardId + "','" + itemID + "','" + boardInfo.getGuBun() + "');";
	        strURL = "<span id='board_a' style=\"color:blue;cursor:pointer;text-decoration:underline;\" onClick=\"" + strURL + "\">";
	        String strDate = commonUtil.getDateStringInUTC(boardItem.getWriteDate(), info.getOffSet(), false);
	        strDate += "( " + info.getOffSet().split("\\|")[1] + " )";

			// 메일 본문 생성
			StringBuilder bodyContent = new StringBuilder();
			String content = "";
			String subject = "";


			if (mode.equals("new")) { // 게시판 게시알림 (아래 게시판에 새 게시글이 게시되었습니다.)
				bodyContent.append("<br>" + egovMessageSource.getMessage("ezBoard.t250", locale) + "<br><br>");
		        bodyContent.append("<br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t251", locale) + commonUtil.cleanValue(boardInfo.getBoardName()));
		        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t252", locale) + strDate);
		        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t253", locale) + info.getUserName() + "(" + (info.getTitle() == null || "null".equals(info.getTitle()) ? "" : info.getTitle()) + ", " + info.getDeptName() + ", " + info.getCompanyName() + ")");
		        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t254", locale) + strURL + commonUtil.cleanValue(boardItem.getTitle()) + "</a>");


		        content = commonUtil.createNotiMailContent(bodyContent.toString(), info.getTenantId(), locale);
		        subject = "[" + egovMessageSource.getMessage("ezBoard.t255", locale) + boardInfo.getBoardName() + "] " + boardItem.getTitle();

			} else if (mode.equals("modify")) { // 게시판 수정알림 (아래 게시판의 게시물이 수정되었습니다.)
				bodyContent.append("<br>" + egovMessageSource.getMessage("ezBoard.HSBMail05", locale) + "<br><br>");
		        bodyContent.append("<br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t251", locale) + commonUtil.cleanValue(boardInfo.getBoardName()));
		        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t252", locale) + strDate);
		        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t253", locale) + info.getUserName() + "(" + (info.getTitle() == null || "null".equals(info.getTitle()) ? "" : info.getTitle()) + ", " + info.getDeptName() + ", " + info.getCompanyName() + ")");
		        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t254", locale) + strURL + commonUtil.cleanValue(boardItem.getTitle()) + "</a>");


		        content = commonUtil.createNotiMailContent(bodyContent.toString(), info.getTenantId(), locale);
		        subject = "[" + egovMessageSource.getMessage("ezBoard.HSBMail07", locale) + boardInfo.getBoardName() + "] " + boardItem.getTitle();

			}
			else if (mode.equals("comment")) {
				bodyContent.append("<br>" + egovMessageSource.getMessage("ezBoard.HSBMail06", locale) + "<br><br>");
		        bodyContent.append("<br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t251", locale) + commonUtil.cleanValue(boardInfo.getBoardName()));
		        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t252", locale) + strDate);
		        if (primary.equals("1")) {
		        	bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t253", locale) + info.getUserName() + "(" + (info.getTitle() == null || "null".equals(info.getTitle()) ? "" : info.getTitle()) + ", " + info.getDeptName() + ", " + info.getCompanyName() + ")");
		        } else {
		        	bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t253", locale) + info.getUserName2() + "(" + (info.getTitle2() == null || "null".equals(info.getTitle2()) ? "" : info.getTitle2()) + ", " + info.getDeptName2() + ", " + info.getCompanyName2() + ")");
		        }

		        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t254", locale) + strURL + commonUtil.cleanValue(boardItem.getTitle()) + "</a>");

		        content = commonUtil.createNotiMailContent(bodyContent.toString(), tenantID, locale);
		        subject = "[" + egovMessageSource.getMessage("ezBoard.HSBMail08", locale) + boardInfo.getBoardName() + "] " + boardItem.getTitle();
			}

			// 수신인 ID에 대해 개별 메일발송 실행
			InternetAddress[] toArray = new InternetAddress[1];
			Iterator<String> keys = recipientIDs.keySet().iterator();
			String key = "";

			logger.debug("Sending mail starts");

			while (keys.hasNext()) {
				try {
					key = keys.next(); // userID
					String value = recipientIDs.get(key); // userName;;mail
					String userName = value.split(";;")[0];
					String mail = value.split(";;")[1];

					InternetAddress from = new InternetAddress();
					if (primary.equals("1")) {
						from.setPersonal(info.getUserName(), "UTF-8");
					} else {
						from.setPersonal(info.getUserName2(), "UTF-8");
					}
		        	from.setAddress(info.getEmail());

					InternetAddress to = new InternetAddress();
		        	to.setPersonal(userName, "UTF-8");
		        	to.setAddress(mail);

		        	toArray[0] = to;

		        	ezEmailService.sendMail(userEmail, password, locale, from, toArray, null, null, subject, content, false, EmailImportance.NORMAL);
				} catch (Exception e) {
					logger.debug("Sending board mail is failed : " + key);
					logger.debug(e.getMessage());
					continue;
				}
			}
			logger.debug("Sending mail ends");
			
			// 2024-03-29 한태훈 - 게시판 > 사용자 통합알림 추가 (즐겨찾기 게시판 등록 및 수정 알림, 전체 게시판 답변 및 댓글 알림)
			if (notiRecipientIds == null || notiRecipientIds.size() <= 0) {
				result.put("status", "ok");
				result.put("code", 0);
				result.put("data", null);
				
				logger.debug("MOBILE G/W BOARD [POST /mobile/ezboard/boards/{boardId}/sendnoti] ended.");
				
				return result;
			}
			
			String notiContent = boardInfo.getBoardName() + " - " + boardItem.getTitle();
			
			// 게시물 링크, 게시일 정보 등 생성
			String linkUrl = "";
			String linkUrlMobile = "";
			String boardStatus = "";
			String boardType = boardInfo.getGuBun();
			
			if (boardType != null && (boardType.equals("4") || boardType.equals("3"))) {
				boardStatus = "photoBoardItem";
			}
			
			if (boardId.equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")) {
				boardStatus = "newBoardItemList";
			} else {
				boardStatus = "boardItemList";
			}

			String tempItemID = encodeURIComponent(itemID);
			String tempBoardId = encodeURIComponent(boardId);
			boardStatus = encodeURIComponent(boardStatus);

			switch (boardType) {
			case "3":
			case "4":
				linkUrl += "/ezBoard/boardItemViewPhoto.do?itemID=" + (tempItemID) + "&boardID=" + (tempBoardId);
				linkUrlMobile += "/mobile/ezBoard/photoBoardItem.do?boardID=" + (tempBoardId) + "&itemID=" + (tempItemID) + "&type=photoBoardItem&boardItemListType=" + (boardStatus);
				break;
			case "7":
				linkUrl += "/ezBoard/boardItemViewMovie.do?itemID=" + (tempItemID) + "&boardID=" + (tempBoardId);
				linkUrlMobile += "/mobile/ezBoard/movieBoardItem.do?boardID=" + (tempBoardId) + "&itemID=" + (tempItemID) + "&type=movieBoardItem&boardItemListType=" + (boardStatus);
				break;
			default:
				linkUrl += "/ezBoard/boardItemView.do?itemID=" + (tempItemID) + "&boardID=" + (tempBoardId);
				linkUrlMobile += "/mobile/ezBoard/boardItem.do?boardID=" + (tempBoardId) + "&itemID=" + (tempItemID) + "&type=boardItem&boardItemListType=" + (boardStatus);
				break;
			}

			Map<String, Object> data = new HashMap<String, Object>();
			data.put("notiRecipientParam", notiRecipientList );
			data.put("notiContent", notiContent);
			data.put("linkUrl", linkUrl);
			data.put("linkUrlMobile",linkUrlMobile);
			data.put("boardType",boardType);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", null);
		}
		
		logger.debug("MOBILE G/W BOARD [POST /mobile/ezboard/boards/{boardId}/sendnoti] ended.");
		
		return result;
	}
	
	/**
	 * 게시판 게시물 접근 + 리스트보기 권한 체크하여 권한이 허용인 개인 ID를 리스트로 리턴
	 */
	public boolean accessListViewFGCheck(String boardID, String gubun, String userID, String deptID, String deptPathCode, String rollInfo, String isAllGroupBoard, String companyID, int tenantID) throws Exception {
		logger.debug("accessListViewFGCheck started");
		
		// 현재 소속 회사의 사내겸직이 존재하면 사내겸직부서ID와 그 상위부서ID까지 권한체크에 포함
		boolean isBoardGroup = false; // 게시물 등록은 하위게시판에서 실행됨
		String deptPath = deptPathCode;
		StringBuilder deptPathOrgan = new StringBuilder();
		List<String> addJobDeptList = new ArrayList<String>();
		
		/* 2019-09-24 홍승비 - 개인ID 이후, 부서ID 이전 위치에 직위+직책ID (사내겸직 직위 포함) 추가 */
		String userJJID = ezBoardService.getUserJJID(userID, companyID, tenantID);
		
		for (int ch = 0; ch < deptPath.split(",").length; ch++) {
			if (ch == 0) { // 0 : userID
				deptPathOrgan.append(deptPath.split(",")[ch].trim());
				deptPathOrgan.append(",").append(userJJID);
			} else {
				deptPathOrgan.append(",").append(deptPath.split(",")[deptPath.split(",").length - (ch)].trim());
			}
		}
		
		String userDeptPath = deptPathOrgan.toString();
		addJobDeptList.add(userDeptPath);
		
		//logger.debug("accessListViewFGCheck for userID[" + userID + "] userDeptPath in web    ::    " + userDeptPath);
		
		List<String> addJobList = ezBoardService.getPDOAddJobDeptID(userID, companyID, tenantID);
		StringJoiner addJobStr = new StringJoiner(",");
		addJobStr.add(deptID);
		if (addJobList != null && addJobList.size() > 0) {
			for (int i = 0; i < addJobList.size(); i++) {
				addJobStr.add(addJobList.get(i));
				String upperDept = ezBoardService.getUpperDeptID(addJobList.get(i), tenantID);
				
				if (upperDept != null && !upperDept.equals("")) {
					boolean loopContinue = true;
					StringJoiner upperDeptStr = new StringJoiner(",");
					upperDeptStr.add(upperDept);
					
					while (loopContinue) {
						String upperDeptLoop = ezBoardService.getUpperDeptID(upperDept, tenantID);
						if (upperDeptLoop != null && !upperDeptLoop.equals("")) {
							upperDeptStr.add(upperDeptLoop);
							upperDept = upperDeptLoop;
						} else {
							loopContinue = false;
						}
					}
					addJobDeptList.add(addJobList.get(i) + "," + upperDeptStr.toString());
				}
			}
		}
		
		Set<String> readFGSetDept = new HashSet<String>();
		Set<String> readFGSetJJ = new HashSet<String>();
		Set<String> userJJIDSet = new HashSet<String>(Arrays.asList(userJJID.split(",")));
		
		boolean rtv = false;
		boolean isUserHasACL = false;
		String tempDeptList = addJobStr.toString();
		int addJobDeptListSize = addJobDeptList.size();
		for (int jl = 0; jl < addJobDeptListSize; jl++) {
			if (isUserHasACL == false) {
				int addJobDeptListPathSize = addJobDeptList.get(jl).split(",").length;
				for (int i = 0; i < addJobDeptListPathSize; i++) {
					int isEqualDept = 0;
					for (int j = 0; j < tempDeptList.split(",").length; j++) {
						if(addJobDeptList.get(jl).split(",")[i].trim().equalsIgnoreCase(tempDeptList.split(",")[j])) {
							isEqualDept = 1;
							break;
						} else {
							isEqualDept = 0;
						}
					}
					
					int isDept = ezBoardService.isDeptChk(addJobDeptList.get(jl).split(",")[i].trim(), tenantID);
					
					/* 2019-09-24 홍승비 - 권한그룹을 포함하여 게시판그룹 관리자권한 체크 */
					// 권한그룹 적용 시 개인권한이 다수 존재 가능하므로, 권한을 리스트로 가져온 뒤 '허용(OK)'기준으로 취합한다.
					String boardGroupAdmin_FG_New = "";
					List<String> boardGroupAdmin_FG_List = ezBoardService.checkIfBoardGroupAdminNew(boardID, addJobDeptList.get(jl).split(",")[i].trim(), tenantID, isDept, isEqualDept, isBoardGroup);
					if (boardGroupAdmin_FG_List != null && boardGroupAdmin_FG_List.size() > 0) { // 권한이 없으면 공백값을 유지 > 다음 루프 진행
						if (boardGroupAdmin_FG_List.contains("OK")) { // 동일한 우선순위의 권한에 대해서, OK가 하나라도 존재한다면 OK로 판정
							boardGroupAdmin_FG_New = "OK";
						} else {
							boardGroupAdmin_FG_New = "NO";
						}
					}
					
					if (rollInfo != null && ((commonUtil.isAdmin(userID, tenantID, rollInfo, "c") || boardGroupAdmin_FG_New.equals("OK")) ||
							(isAllGroupBoard.equals("N") && commonUtil.isAdmin(userID, tenantID, rollInfo, "n;k")))) {
						logger.debug("user has admin roll, accessListViewFGCheck ended");
						return true;
					} else {
						List<String> resultNewList = new ArrayList<String>();
						boolean resultNew = false;
						
						// 접근 + 리스트보기 '허용' 기준으로 취합을 위해 리스트로 리턴 (QNA게시판인 경우, 관리자 권한을 체크함)
						resultNewList = ezBoardService.getBoardAccessListViewFG(boardID, gubun, addJobDeptList.get(jl).split(",")[i].trim(), tenantID, isDept, isEqualDept);
						
						if (resultNewList != null && resultNewList.size() > 0) { // 넘겨준 ACCESSID에  대하여 접근 + 리스트보기권한 레코드가 존재
							if (resultNewList.contains("true")) { // 접근 + 리스트보기권한 '허용' 기준으로 취합
								resultNew = true;
							} else { // '허용'이 아예 없는 경우 '불가'로 판정
								resultNew = false;
							}
							
							/* 2019-09-24 홍승비 - 읽기권한 체크를 숫자가 아닌 문자열(true/false)로 수정 */
							if (addJobDeptList.get(jl).split(",")[i].equals(userID)) { // 개인권한
								rtv = resultNew;
								isUserHasACL = true;
								break;
							}
							else if (userJJIDSet.contains(addJobDeptList.get(jl).split(",")[i].trim())) { // 직위, 직책권한
								readFGSetJJ.add(String.valueOf(resultNew));
								// 직위, 직책권한은 전부 루프돌때까지 break 안함
							}
							else { // 부서권한
								readFGSetDept.add(String.valueOf(resultNew));
								break;
							}
						} // 권한이 아예 존재하지 않는 경우, 다음 루프 진행
					}
				}
			}
		}
		
		// 개인권한이 존재하지 않고, 각 사내겸직의 부서경로에 대하여 가져온 접근 + 리스트보기권한 중 하나라도 true이면 true 리턴
		if (isUserHasACL == false) {
			if (readFGSetJJ.size() > 0 && readFGSetJJ.contains("true")) { // 직책, 직위권한이 존재
				rtv = true;
			}
			else if (readFGSetJJ.size() == 0 && readFGSetDept.contains("true")) { // 직책, 직위권한 없고 부서권한이 존재
				rtv = true;
			}
		} // 개인, 직위/직책, 부서권한 전부 존재하지 않는다면 false
		
		logger.debug("accessListViewFGCheck for userID[" + userID + "] ended. rtv   ::   " + rtv);
		return rtv;
    }
	
	/**
	 * 2022-11-16 홍승비 - 모바일 G/W 게시판 [GET] 게시물 댓글 리스트 (JSON 형식으로 리턴)
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/boards/{boardId}/contents/{contentId}/comment-list", method=RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getCommentList(@PathVariable String boardId, @PathVariable String contentId, HttpServletRequest request) throws Exception {		
		logger.debug("MOBILE G/W BOARD [GET /ezboard/boards/{boardId}/contents/{contentId}/comment-list] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userID = request.getParameter("userID");
			String gubun = request.getParameter("gubun");
			String userName = "";
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName,  userID);
			String sort = request.getParameter("sort");
			sort = StringUtils.isBlank(sort) ? "earliest" : sort;
			String primary = info.getPrimary();
			
			logger.debug("serverName = " + serverName + " | userId = " + userID);
			
			userName = "USERNAME" + commonUtil.getMultiData(info.getLang(), info.getTenantId());
			
	    	List<BoardLineReplyVO> boardLineReplyVOList = ezBoardService.readOneLineReply(boardId, contentId, primary, gubun, info.getCompanyId(), info.getTenantId(), sort);
	    	
	    	// 댓글의 작성일자 UTC시간 계산하여 각 VO에 설정
	    	for (BoardLineReplyVO reply : boardLineReplyVOList) {
	    		reply.setWriteDate(commonUtil.getDateStringInUTC(reply.getWriteDate(), info.getOffSet(), false));
	    	}
			
	        result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", boardLineReplyVOList);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}	
		
		logger.debug("MOBILE G/W BOARD [GET /ezboard/boards/{boardId}/contents/{contentId}/comment-list] ended.");
		
		return result;
	}
	
	/**
	 * 2022-11-18 홍승비 - 모바일 G/W 게시판 [POST] 게시물 댓글 작성 및 저장
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/boards/{boardId}/contents/{contentId}/comments/{replyID}", method=RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject saveBoardComment(@PathVariable String boardId, @PathVariable String contentId, @PathVariable String replyID, HttpServletRequest request) throws Exception {		
		logger.debug("MOBILE G/W BOARD [POST /ezboard/boards/{boardId}/contents/{contentId}/comments/{replyID}] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userID = request.getParameter("userID");
			String content = request.getParameter("content");
			String imageContent = request.getParameter("imageContent"); // 2023-11-16 전인하 - 모바일 > 게시판 > 이모티콘 삽입 > 이모티콘 정보 추가
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName,  userID);
			
			logger.debug("serverName = " + serverName + " | userId = " + userID);
			
			content = content.replace("'", "''");
			
			mBoardService.saveOneLineReply(contentId, replyID, boardId, userID, info.getUserName(), info.getUserName2(), info.getTenantId(), info.getCompanyId(), content, imageContent);
			
			// 댓글 첨부 저장
			String attach = request.getParameter("attach");
			String realPath = commonUtil.getRealPath(request);
			ezBoardService.saveCommentAttachment(attach, replyID, contentId, boardId, realPath, info.getTenantId());
			
	        result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}	
		
		logger.debug("MOBILE G/W BOARD [POST /ezboard/boards/{boardId}/contents/{contentId}/comments/{replyID}] ended.");
		
		return result;
	}
	
	/**
	 * 2022-11-18 홍승비 - 모바일 G/W 게시판 [GET] 게시물 댓글 카운트 반환
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/boards/{boardId}/contents/{contentId}/comment-count", method=RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject saveBoardComment(@PathVariable String boardId, @PathVariable String contentId, HttpServletRequest request) throws Exception {		
		logger.debug("MOBILE G/W BOARD [GET /ezboard/boards/{boardId}/contents/{contentId}/comment-count] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userID = request.getParameter("userID");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName,  userID);
			
			logger.debug("serverName = " + serverName + " | userId = " + userID);
			
			String commentCount = ezBoardService.getOneLineReplyCount(boardId, contentId, info.getTenantId());
			
	        result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", commentCount);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}	
		
		logger.debug("MOBILE G/W BOARD [GET /ezboard/boards/{boardId}/contents/{contentId}/comment-count] ended.");
		
		return result;
	}
	
	/**
	 * 2022-11-18 홍승비 - 모바일 G/W 게시판 [DELETE] 게시물 댓글 삭제
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/boards/{boardId}/contents/{contentId}/comments/{replyID}", method=RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject deleteBoardComment(@PathVariable String boardId, @PathVariable String contentId, @PathVariable String replyID, HttpServletRequest request) throws Exception {		
		logger.debug("MOBILE G/W BOARD [DELETE /ezboard/boards/{boardId}/contents/{contentId}/comments/{replyID}] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userID = request.getParameter("userID");
			String gubun = request.getParameter("gubun");
			String replyLevel = request.getParameter("replyLevel");
			String parentReplyID = request.getParameter("parentReplyID");
			String serverName = request.getHeader("x-user-host");
			String itemID = request.getHeader("itemID");
			MCommonVO info = mOptionService.commonInfo(serverName,  userID);
			
			logger.debug("serverName = " + serverName + " | userId = " + userID);
			
			// 모바일 게시판에서는 익명게시물에 댓글을 작성하거나 삭제할 수 없으며, 이후 모바일 게시물에 암호기능이 추가되는 경우 이 주석을 해제하여 사용 가능
			/*
			if (info.getRollInfo().indexOf("c=1") > -1 || info.getRollInfo().indexOf("k=1") > -1 || info.getRollInfo().indexOf("n=1") > -1) {
				gubun = "2";
			}
			*/				
			
			String resStr = "";
			if (Integer.parseInt(replyLevel) != 1) { // 최상위부모댓글이 아닌 경우
				resStr = ezBoardService.deleteOneLineReply(userID, replyID, itemID, gubun, info.getTenantId()); // 무조건 삭제
				int sibilingsCnt = ezBoardService.getChildReplyCnt(contentId, boardId, parentReplyID, info.getTenantId()); // 형제댓글 갯수
				int parentReplyExistFlag = mBoardService.checkThisReplyExist(parentReplyID, contentId, info.getTenantId()); // 부모댓글 실존여부 (존재할경우 1, 아니면 0)
				if (sibilingsCnt == 0 && parentReplyExistFlag == 0) { // 형제댓글이 존재하지 않고, 부모댓글은 이미 지워진 상태일 때 null 삽입되어있던 부모댓글을 지운다.
					ezBoardService.deleteOneLineReply("", parentReplyID, itemID, gubun, info.getTenantId());
				}
			} else { // 최상위 부모댓글인 경우 자식 댓글이 존재한다면 null 삽입, 자식댓글이 없다면 일반 삭제.
				int childCnt = ezBoardService.getChildReplyCnt(contentId, boardId, replyID, info.getTenantId());
				if (childCnt == 0) {
					resStr = ezBoardService.deleteOneLineReply(userID, replyID, itemID, gubun, info.getTenantId());
				} else {
					ezBoardService.updateDelParentReply(replyID, contentId, boardId, info.getTenantId());
					resStr = "OK_DELETED";
				}
			}
			
	        result.put("status", resStr);
			result.put("code", 0);			
			result.put("data", "");
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}	
		
		logger.debug("MOBILE G/W BOARD [DELETE /ezboard/boards/{boardId}/contents/{contentId}/comments/{replyID}] ended.");
		
		return result;
	}

	// 2024-03-29 한태훈 - java에서 encodeURIComponent 메소드 구현
	public String encodeURIComponent(String s) throws Exception {
	    String result = null;
    	result = URLEncoder.encode(s, "UTF-8")
                         .replaceAll("\\+", "%20")
                         .replaceAll("\\%21", "!")
                         .replaceAll("\\%27", "'")
                         .replaceAll("\\%28", "(")
                         .replaceAll("\\%29", ")")
                         .replaceAll("\\%7E", "~");
		return result;
	}

	/* 2023-11-13 전인하 - 모바일 게시판 댓글 수정 */
	@RequestMapping(value="/mobile/ezboard/boards/{boardId}/contents/{contentId}/comments/{replyID}", method=RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject updateBoardComment(@PathVariable String boardId, @PathVariable String contentId, @PathVariable String replyID, HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W BOARD [PUT /ezboard/boards/{boardId}/contents/{contentId}/comments/{replyID}] started.");

		JSONObject result = new JSONObject();

		try {
			String userID = request.getParameter("userID");
			String content = request.getParameter("content");
			String imageContent = request.getParameter("imageContent"); // 2023-11-16 전인하 - 모바일 > 게시판 > 이모티콘 삽입 > 이모티콘 정보 추가
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName,  userID);

			logger.debug("serverName = " + serverName + " | userId = " + userID);

			content = content.replace("'", "''");
			
			mBoardService.updateOneLineReply(contentId, replyID, content, info.getTenantId(), imageContent);
			
			// 댓글 첨부 저장
			String attach = request.getParameter("attach");
			String realPath = commonUtil.getRealPath(request);
			ezBoardService.saveCommentAttachment(attach, replyID, contentId, boardId, realPath, info.getTenantId());

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		logger.debug("MOBILE G/W BOARD [PUT /ezboard/boards/{boardId}/contents/{contentId}/comments/{replyID}] ended.");

		return result;
	}

	/* 2023-11-13 전인하 - 모바일 게시판 대댓글 작성 */
	@RequestMapping(value="/mobile/ezboard/boards/{boardId}/contents/{contentId}/replyComments/{replyID}", method=RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject insertReplyBoardComment(@PathVariable String boardId, @PathVariable String contentId, @PathVariable String replyID, HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W BOARD [POST /ezboard/boards/{boardId}/contents/{contentId}/replyComments/{replyID}] started.");

		JSONObject result = new JSONObject();

		try {
			String userID = request.getParameter("userID");
			String content = request.getParameter("content");
			String parentReplyID = request.getParameter("parentReplyID");
			String imageContent = request.getParameter("imageContent"); // 2023-11-16 전인하 - 모바일 > 게시판 > 이모티콘 삽입 > 이모티콘 정보 추가
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName,  userID);

			logger.debug("serverName = " + serverName + " | userId = " + userID);

			content = content.replace("'", "''");

			// 패스워드 삽입 로직
			// 추후 모바일 익명게시판에서 댓글 지원할 때 아래 password 변수에 "" 대신 사용자가 입력한 비밀번호를 삽입하면 됨
			// 현시점에서는 모바일 익명게시판에서 댓글 지원하지 않으므로 단순 null에러 방지 목적으로 삽입함
			String password = "";
			String prm = egovFileScrty.getPrm();
			String pre = egovFileScrty.getPre();
			PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);

			String rpwd = EgovFileScrty.decryptRsa(pk, "");
			password = EgovFileScrty.encryptPassword(rpwd, "unknown");
			
			mBoardService.saveOneLineReReply(contentId, boardId, replyID, parentReplyID, content, password, info, imageContent);
			
			// 댓글 첨부 저장
			String attach = request.getParameter("attach");
			String realPath = commonUtil.getRealPath(request);
			ezBoardService.saveCommentAttachment(attach, replyID, contentId, boardId, realPath, info.getTenantId());

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1); 
			result.put("data", "");
		}

		logger.debug("MOBILE G/W BOARD [POST /ezboard/boards/{boardId}/contents/{contentId}/replyComments/{replyID}] ended.");

	    return result;
	}

	/**
	 * 모바일 G/W 게시판 [GET] 최근게시물 리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/allnew-list/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object getBoardMainNewList(@PathVariable String userId, HttpServletRequest request, Model model) {
		logger.debug("MOBILE G/W BOARD [GET /mobile/ezboard/allnew-list/{userId}] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String boardId = request.getParameter("boardID");
			String lastDate = request.getParameter("lastDate");
			String pSearchText = request.getParameter("pSearchText");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			MOptionVO mobileInfo = mOptionService.optionInfo(userId, info.getTenantId());
			String primary = commonUtil.getPrimaryData(mobileInfo.getLang(), info.getTenantId());

			logger.debug("serverName = " + serverName + " | boardId = " + boardId + " | lastDate = " + lastDate + " | pSearchText = " + pSearchText + " | primary = " + primary);

			MBoardInfoVO boardInfo = new MBoardInfoVO();

			String deptPathCode = info.getUserId() + "," + mBoardService.getDeptPathCode(info.getDeptId(), info.getTenantId());

			logger.debug("deptPathCode = " + deptPathCode);

			boardInfo = mBoardService.getBoardProperty(boardId, primary, info.getTenantId(), info.getUserId());
			boardInfo = mBoardService.getBoardInfo(boardInfo, info.getRollInfo(), deptPathCode, info);
			
			List<MBoardNewListVO> list = mBoardService.getAllNewBoardList(userId, commonUtil.getDateStringInUTC(lastDate, info.getOffSet(), true), info.getDeptId(), info.getCompanyId(), info.getTenantId(), info.getOffSet(),pSearchText);
			
			int listCount = mBoardService.getAllNewBoardListCount(userId, "", info.getCompanyId(), info.getTenantId(), pSearchText);
			logger.debug("listCount ="+listCount);

			JSONObject data = new JSONObject();
			data.put("list", list);
			data.put("boardInfo", boardInfo);
			data.put("listCount", listCount);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		logger.debug("MOBILE G/W BOARD [GET /mobile/ezboard/allnew-list/{userId}] ended.");

		return result;
	}

	/**
	 * 익명게시판 비번체크
	 */
	@RequestMapping(value = "/mobile/ezboard/boards/private", method = RequestMethod.GET ,produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String chkPasswordAnonymous(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie) {
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			String itemID = request.getParameter("itemID");
			String password = request.getParameter("pw");
			return ezBoardService.chkPasswordAnonymous(itemID, password, userInfo.getTenantId()) ? "Y" : "N";
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			return "N";
		}
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/all-list/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object getAllBoardList(@PathVariable String userId, HttpServletRequest request, Model model) {		
		logger.debug("MOBILE G/W BOARD [GET /mobile/ezboard/all-list/{userId}] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String boardId = request.getParameter("boardID");
			String lastDate = request.getParameter("lastDate");
			String pSearchText = request.getParameter("pSearchText");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			MOptionVO mobileInfo = mOptionService.optionInfo(userId, info.getTenantId());
			String primary = commonUtil.getPrimaryData(mobileInfo.getLang(), info.getTenantId());
			
			logger.debug("serverName = " + serverName + " | boardId = " + boardId + " | lastDate = " + lastDate + " | pSearchText = " + pSearchText + " | primary = " + primary);
			
			MBoardInfoVO boardInfo = new MBoardInfoVO();
			/* 2018-07-05 홍승비 - deptPath에 자신의 ID 빠져있는 부분 추가 */
			String deptPathCode = info.getUserId() + "," + mBoardService.getDeptPathCode(info.getDeptId(), info.getTenantId());
			
			logger.debug("deptPathCode = " + deptPathCode);
			
			boardInfo = mBoardService.getBoardProperty(boardId, primary, info.getTenantId(), info.getUserId());
			boardInfo = mBoardService.getBoardInfo(boardInfo, info.getRollInfo(), deptPathCode, info);

			List<MBoardListVO> list = mBoardService.getAllBoardItemList(userId, commonUtil.getDateStringInUTC(lastDate, info.getOffSet(), true), info.getDeptId(), info.getCompanyId(), info.getTenantId(), info.getOffSet());
			
			int listCount = mBoardService.getAllBoardItemListCount(userId, info.getCompanyId(), info.getTenantId());
			logger.debug("listCount ="+listCount);
			
			JSONObject data = new JSONObject();
			data.put("list", list);
			data.put("boardInfo", boardInfo);
			data.put("listCount", listCount);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		logger.debug("MOBILE G/W BOARD [GET /mobile/ezboard/all-list/{userId}] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 게시판 [POST] 스크랩 설정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/boards/boardID/{boardId}/itemID/{itemId}/scrap", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject insertScrap(@PathVariable String boardId,@PathVariable String itemId,HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W BOARD [POST /ezboard/boards/boardID/{boardId}/itemID/{itemId}/scrap] started.");

		JSONObject result = new JSONObject();

		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName,  userId);

			logger.debug("serverName = " + serverName + " | userId = " + userId);

			String ScrapCheck = ezBoardService.getScrapItemCount(info.getUserId(),itemId,boardId,info.getCompanyId(),info.getTenantId());

			if(ScrapCheck == "true"){
				ScrapCheck = ezBoardService.setScrapItem(info.getUserId(),itemId,boardId,info.getCompanyId(),info.getTenantId());
			}

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
		}

		logger.debug("MOBILE G/W BOARD [POST /ezboard/boards/boardID/{boardId}/itemID/{itemId}/scrap] ended.");

		return result;
	}

	/**
	 * 모바일 G/W 게시판 [DELETE] 스크랩 해제
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/boards/boardID/{boardId}/itemID/{itemId}/scrap", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject deleteScrap(@PathVariable String boardId,@PathVariable String itemId,HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W BOARD [DELETE /ezboard/boards/boardID/{boardId}/itemID/{itemId}/scrap] started.");

		JSONObject result = new JSONObject();

		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName,  userId);

			logger.debug("serverName = " + serverName + " | userId = " + userId);

			String ScrapCheck = ezBoardService.getScrapItemCount(info.getUserId(),itemId,boardId,info.getCompanyId(),info.getTenantId());

			if(ScrapCheck == "false"){
				ScrapCheck = ezBoardService.delScrapItem(info.getUserId(),itemId,boardId,info.getCompanyId(),info.getTenantId());
			}

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
		}

		logger.debug("MOBILE G/W BOARD [DELETE /ezboard/boards/boardID/{boardId}/itemID/{itemId}/scrap] ended.");

		return result;
	}

	/**
	 * 모바일 G/W 게시판 [GET] 스크랩 리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/scrap/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object getBoardScrapList(@PathVariable String userId, HttpServletRequest request, Model model) {
		logger.debug("MOBILE G/W BOARD [GET /mobile/ezboard/scrap/{userId}] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String boardId = request.getParameter("boardID");
			String pSearchText = request.getParameter("pSearchText");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			MOptionVO mobileInfo = mOptionService.optionInfo(userId, info.getTenantId());
			String primary = commonUtil.getPrimaryData(mobileInfo.getLang(), info.getTenantId());

			MBoardInfoVO boardInfo = new MBoardInfoVO();
			String deptPathCode = info.getUserId() + "," + mBoardService.getDeptPathCode(info.getDeptId(), info.getTenantId());

			logger.debug("deptPathCode = " + deptPathCode);

			boardInfo = mBoardService.getBoardProperty(boardId, primary, info.getTenantId(), info.getUserId());
			boardInfo = mBoardService.getBoardInfo(boardInfo, info.getRollInfo(), deptPathCode, info);

			boardInfo.setType("scrapBoardItemList");
			boardInfo.setBoardName(egovMessageSource.getMessage("ezBoard.kmh12", new Locale(commonUtil.getTwoLetterLangFromLangNum(mobileInfo.getLang()))));
			
			Map<String, ArrayList<String>> scrapBoardListReadView_FG = mBoardService.getScrapBoardListReadView_FG(info);
			ArrayList<String> scrapBoardListRead_FG = scrapBoardListReadView_FG.get("scrapBoardListRead_FG");
			ArrayList<String> scrapBoardListView_FG =  scrapBoardListReadView_FG.get("scrapBoardListView_FG");
			
			List<MBoardNewListVO> list = mBoardService.getScrapBoardList(userId, info.getDeptId(), info.getCompanyId(), info.getTenantId(), info.getOffSet(),pSearchText, scrapBoardListView_FG);

			int listCount = mBoardService.getScrapBoardListCount(userId, info.getCompanyId(), info.getTenantId(), pSearchText, scrapBoardListView_FG);

			JSONObject data = new JSONObject();
			data.put("list", list);
			data.put("boardInfo", boardInfo);
			data.put("listCount", listCount);
			data.put("scrapBoardListRead_FG", scrapBoardListRead_FG);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		logger.debug("MOBILE G/W BOARD [GET /mobile/ezboard/scrap/{userId}] ended.");

		return result;
	}
	@Transactional
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/boards/{boardId}/contents/{contentId}/rate", method=RequestMethod.PUT, produces="application/json;charset=utf-8")
	public Map<String, Object> saveItemStarRating(@PathVariable String boardId, @PathVariable String contentId, HttpServletRequest request) throws Exception {
		logger.debug("saveItemStarRating started");
		
		String userId = request.getParameter("userId");
		String serverName = request.getHeader("x-user-host");
		LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
		
		int updateRating = Integer.parseInt(request.getParameter("updateRating"));
		String isReRated = request.getParameter("isReRated");

		Map<String, Object> result = new HashMap<>();

		try {
			Map<String, Object> resultData = ezBoardService.saveItemStarRating(contentId, isReRated, updateRating, userInfo);
			result.put("status", "success");
			result.put("totalRaters", resultData.get("totalRaters"));
			result.put("averageScore", resultData.get("averageScore"));
		} catch (Exception e) {
			result.put("status", "error");
			logger.error(e.getMessage(), e);
		}

		logger.debug("saveItemStarRating ended");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 게시판 [GET] 오늘의 식단 가져오기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/mealPlan/{startDate}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object getMealPlan(@PathVariable String startDate,HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W BOARD [GET /mobile/ezboard/mealPlan/{startDate}] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userID");

			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			MOptionVO mobileInfo = mOptionService.optionInfo(userId, info.getTenantId());
			String primary = commonUtil.getPrimaryData(mobileInfo.getLang(), info.getTenantId());

			logger.debug("serverName = " + serverName + " | primary = " + primary);
			
			Map<String, Object> map = new HashMap<>();
			map.put("startDate", startDate);
			map.put("companyID", request.getParameter("companyID"));
			map.put("tenantID", request.getParameter("tenantID"));

			List<MealDataVO> mealDataList = ezBoardService.getMealPlanList(map);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", mealDataList);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("MOBILE G/W BOARD [GET /mobile/ezboard/mealPlan/{startDate}] ended.");


		return result;
	}

	/**
	 * 모바일 G/W 게시판 [GET] 그룹게시판 리스트
	 */
	@RequestMapping(value="/mobile/ezboard/group-list/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object getGroupBoardList(@PathVariable String userId, HttpServletRequest request, Model model) {
		logger.debug("MOBILE G/W BOARD [GET /mobile/ezboard/group-list/{userId}] started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String boardId = request.getParameter("boardID");
			String lastDate = request.getParameter("lastDate");
			String pSearchText = request.getParameter("pSearchText");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			MOptionVO mobileInfo = mOptionService.optionInfo(userId, info.getTenantId());
			String primary = commonUtil.getPrimaryData(mobileInfo.getLang(), info.getTenantId());

			logger.debug("serverName = " + serverName + " | boardId = " + boardId + " | lastDate = " + lastDate + " | pSearchText = " + pSearchText + " | primary = " + primary);

			MBoardInfoVO boardInfo = new MBoardInfoVO();
			/* 2018-07-05 홍승비 - deptPath에 자신의 ID 빠져있는 부분 추가 */
			String deptPathCode = info.getUserId() + "," + mBoardService.getDeptPathCode(info.getDeptId(), info.getTenantId());

			logger.debug("deptPathCode = " + deptPathCode);

			boardInfo = mBoardService.getBoardProperty(boardId, primary, info.getTenantId(), info.getUserId());
			boardInfo = mBoardService.getBoardInfo(boardInfo, info.getRollInfo(), deptPathCode, info);

			List<MBoardTreeVO> treeList = mBoardService.getBoardTree(boardId, 0, 0, 0, "", info);
			List<String> childBoardIds = new ArrayList<>();
			MBoardInfoVO childBoardInfo = new MBoardInfoVO();

			for (MBoardTreeVO tree : treeList) {
				childBoardInfo = mBoardService.getBoardProperty(tree.getBoardId(), primary, info.getTenantId(), info.getUserId());
				childBoardInfo = mBoardService.getBoardInfo(childBoardInfo, info.getRollInfo(), deptPathCode, info);

				if (childBoardInfo.getListView_FG().equals("true")) {
					childBoardIds.add(tree.getBoardId());
				}
			}

			List<MBoardListVO> list = mBoardService.getGroupBoardItemList(userId, commonUtil.getDateStringInUTC(lastDate, info.getOffSet(), true), info.getDeptId(), info.getCompanyId(), info.getTenantId(), info.getOffSet(), boardId, childBoardIds);

			int listCount = mBoardService.getGroupBoardItemListCount(userId, info.getCompanyId(), info.getTenantId(), boardId, childBoardIds);
			logger.debug("listCount ="+listCount);

			JSONObject data = new JSONObject();
			data.put("list", list);
			data.put("boardInfo", boardInfo);
			data.put("listCount", listCount);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		logger.debug("MOBILE G/W BOARD [GET /mobile/ezboard/group-list/{userId}] ended.");

		return result;
	}
}
