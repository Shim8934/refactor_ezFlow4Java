package egovframework.ezMobile.ezBoard.web;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.Locale;
import java.util.Properties;
import java.util.UUID;
import java.util.Base64.Decoder;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezSchedule.vo.AttachListVO;
import egovframework.ezMobile.ezBoard.service.MBoardService;
import egovframework.ezMobile.ezBoard.vo.MBoardAttachVO;
import egovframework.ezMobile.ezBoard.vo.MBoardFavoriteVO;
import egovframework.ezMobile.ezBoard.vo.MBoardInfoVO;
import egovframework.ezMobile.ezBoard.vo.MBoardItemVO;
import egovframework.ezMobile.ezBoard.vo.MBoardNewListVO;
import egovframework.ezMobile.ezBoard.vo.MBoardTreeVO;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@RestController
public class MBoardGWController {
	private static final Logger LOGGER = LoggerFactory.getLogger(MBoardController.class);
	
	public static final int BUFF_SIZE = 2048;
	
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
	
	@Resource(name="MOptionService")
	private MOptionService mOptionService;
	
	/**
	 * 모바일 G/W 게시판 [GET] 새게시물 리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/new-list/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object getBoardMainList(@PathVariable String userId, HttpServletRequest request, Model model) {		
		LOGGER.debug("MOBILE G/W BOARD [GET /mobile/ezboard/mainList/{userId}] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String boardId = request.getParameter("boardID");
			String lastDate = request.getParameter("lastDate");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			
			String primary = commonUtil.getPrimaryData(info.getLang(), info.getTenantId());
			
			MBoardInfoVO boardInfo = new MBoardInfoVO();
			String deptPathCode = mBoardService.getDeptPathCode(info.getDeptId(), info.getTenantId());
			
			LOGGER.debug("deptPathCode = "+deptPathCode);
			
			boardInfo = mBoardService.getBoardProperty(boardId, primary, info.getTenantId());
			boardInfo = mBoardService.getBoardInfo(boardInfo, info.getRollInfo(), deptPathCode, info);
			
			List<MBoardNewListVO> list = mBoardService.getNewBoardList(userId, commonUtil.getDateStringInUTC(lastDate, info.getOffSet(), true),info.getTenantId());
			
			int listCount = mBoardService.getNewBoardListCount(userId, "", info.getTenantId());
			LOGGER.debug("listCount ="+listCount);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", list);
			result.put("data2", boardInfo);
			result.put("listCount", listCount);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			result.put("data2", "");
			result.put("listSize", "");
		}
		LOGGER.debug("MOBILE G/W BOARD [GET /mobile/ezboard/mainList/{userId}] ended.");
		return result;
	}
	
	
	/**
	 * 모바일 G/W 게시판 [GET] 게시판 리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/boards/{boardId}/list", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object getBoardItemList(@PathVariable String boardId, HttpServletRequest request, Model model) {		
		LOGGER.debug("MOBILE G/W BOARD [GET /ezboard/{type}/boards/{boardId}/list] started.");
		
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
			
			String primary = commonUtil.getPrimaryData(info.getLang(), info.getTenantId());
			
			MBoardInfoVO boardInfo = new MBoardInfoVO();
			String deptPathCode = mBoardService.getDeptPathCode(info.getDeptId(), info.getTenantId());
			
			LOGGER.debug("deptPathCode = "+deptPathCode);
			
			boardInfo = mBoardService.getBoardProperty(boardId, primary, info.getTenantId());
			boardInfo = mBoardService.getBoardInfo(boardInfo, info.getRollInfo(), deptPathCode, info);
			
			List<MBoardItemVO> list = mBoardService.getBoardItemList(boardInfo, info, commonUtil.getDateStringInUTC(lastDate, info.getOffSet(), true),info.getUserId(),add,pSearchText, parentWriteDate, upperitemidtree);
			int listCount = mBoardService.getBoardItemListCount(boardId, userID, boardInfo.getGuBun(),info.getTenantId(),pSearchText);
			
			for (int i=0; i<list.size(); i++) {
				int listSize = list.size();
				parentWriteDate = list.get(listSize-1).getParentWriteDate();
				upperitemidtree = list.get(listSize-1).getUpperItemIDTree();
			}
			
			
			//즐겨찾기 여부
			String favoriteYN = mBoardService.checkFavorite(userID, boardId, info.getTenantId());
			LOGGER.debug("listCount : "+listCount);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", list);
			result.put("data2", boardInfo);
			result.put("listCount", listCount);
			result.put("favoriteYN", favoriteYN);
			result.put("parentWriteDate", parentWriteDate);
			result.put("upperitemidtree", upperitemidtree);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		LOGGER.debug("MOBILE G/W BOARD [GET /ezboard/{type}/boards/{boardId}/list] ended.");
		return result;
	}
	
	/**
	 * 모바일 G/W 게시판 [GET] 즐겨찾기에 등록된 게시판 폴더 리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/favorite-list/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object getFavoriteList(@PathVariable String userId,HttpServletRequest request) throws Exception {		
		LOGGER.debug("MOBILE G/W BOARD [GET /ezboard/favorite-list/users/{userId}] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			
			List<MBoardFavoriteVO> resultList = mBoardService.getFavoriteList(userId, info.getTenantId());

			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", resultList);
			
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}		
		LOGGER.debug("MOBILE G/W BOARD [GET /ezboard/favorite-list/users/{userId}] ended.");
		return result;
	}
	
	/**
	 * 모바일 G/W 게시판 [GET] 게시물 상세정보
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/{type}/boards/{boardId}/contents/{contentId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object boardDetail(@PathVariable String type,@PathVariable String boardId, @PathVariable String contentId,HttpServletRequest request,Locale locale) throws Exception {		
		LOGGER.debug("MOBILE G/W BOARD [GET /ezboard/{type}/boards/{boardId}/contents/{contentId}] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userID = request.getParameter("userID");
			String serverName = request.getHeader("x-user-host");
			
			MCommonVO info = mOptionService.commonInfo(serverName, userID);
			
			MBoardItemVO boardItem = mBoardService.getBrdItemInfo(contentId, commonUtil.getMultiData(info.getLang(), info.getTenantId()), info.getTenantId());
			boardItem.setWriteDate(commonUtil.getDateStringInUTC(boardItem.getWriteDate(), info.getOffSet(), false));
			
			//boardInfo
			String primary = commonUtil.getPrimaryData(info.getLang(), info.getTenantId());
			
			MBoardInfoVO boardInfo = new MBoardInfoVO();
			String deptPathCode = mBoardService.getDeptPathCode(info.getDeptId(), info.getTenantId());
			
			LOGGER.debug("deptPathCode = "+deptPathCode);
			
			boardInfo = mBoardService.getBoardProperty(boardId, primary, info.getTenantId());
			boardInfo = mBoardService.getBoardInfo(boardInfo, info.getRollInfo(), deptPathCode, info);
			//상세보기일때 type boardItem으로 지정
			boardInfo.setType("boardItem");
			
			//mht 파일 가져오기
			String realPath = commonUtil.getRealPath(request);
			String domain = request.getServerName() + ":" + request.getServerPort();
			String mhtContent = mBoardService.getMhtContent(realPath, domain, info, boardItem.getContentLocation(), locale);
			
			//새게시물 눌렀을때, read테이블에 들어가게함.
			mBoardService.setAsRead(info, boardId, contentId);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", boardItem);
			result.put("content", mhtContent);
			result.put("boardInfo", boardInfo);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			result.put("content", "");
			result.put("boardInfo", "");
		}		
		
		LOGGER.debug("MOBILE G/W BOARD [GET /ezboard/{type}/boards/{boardId}/contents/{contentId}] ended.");
		return result;
	}
	
	/**
	 * 모바일 G/W 게시판 [GET] 포토게시물 상세정보
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/photo/boards/{boardId}/contents/{contentId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object photoBoardDetail(@PathVariable String boardId, @PathVariable String contentId,HttpServletRequest request,Locale locale) throws Exception {		
		LOGGER.debug("MOBILE G/W BOARD [GET /ezboard/photo/boards/{boardId}/contents/{contentId}] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userID = request.getParameter("userID");
			String serverName = request.getHeader("x-user-host");
			
			MCommonVO info = mOptionService.commonInfo(serverName, userID);
			
			MBoardItemVO boardItem = mBoardService.getBrdItemInfo(contentId, commonUtil.getMultiData(info.getLang(), info.getTenantId()), info.getTenantId());
			boardItem.setWriteDate(commonUtil.getDateStringInUTC(boardItem.getWriteDate(), info.getOffSet(), false));
			
			//boardInfo
			String primary = commonUtil.getPrimaryData(info.getLang(), info.getTenantId());
			
			MBoardInfoVO boardInfo = new MBoardInfoVO();
			String deptPathCode = mBoardService.getDeptPathCode(info.getDeptId(), info.getTenantId());
			
			LOGGER.debug("deptPathCode = "+deptPathCode);
			
			boardInfo = mBoardService.getBoardProperty(boardId, primary, info.getTenantId());
			boardInfo = mBoardService.getBoardInfo(boardInfo, info.getRollInfo(), deptPathCode, info);
			
			//썸네일게시판일때 게시물
			boardInfo.setType("photoBoardItem");
			List<MBoardAttachVO>	photoList = mBoardService.photoViewDB(contentId, boardId, info.getTenantId());
			
			//String gwServerUrl = config.getProperty("config.mobileGwServerURL");
			
			for (MBoardAttachVO photo : photoList) {
				//임시로 localhost:8080
				photo.setFilePath("http://localhost:8080"+photo.getFilePath());
			}
				
			LOGGER.debug("photoList:"+photoList);
			
			mBoardService.setAsRead(info, boardId, contentId);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", boardItem);
			result.put("boardInfo", boardInfo);
			result.put("photoList", photoList);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			result.put("boardInfo", "");
			result.put("photoList", "");
		}		
		
		LOGGER.debug("MOBILE G/W BOARD [GET /ezboard/photo/boards/{boardId}/contents/{contentId}] ended.");
		return result;
	}
	
	/**
	 * 모바일 G/W 게시판 [POST] 게시물 등록
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/boards/contents", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject insertBoard(@RequestBody JSONObject jsonParam, HttpServletRequest request, Locale locale) throws Exception {		
		LOGGER.debug("MOBILE G/W BOARD [POST /ezboard/boards/{boardId}/contents] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName,  jsonParam.get("userID").toString());
			String realPath = commonUtil.getRealPath(request);
			String content = jsonParam.get("mainContent").toString();
			content = URLDecoder.decode(content, "utf-8");
			
			String scheme = "http://";
	    	if (request.getHeader("HTTPS") != null && request.getHeader("HTTPS").toString().toLowerCase().equals("on")) {
	    		scheme = "https://";
	    	}
			
			content = content.replace("replace_" + scheme, scheme);
			
			//html -> mht변환
			String mhtData = ezCommonService.startHtml2Mht(content, realPath, locale);
			
			mBoardService.insertBrdItem(jsonParam, info, realPath,mhtData);

	        result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}	
		
		LOGGER.debug("MOBILE G/W BOARD [POST /ezboard/boards/{boardId}/contents] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 게시판 [PUT] 게시물 수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/boards/{boardId}/contents/{contentId}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject updateBoard(@RequestBody JSONObject jsonParam, HttpServletRequest request, Locale locale) throws Exception {		
		LOGGER.debug("MOBILE G/W BOARD [PUT /ezboard/boards/{boardId}/contents] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName,  jsonParam.get("userID").toString());
			String realPath = commonUtil.getRealPath(request);
			String content = jsonParam.get("mainContent").toString();
			content = URLDecoder.decode(content, "utf-8");
			
			String scheme = "http://";
	    	if (request.getHeader("HTTPS") != null && request.getHeader("HTTPS").toString().toLowerCase().equals("on")) {
	    		scheme = "https://";
	    	}
	    	
	    	content = content.replace("replace_" + scheme, scheme);
			
			//html -> mht변환
			String mhtData = ezCommonService.startHtml2Mht(content, realPath, locale);
			
			mBoardService.updateItem(jsonParam, info, realPath,mhtData);
			
	        result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}	
		
		LOGGER.debug("MOBILE G/W BOARD [PUT /ezboard/boards/{boardId}/contents] ended.");
		return result;
	}
	
	/**
	 * 모바일 G/W 게시판 [DELETE] 게시물 삭제
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/boards/{boardId}/contents/{contentId}", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject deleteBoard(@PathVariable String boardId, @PathVariable String contentId, HttpServletRequest request) throws Exception {		
		LOGGER.debug("MOBILE G/W BOARD [DELETE /ezboard/boards/{boardId}/contents] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName,  userId);
			
			mBoardService.deleteItem(contentId, boardId, info.getTenantId());
			
	        result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}	
		
		LOGGER.debug("MOBILE G/W BOARD [DELETE /ezboard/boards/{boardId}/contents] ended.");
		return result;
	}
	
	/**
	 * 모바일 G/W 게시판 [GET] 좌측메뉴 리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/folder-list", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object getLeftMenu(HttpServletRequest request) throws Exception {		
		LOGGER.debug("MOBILE G/W BOARD [GET /ezboard/folder-list] started.");
		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			String rootBoardID = request.getParameter("rootBoardId");
			int mode = 0;
			String selectBy = request.getParameter("selectBy");
			String excludeBoardID = request.getParameter("excludeBoardId");
			String subFlag = request.getParameter("subFlag");
			
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			
			List<MBoardTreeVO> list = mBoardService.getBoardTree(rootBoardID, mode, Integer.parseInt(subFlag), Integer.parseInt(selectBy), excludeBoardID, info);
			
			int listCount = mBoardService.getNewBoardListCount(userId, "", info.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", list);
			result.put("data2", listCount);
			
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			result.put("data2", "");
		}				
		LOGGER.debug("MOBILE G/W BOARD [GET /ezboard/folder-list] ended.");
		return result;
	}
	
	/**
	 * 모바일 G/W 게시판 [POST] 즐겨찾기 설정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/boards/{boardId}/favorite", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject insertFavorite(@PathVariable String boardId,HttpServletRequest request) throws Exception {		
		LOGGER.debug("MOBILE G/W BOARD [POST /ezboard/boards/{boardId}/favorite] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName,  userId);
			
			mBoardService.insertFavorite(info.getUserId(), boardId, info.getTenantId());
			
	        result.put("status", "ok");
			result.put("code", 0);			
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);			
		}	
		
		LOGGER.debug("MOBILE G/W BOARD [POST /ezboard/boards/{boardId}/favorite] ended.");
		return result;
	}
	
	/**
	 * 모바일 G/W 게시판 [DELETE] 즐겨찾기 해제
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/boards/{boardId}/favorite", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject deleteFavorite(@PathVariable String boardId,HttpServletRequest request) throws Exception {		
		LOGGER.debug("MOBILE G/W BOARD [DELETE /ezboard/boards/{boardId}/favorite] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName,  userId);
			
			mBoardService.deleteFavorite(info.getUserId(), boardId, info.getTenantId());
			
	        result.put("status", "ok");
			result.put("code", 0);			
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);			
		}	
		
		LOGGER.debug("MOBILE G/W BOARD [DELETE /ezboard/boards/{boardId}/favorite] ended.");
		return result;
	}
	
	/**
	 * 모바일 G/W 게시판 [GET] 게시물 첨부파일 리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezboard/boards/{boardId}/contents/{contentId}/attach-list", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getAttachList(@PathVariable String contentId, HttpServletRequest request) throws Exception {		
		LOGGER.debug("MOBILE G/W BOARD [GET /ezboard/boards/{boardId}/contents/{contentId}/attach-list] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName,  userId);
			
			List<MBoardAttachVO> list = mBoardService.getAttachList(contentId, info.getTenantId());
			
			//파일사이즈 단위 수정
			String fileSize = "";
			for (int i=0; i<list.size(); i++) {
				fileSize = list.get(i).getFileSize();
				
				if (Integer.parseInt(fileSize) / 1024 / 1024 > 1) {
					fileSize = ((Integer.parseInt(fileSize) / 1024 / 1024 * 10) / 10) + "MB";
				} else if ((Integer.parseInt(fileSize) / 1024) > 1) {
					fileSize = (Integer.parseInt(fileSize)/1024) + "KB"; 
				} else {
					fileSize = fileSize + "B";
				}
				
				list.get(i).setFileSize(fileSize);
			}

	        result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", list);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}	
		
		LOGGER.debug("MOBILE G/W BOARD [GET /ezboard/boards/{boardId}/contents/{contentId}/attach-list] ended.");
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezboard/fileupload", method=RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject mFileUpload(HttpServletRequest request, @RequestBody JSONObject jsonObject) throws Exception {
		LOGGER.debug("MOBILE G/W BOARD [GET /mobile/ezboard/fileupload] started.");
		
		String filePath = request.getParameter("filePath");
		String fileName = request.getParameter("fileName");
		String boardID = request.getParameter("boardID");
		
		LOGGER.debug("filePath = " + filePath);
		LOGGER.debug("fileName:"+fileName);
		
		String serverName = request.getHeader("x-user-host");
		
		JSONParser jp = new JSONParser();
		jsonObject = (JSONObject) jp.parse(jsonObject.toJSONString());
		
		JSONObject result = new JSONObject();
		try {
			JSONArray fileArray = new JSONArray();
			
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
			
			MCommonVO info = mOptionService.commonInfo(serverName, userID);
			
			String[] pFileName = new String[cnt];
			String realPath = commonUtil.getRealPath(request);
			String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", info.getTenantId());
			String[] sGUID = new String[cnt];
			String[] pUploadSN = new String[cnt];
			Long[] fileSize = new Long[cnt];
			String[] resultUpload = new String[cnt];
			String[] fileLocation = new String[cnt];
			
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
                    if (useExtension.toLowerCase().indexOf(pFileName[i].substring(pFileName[i].lastIndexOf(".") + 1).toString().toLowerCase()) == -1 && !useExtension.equals("*")) {
                        resultUpload[i] = "denied";
                    } else {
                        String pAttachPath = realPath + commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", info.getTenantId()) + commonUtil.separator;
                        File fTemp = new File(pAttachPath, pUploadSN[i] + "_" + pFileName[i]);
                        
                        if (!file.exists()) {
                        	fTemp.mkdirs();
                        }
                        
                        mobileBoardWriteUploadedFile((String)((JSONObject)fileArray.get(i)).get("bytes"), pUploadSN[i] + "_" + pFileName[i], pAttachPath);
                        
                        fileLocation[i] = commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", info.getTenantId()) + commonUtil.separator + pUploadSN[i] + "_" + pFileName[i];
                        resultUpload[i] = "true";
                    }
	            }
	        }
			
	        StringBuffer strXML = new StringBuffer();

	        strXML.append("<ROOT><NODES>");
	        
	        String attachment = "";
	        for (int i = 0; i < cnt; i++) {
	            strXML.append("<NODE><PUPLOADSN><![CDATA[" + pUploadSN[i] + "_" + pFileName[i] + "]]></PUPLOADSN>");
	            strXML.append("<RESULTUPLOADA><![CDATA[" + resultUpload[i] + "]]></RESULTUPLOADA>");
	            strXML.append("<PFILENAME><![CDATA[" + pFileName[i] + "]]></PFILENAME>");
	            strXML.append("<FILESIZE>" + (fileSize[i]/(1024*1024))+"MB" + "</FILESIZE>");
	            strXML.append("<FILELOCATION><![CDATA[" + fileLocation[i] + "]]></FILELOCATION>");
	            strXML.append("</NODE>");
	            
	            
	            attachment += "tempUploadFile"+commonUtil.separator+pUploadSN[i]+"_"+pFileName[i]+"|";
	            
	        }
	        
	        strXML.append("</NODES></ROOT>");
	        
	        result.put("data", attachment);
			result.put("status", "ok");
			result.put("code", 0);
			
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			
			return result;
		} 
		
		LOGGER.debug("MOBILE G/W BOARD [GET /mobile/ezboard/fileupload] ended.");
		
		return result;
	}
	
/*	*//**
	 * 모바일 G/W 게시판 [GET] 게시판 리스트 카운트
	 *//*
	@RequestMapping(value="/ezboard/{type}/boards/{boardId}/list-count", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public void getBoardItemListCount() throws Exception {		
		LOGGER.debug("MOBILE G/W BOARD [GET /ezboard/{type}/boards/{boardId}/list-count] started.");
				
		LOGGER.debug("MOBILE G/W BOARD [GET /ezboard/{type}/boards/{boardId}/list-count] ended.");
	}
	
	*//**
	 * 모바일 G/W 게시판 [GET] 섬네일게시판 리스트
	 *//*
	@RequestMapping(value="/ezboard/thumbnail/boards/{boardId}/list", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public void getThumbBoardList() throws Exception {		
		LOGGER.debug("MOBILE G/W BOARD [GET /ezboard/thumbnail/boards/{boardId}/list] started.");
				
		LOGGER.debug("MOBILE G/W BOARD [GET /ezboard/thumbnail/boards/{boardId}/list] ended.");
	}
	
	*//**
	 * 모바일 G/W 게시판 [GET] 섬네일게시판 리스트 카운트
	 *//*
	@RequestMapping(value="/ezboard/thumbnail/boards/{boardId}/list-count", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public void getThumbBoardListCount() throws Exception {		
		LOGGER.debug("MOBILE G/W BOARD [GET /ezboard/thumbnail/boards/{boardId}/list-count] started.");
				
		LOGGER.debug("MOBILE G/W BOARD [GET /ezboard/thumbnail/boards/{boardId}/list-count] ended.");
	}*/
	
	/**
     * 첨부파일을 서버에 저장한다.
     *
     * @param file
     * @param newName
     * @param stordFilePath
     * @throws Exception
     */
    public void mobileBoardWriteUploadedFile(String bytearray, String newName, String stordFilePath) throws Exception {
    	LOGGER.debug("mobileBoardWriteUploadedFile");
    	
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
		    LOGGER.debug("###" + stordFilePathReal + File.separator + newName + "###");
		    int bytesRead = 0;
		    byte[] buffer = new byte[BUFF_SIZE];
		    Decoder decoder = Base64.getDecoder();

		    bos.write(decoder.decode(bytearray));

		} catch (FileNotFoundException fnfe) {
			LOGGER.debug("fnfe: {}", fnfe);
		} catch (IOException ioe) {
			LOGGER.debug("ioe: {}", ioe);
		} catch (Exception e) {
			LOGGER.debug("e: {}", e);
		} finally {
		    if (bos != null) {
				try {
				    bos.close();
				} catch (Exception ignore) {
					LOGGER.debug("IGNORED: {}", ignore.getMessage());
				}
		    }
		    if (stream != null) {
				try {
				    stream.close();
				} catch (Exception ignore) {
					LOGGER.debug("IGNORED: {}", ignore.getMessage());
				}
		    }
		}
    }
}
