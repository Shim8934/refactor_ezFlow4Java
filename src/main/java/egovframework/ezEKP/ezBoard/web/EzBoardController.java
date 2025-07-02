package egovframework.ezEKP.ezBoard.web;

import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.Field;
import java.lang.reflect.Type;
import java.net.URI;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.security.MessageDigest;
import java.net.URL;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.PrivateKey;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZoneOffset;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.Properties;
import java.util.Set;
import java.util.StringJoiner;
import java.util.UUID;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.mail.internet.InternetAddress;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;
import egovframework.ezEKP.ezAI.util.AICommonUtil;
import egovframework.ezEKP.ezBoard.vo.BoardKeywordVO;
import egovframework.ezEKP.ezOrgan.vo.OrganAuth;
import egovframework.ezEKP.ezOrgan.vo.OrganAuth.AdminAuth;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.RegionUtil;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.HandlerMapping;
import org.springframework.web.util.UriComponentsBuilder;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGKlibService;
import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezBoard.vo.BoardAccessVO;
import egovframework.ezEKP.ezBoard.vo.BoardAttachVO;
import egovframework.ezEKP.ezBoard.vo.BoardAttributeVO;
import egovframework.ezEKP.ezBoard.vo.BoardConfigVO;
import egovframework.ezEKP.ezBoard.vo.BoardItemVO;
import egovframework.ezEKP.ezBoard.vo.BoardLineReplyVO;
import egovframework.ezEKP.ezBoard.vo.BoardListHeaderVO;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezBoard.vo.BoardMyFavoriteVO;
import egovframework.ezEKP.ezBoard.vo.BoardPollConfigVO;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezBoard.vo.BoardThumbnailVO;
import egovframework.ezEKP.ezBoard.vo.BoardVO;
import egovframework.ezEKP.ezBoard.vo.MealDataVO;
import egovframework.ezEKP.ezCabinet.service.EzCabinetAdminService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezMemo.service.EzMemoService;
import egovframework.ezEKP.ezMemo.vo.MemoConfigVO;
import egovframework.ezEKP.ezNotification.service.EzNotificationService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPersonal.type.NotiPlatform;
import egovframework.ezEKP.ezPersonal.type.NotiType;
import egovframework.ezEKP.ezResource.vo.ResGetAdminFlagVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.fcc.service.KlibUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;
import org.springframework.transaction.annotation.Transactional;

/** 
 * @Description [Controller] 사용자 - 게시판 
 * @author 오픈솔루션팀 황윤진
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.04.14    황윤진    신규작성
 *
 * @see
 */
@Controller("EzBoardController")
public class EzBoardController extends EgovFileMngUtil{
	
	@Autowired
	private CommonUtil commonUtil;
	
	 @Autowired
    private AICommonUtil aICommonUtil;
	
	@Autowired
	private Properties globals;
	
	@Resource(name = "loginService")
	private LoginService loginService;
	
	@Resource(name = "crypto") 
    private EgovFileScrty egovFileScrty;
 
	@Resource(name = "EzBoardService")
	private EzBoardService ezBoardService;
	
	@Resource(name = "EzBoardAdminService")
	private EzBoardAdminService ezBoardAdminService;

	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	@Resource(name = "EzOrganAdminService")
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name = "EzEmailService")
	private EzEmailService ezEmailService;
	
	@Resource(name = "egovMessageSource")
    private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzCabinetAdminService")
	private EzCabinetAdminService cabinetAdminService;

	@Resource(name = "EzMemoService")
	private EzMemoService ezMemoService;
	
	@Resource(name = "EzPersonalService")
	private EzPersonalService ezPersonalService;

	@Resource(name = "EzNotificationService")
	private EzNotificationService ezNotificationService;

	@Autowired
	private KlibUtil klibUtil;

	private static final Logger logger = LoggerFactory.getLogger(EzBoardController.class);
	
	/**
	 * 게시판 메인화면 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardMain.do", method = RequestMethod.GET)
	public String boardMain(HttpServletRequest req, Model model) {
		logger.debug("boardMain started");

		String func = "";
		String subFunc = "";
		String qstId = "";

		String leftFrameWidth = "220";
		int width = 0;
		
		if (req.getParameter("func") != null && !req.getParameter("func").equals("")) {
			func = commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(req.getParameter("func")));	
		}
		
		if (req.getParameter("subFunc") != null && !req.getParameter("subFunc").equals("")) {
			subFunc = commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(req.getParameter("subFunc")));	
		}
		if (req.getParameter("qstId") != null && !req.getParameter("qstId").equals("")) {
			qstId = commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(req.getParameter("qstId")));	
		}

        if (req.getParameter("__wwidth") != null) {
            String widthParam = req.getParameter("__wwidth");

            try {
                width = Integer.parseInt(widthParam);

                leftFrameWidth = width < 1180 ? "0" : "220";
            } catch (NumberFormatException e) {
                width = 0;
            }
        }
        
		model.addAttribute("func", func);
		model.addAttribute("subFunc", subFunc);	
		model.addAttribute("qstId", qstId);
		model.addAttribute("leftFrameWidth", leftFrameWidth);
		
		logger.debug("boardMain ended");

		return "ezBoard/boardMain";
	}
	
	/**
	 * 게시판 메인화면 Redirect 호출 Method
	 */
	@RequestMapping(value="/ezBoard/boardMainRedirect.do", method = RequestMethod.GET)
	public String boardMainRedirect(HttpServletRequest req, Model model) {
		logger.debug("boardMainRedirect started");

		String boardID = "";
		String leftFrameWidth = "220";
		int width = 0;
		
		if (req.getParameter("boardID") != null && !req.getParameter("boardID").equals("")) {
			boardID = req.getParameter("boardID");	
		}
		
		boardID = boardID.replace("{", "%7B").replace("}", "%7D");

		if (req.getParameter("__wwidth") != null) {
			String widthParam = req.getParameter("__wwidth");

			try {
				width = Integer.parseInt(widthParam);

				leftFrameWidth = width < 1180 ? "0" : "220";
			} catch (NumberFormatException e) {
				width = 0;
			}
		}
		
		model.addAttribute("boardID", boardID);
		model.addAttribute("leftFrameWidth", leftFrameWidth);
		
		logger.debug("boardMainRedirect ended");
		return "ezBoard/boardMainRedirect";
	}
	
	/**
	 * 게시판 왼쪽화면 호출 Method
	 */
	@RequestMapping(value="/ezBoard/boardLeft.do", method = RequestMethod.GET)
	public String boardLeft(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, ModelMap modelMap, LoginVO userInfo, HttpServletResponse response) throws Exception {
		logger.debug("boardLeft started");

		userInfo = commonUtil.userInfo(loginCookie);

		String redirectBoardID = "";
        String redirectBoardGroupID = "";
        String qstId = "";
        String func = "";
        String subFunc = "";
        String applyFlag = "";
        String isAdminLeft = "";
        boolean isCompanyAdmin = commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "c");
        String indexID;
		String userScrapCont = "";

        String strLang = userInfo.getLang();
		String pUserID = userInfo.getId();
		String pDeptID = userInfo.getDeptID();
		String pCompanyID = userInfo.getCompanyID();
		String pRollInfo = userInfo.getRollInfo();
		int tenantID = userInfo.getTenantId();
		
        String pollFlag = "";
        if (ezCommonService.getTenantConfig("useBallotSystem", tenantID).equalsIgnoreCase("YES")) {
        	pollFlag = "YES";
        }
        else {
        	pollFlag = "NO";
        }
        
        // 2018-07-26 황윤호 추가
        String ladderFlag = "";
        if (ezCommonService.getTenantConfig("useLadder", tenantID).equalsIgnoreCase("YES")) {
        	ladderFlag = "YES";
        }
        else {
        	ladderFlag = "NO";
        }
        
        // 2018-08-03 황윤호 추가
        String memoFlag = "";
        if (ezCommonService.getTenantConfig("useMemo", tenantID).equalsIgnoreCase("YES")) {
        	memoFlag = "YES";
        } else {
        	memoFlag = "NO";
        }
        
        /* 2019-07-09 홍승비 - 게시판 좌측메뉴 게시물 개수 표출 사용여부 플래그 추가 */
        String useLeftCnt = "";
        if (ezCommonService.getTenantConfig("USE_BOARD_LEFTMENU_COUNT", tenantID) != null) {
        	useLeftCnt = ezCommonService.getTenantConfig("USE_BOARD_LEFTMENU_COUNT", tenantID);
        }
		
		if (request.getParameter("boardID") != null && !request.getParameter("boardID").equals("")) {
			redirectBoardID  = request.getParameter("boardID");
			StringBuilder redirectBoardBuilder = new StringBuilder();
			List<BoardVO> leftBoardList = ezBoardService.getLeft_BoardSTD(redirectBoardID, tenantID);
			
			for (BoardVO i :  leftBoardList) {
				redirectBoardBuilder.append(commonUtil.makeListField(i.getBoardGroupId()) + ",");
			}
			
			redirectBoardGroupID = redirectBoardBuilder.toString();
			
			if (redirectBoardGroupID.length() != 0) {
				redirectBoardGroupID = redirectBoardGroupID.substring(0, redirectBoardGroupID.length() - 1);
			}
		}
		
		if (request.getParameter("func") != null) {
			func = request.getParameter("func");
		}
		
		if (request.getParameter("qstId") != null) {
			qstId = request.getParameter("qstId");
		}
		
		if (request.getParameter("subFunc") != null) {
			subFunc = request.getParameter("subFunc");
		}
		/* 2018-10-16 홍승비 - 관리자단에서 접근했는지 판단하는 플래그 추가 */
		if (request.getParameter("isAdminLeft") != null) {
			isAdminLeft = request.getParameter("isAdminLeft");
		}
		
		int pSelectBy = 0;
		String pRootBoardID = "top";
		String pSubFlag = "0";
		String pExcludeBoardID = " ";
		
		/* 2018-06-27 홍승비 - 게시물 승인권한 확인 companyID 조건 추가 */
		List<BoardVO> applyUserList = ezBoardAdminService.checkApplyUser(pCompanyID, tenantID);
		// 현재 사용자가 승인자인지 확인하고 companyID 조건을 추가해 승인 플래그를 설정한다.(동일 승인자에 대해 A사의 승인권한와 B사의 승인권한이 구분된다.)
		for (BoardVO vo: applyUserList) {
			if (vo.getApprUserId().toLowerCase().indexOf(pUserID.toLowerCase()) > -1) {
				applyFlag = "OK";
			}
		}
		
		int pMode = commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "c;n;k") ? 0 : 1;
		
		/* 2019-06-05 홍승비 - 결과가 항상 NO인 게시판그룹 관리자권한 체크 동작 제거 (boardGroupID 또는 boardID가 'top'인 게시판은 존재하지 않음) */
		// Library 연결 부분 Method화
		String resultXML = ezBoardService.getBoardTree(pRootBoardID, pUserID, pDeptID, pCompanyID, pMode, Integer.parseInt(pSubFlag), pSelectBy, pExcludeBoardID,
				commonUtil.getLangData(strLang), isAdminLeft, isCompanyAdmin, "NO", pRollInfo, userInfo.getTenantId());
		
		Document doc = commonUtil.convertStringToDocument(resultXML);
		int resultCount = doc.getElementsByTagName("NODE").getLength();
		
		String questionAdmin = commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "c;l;k") ? "true" : "false";
		
		// 2018-05-08 강민수92 게시물 승인 카운트 출력
		if (applyFlag.equals("OK")) {
			int applyCount = 0;
			applyCount = ezBoardService.getApprBoardTotalItemCount(userInfo);
			modelMap.addAttribute("applyCount", applyCount);
		}
		
		// 2023-05-22 기민혁 userscrapCont 정보 체크
		userScrapCont = ezBoardService.getUserScrapContTree(userInfo.getId(), "ROOT", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getLocale());

        modelMap.addAttribute("userInfo", userInfo);
        modelMap.addAttribute("resultCount", resultCount);
        modelMap.addAttribute("resultXML", resultXML);
        modelMap.addAttribute("func", commonUtil.stripScriptTags(func));
        modelMap.addAttribute("subFunc", commonUtil.stripScriptTags(subFunc));
        modelMap.addAttribute("qstId", commonUtil.stripScriptTags(qstId));        
        modelMap.addAttribute("redirectBoardID",redirectBoardID);
        modelMap.addAttribute("redirectBoardGroupID", redirectBoardGroupID.toString());
        modelMap.addAttribute("applyFlag",applyFlag);
        modelMap.addAttribute("questionAdmin", questionAdmin);
        modelMap.addAttribute("MyBoardTopFlag", ezCommonService.getTenantConfig("MyBoardTopFlag", tenantID));
        modelMap.addAttribute("pollFlag", pollFlag);
        modelMap.addAttribute("ladderFlag", ladderFlag);
        modelMap.addAttribute("memoFlag", memoFlag);
        modelMap.addAttribute("useLeftCnt", useLeftCnt);
        modelMap.addAttribute("MyBoardScrapFlag", ezCommonService.getTenantConfig("MyBoardScrapFlag", tenantID));
        modelMap.addAttribute("userScrapCont", userScrapCont);
		modelMap.addAttribute("useMealPlan", ezCommonService.getTenantConfig("useMealPlan", userInfo.getTenantId()));
        
		logger.debug("boardLeft ended");

		return "ezBoard/boardLeft";
	}
	
	/**
	 * 게시판 즐겨찾기화면 호출 Method
	 */
	@RequestMapping(value="/ezBoard/boardItemList_favorite.do", method = RequestMethod.GET)
	public String boardItemList_favorite(Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("boardItemList_favorite started");

		userInfo = commonUtil.userInfo(loginCookie);
		String useRunTime = ezCommonService.getTenantConfig("USERUNTIME", userInfo.getTenantId());
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("useRunTime", useRunTime);

		logger.debug("boardItemList_favorite ended");
    	return "ezBoard/boardItemList_favorite";
	}
	
	/**
	 * 게시판 즐겨찾기 데이터 표출 Method
	 */
	@RequestMapping(value="/ezBoard/get_favoriteList.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String get_favoriteList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception {
		logger.debug("get_favoriteList started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String mode = request.getParameter("mode") != null ? request.getParameter("mode") : "";
		String userID = userInfo.getId();
		String result = "";
		
		// 2023-12-01 조소정 - 사용자 설정 언어에 따라 즐겨찾기 게시판 이름 표출되도록 수정
		String lang = commonUtil.getLangData(userInfo.getLang());
		
		/* 2018-06-27 홍승비 - 즐겨찾기 탭 표출 시 companyID 조건 추가 */
		List<BoardMyFavoriteVO> resultList = ezBoardService.get_favoriteList(userID, mode, userInfo.getCompanyID(), userInfo.getTenantId(), lang);
		String parentName = parentBoardName(resultList, userInfo);
		StringBuffer sb = new StringBuffer();
		
		sb.append("<DATA>");
		
		for (int i = 0; i < resultList.size(); i++) {
			sb.append(commonUtil.getQueryResult(resultList.get(i)));
		}
		
		sb.append("</DATA>");
		
		result = "<ROOT>" + sb.toString() + parentName + "</ROOT>";

		logger.debug("get_favoriteList ended");
		return result;
	}
	
	/**
	 * 게시판 환경설정 호출 Method
	 */
	@RequestMapping(value="/ezBoard/boardConfig.do", method = RequestMethod.GET)
	public String boardConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, ModelMap modelMap, LoginVO userInfo, HttpServletResponse response) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
        //baonk 추가
        String pollFlag = "";
        if (ezCommonService.getTenantConfig("useBallotSystem", userInfo.getTenantId()).equalsIgnoreCase("YES")) {
        	pollFlag = "YES";
        }
        else {
        	pollFlag = "NO";
        }
        //end
        
        // 2018-08-06 황윤호 추가
        String memoFlag = "";
        if (ezCommonService.getTenantConfig("useMemo", userInfo.getTenantId()).equalsIgnoreCase("YES")) {
        	memoFlag = "YES";
        }
        else {
        	memoFlag = "NO";
        }
        
        modelMap.addAttribute("pollFlag", pollFlag);
        modelMap.addAttribute("memoFlag", memoFlag);

		return "ezBoard/boardConfig";
	}
	
	/**
	 * 게시판 환경설정 일반 호출 Method
	 */
	@RequestMapping(value="/ezBoard/boardGeneral.do", method = RequestMethod.GET)
	public String boardGeneral(@CookieValue("loginCookie") String loginCookie, LoginVO loginVO, Model model) throws Exception {
		logger.debug("boardGeneral started");

		loginVO = commonUtil.userInfo(loginCookie); 
		String pUserID = loginVO.getId();
		
		BoardConfigVO boardListConfig = ezBoardService.getBoardList_Config(pUserID, loginVO.getTenantId());
		
		if (boardListConfig == null) {
			boardListConfig = new BoardConfigVO();
			boardListConfig.setListCount(20);
			boardListConfig.setPreview("OFF");
			boardListConfig.setPreviewHList(50);
			boardListConfig.setPreviewHContent(50);
			boardListConfig.setPreviewWList(50);
			boardListConfig.setPreviewWContent(50);
		}
		
		model.addAttribute("boardListConfig", boardListConfig);

		logger.debug("boardGeneral ended");
		return "ezBoard/boardGeneral";
	}
	
	/**
	 * 게시판 사용자환경설정 저장 Method
	 */
	@RequestMapping(value="/ezBoard/board_generallist_save.do", method = RequestMethod.POST)
	@ResponseBody
	public void boardGeneralListSave(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse response, BoardConfigVO boardConfigVO) throws Exception {
		logger.debug("boardGeneralListSave started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		boardConfigVO.setTenantID(userInfo.getTenantId());
		boardConfigVO.setUserId(userInfo.getId());
		
		ezBoardService.setBoardList_Config(boardConfigVO);

		logger.debug("boardGeneralListSave ended");
	}
	
	/**
	 * 게시판 환경설정즐겨찾기 호출 Method
	 */
	@RequestMapping(value="/ezBoard/boardFavorite.do", method = RequestMethod.GET)
	public String boardFavorite(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("boardFavorite started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);

		logger.debug("boardFavorite ended");
		return "ezBoard/boardFavorite";
	}
	
	//baonk added
	@RequestMapping(value="/ezBoard/boardPollSetting.do", method = RequestMethod.GET)
	public String boardPollSetting(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie); 
		String pUserID = userInfo.getId();
		String listOfTarget = "";
		String startTime = "";
		String endTime = "";
		StringBuilder strXMLRange = new StringBuilder();
		StringBuilder listOfTargetBld = new StringBuilder();
		strXMLRange.append("<RANGE>"); 
		
		BoardPollConfigVO boardPollConfigVO = ezBoardService.getPollConfig(pUserID, userInfo.getTenantId());
		if (boardPollConfigVO == null) {
			model.addAttribute("hasConfig", 0);
		}
		else {
			model.addAttribute("hasConfig", 1);
			
			//Process time
			startTime = boardPollConfigVO.getDefaultStartTime();
			endTime = boardPollConfigVO.getDefaultEndTime();
			
			//Process target
	        String[] departIdList = null;
	        String targetDepts = boardPollConfigVO.getTargetDepts();
	        if(targetDepts != null){
	        	departIdList = targetDepts.split(",");
	        }
	        
	        String[] userIdList = null;
	        String targetUsers = boardPollConfigVO.getTargetUsers();
	        if(targetUsers != null){
	        	userIdList = targetUsers.split(",");
	        }
	        
	        if (targetDepts != null && !departIdList[0].equals("")) {
	        	strXMLRange.append("<DEPT>"); 
	        	
		        for (String deptID : departIdList) {
		        	OrganDeptVO organDeptVO = ezOrganService.getDeptInfo(deptID, userInfo.getPrimary(), userInfo.getTenantId());			        	
		        	strXMLRange.append("<DATA id=\"" + commonUtil.cleanValue(organDeptVO.getCn()) + "\" nm=\"" + commonUtil.cleanValue(organDeptVO.getDisplayName()) + 
		        			"\" nm2=\"" + commonUtil.cleanValue(organDeptVO.getDisplayName2()) + "\">" + commonUtil.cleanValue(organDeptVO.getCn()) + "</DATA>");
		        	
		        	if (userInfo.getPrimary().equals("1")) {
		        		listOfTargetBld.append(organDeptVO.getDisplayName1() + ", ");
		        	}
		        	else {
		        		listOfTargetBld.append(organDeptVO.getDisplayName2() + ", ");
		        	}
		        	
		        }
		        
		        strXMLRange.append("</DEPT>"); 
	        }
	        
	        if (targetUsers != null && !userIdList[0].equals("")) {
	        	strXMLRange.append("<MEMBER>"); 
	        	
	        	for (String userID : userIdList) {
	        		//개인 대상 특정할 경우 겸직 처리하기 위해 수정. 2018-11-27 홍대표.
	        		String deptID = "";
	        		String tmpUserID = userID;
	        		if(userID.indexOf('|') != -1) {
	        			userID = tmpUserID.split("\\|")[0];
	        			deptID = tmpUserID.split("\\|")[1];
	        		}
	        		
	        		LoginVO user = loginService.selectReceiver(userID, userInfo.getTenantId());
	        		strXMLRange.append("<DATA id=\"" + commonUtil.cleanValue(user.getId()) + "\" nm=\"" + commonUtil.cleanValue(userInfo.getPrimary().equals("1") ? user.getDisplayName1() : user.getDisplayName2())
		        			+ "\" nm2=\"" + commonUtil.cleanValue(user.getDeptName1()) + "\" deptid=\"" + commonUtil.cleanValue(deptID) + "\">"
	        				+ commonUtil.cleanValue(user.getId()) + "</DATA>");
	        		
		        	if (userInfo.getPrimary().equals("1")) {
		        		listOfTargetBld.append(user.getDisplayName1() + ", ");
		        	}
		        	else {
		        		listOfTargetBld.append(user.getDisplayName2() + ", ");
		        	}
	        		
	        	}		        	
	        	
	        	strXMLRange.append("</MEMBER>");
	        }
	        
	        listOfTarget = listOfTargetBld.toString();
	        
	        if (listOfTarget.endsWith(", ")) {
	        	listOfTarget = listOfTarget.substring(0, listOfTarget.length() - 2);
	        }
		}
		strXMLRange.append("</RANGE>");
		model.addAttribute("startTime", startTime);
		model.addAttribute("endTime", endTime);
		model.addAttribute("listOfTarget", listOfTarget);
		model.addAttribute("xmlRange", strXMLRange.toString());
		model.addAttribute("lang", userInfo.getLang());
		
		return "ezBoard/boardPoll";
	}
	
	@RequestMapping(value="/ezBoard/boardPollConfigSave.do", method = RequestMethod.POST)
	@ResponseBody
	public void boardPollConfigSave(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		int pDeptCnt = 0;
		int pUserCnt = 0;
		String targetDepts = "";
		String targetUsers = "";
		BoardPollConfigVO boardPollConfigVO = new BoardPollConfigVO();		
		String range = request.getParameter("rangeSelect");
		String startTime = request.getParameter("startTime");
		String endTime = request.getParameter("endTime");
		
		if (range != null && !range.equals("") && !range.equals("<RANGE></RANGE>")) {
			Document doc = commonUtil.convertStringToDocument(range);
			StringBuilder targetDeptsBuilder = new StringBuilder();
			StringBuilder targetUsersBuilder = new StringBuilder();
			
			if (doc.getElementsByTagName("DEPT").item(0) != null) {
				pDeptCnt = doc.getElementsByTagName("DEPT").item(0).getChildNodes().getLength();
			}				
			
			for (int j = 0; j < pDeptCnt; j++) {
				String deptID = doc.getElementsByTagName("DEPT").item(0).getChildNodes().item(j).getAttributes().getNamedItem("id").getTextContent();
				targetDeptsBuilder.append(deptID + ",");
			}	
			
			if (doc.getElementsByTagName("MEMBER").item(0) != null) {				
				pUserCnt = doc.getElementsByTagName("MEMBER").item(0).getChildNodes().getLength();			
			}
			
			for (int i = 0; i < pUserCnt; i++) {
				String userID = doc.getElementsByTagName("MEMBER").item(0).getChildNodes().item(i).getAttributes().getNamedItem("id").getTextContent();
				String deptID = doc.getElementsByTagName("MEMBER").item(0).getChildNodes().item(i).getAttributes().getNamedItem("deptid").getTextContent();
				
				userID = userID + "|" + deptID;
				targetUsersBuilder.append(userID + ",");
			}
			
			targetDepts = targetDeptsBuilder.toString();
			targetUsers = targetUsersBuilder.toString();
			
			if (targetDepts.endsWith(",")) {
				targetDepts = targetDepts.substring(0, targetDepts.length() - 1);
			}
			
			if (targetUsers.endsWith(",")) {
				targetUsers = targetUsers.substring(0, targetUsers.length() - 1);
			}
		}
				
		boardPollConfigVO.setTenantId(userInfo.getTenantId());
		boardPollConfigVO.setUserId(userInfo.getId());
		boardPollConfigVO.setTargetDepts(targetDepts);
		boardPollConfigVO.setTargetUsers(targetUsers);
		boardPollConfigVO.setDefaultStartTime(startTime);
		boardPollConfigVO.setDefaultEndTime(endTime);

		ezBoardService.saveBoardPollConfig(boardPollConfigVO);
	}
	//end
	
	
	
	/**
	 * 게시판 메모 환경설정 호출
	 * @param loginCookie
	 * @param userInfo
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/ezBoard/boardMemoSetting.do", method = RequestMethod.GET)
	public String boardMemoSetting(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("boardMemoSetting started");	
		userInfo = commonUtil.userInfo(loginCookie); 
		
		MemoConfigVO memoConfigVO = new MemoConfigVO();
		memoConfigVO.setUser_id(userInfo.getId());
		memoConfigVO.setTenant_id(userInfo.getTenantId());
		memoConfigVO.setCompany_id(userInfo.getCompanyID());
		
		memoConfigVO = ezMemoService.getMemoConfig(memoConfigVO);
		
		model.addAttribute("memoConfigVO", memoConfigVO);
		
		logger.debug("boardMemoSetting ended");
		return "ezBoard/boardMemo";	
	}
	
	
	/**
	 * 게시판 메모 환경설정 저장
	 * @param loginCookie
	 * @param userInfo
	 * @param request
	 * @param response
	 * @param memoConfigVO
	 * @throws Exception
	 */
	@RequestMapping(value="/ezBoard/boardMemoConfigSave.do", method = RequestMethod.POST)
	public String boardMemoConfigSave(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response, MemoConfigVO memoConfigVO) throws Exception {
		logger.debug("boardMemoConfigSave started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		memoConfigVO.setUser_id(userInfo.getId());
		memoConfigVO.setTenant_id(userInfo.getTenantId());
		memoConfigVO.setCompany_id(userInfo.getCompanyID());
		
		ezMemoService.setMemoConfig(memoConfigVO);
		logger.debug("boardMemoConfigSave ended");
		return "json";
	}
	
	/**
	 * 게시판 환경설정 메모 분류 호출
	 * @param loginCookie
	 * @param userInfo
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/ezBoard/boardMemoDivision.do", method = RequestMethod.GET)
	public String boardMemoDivision(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("boardMemoDivision started");	
		logger.debug("boardMemoDivision ended");
		return "ezBoard/boardMemoDivision";	
	}
	/**
	 * 게시판 부모게시판명 표출 Method
	 */
	public String parentBoardName(List<BoardMyFavoriteVO> resultList, LoginVO userInfo) throws Exception {
		logger.debug("parentBoardName started");

		String rtv = "";
		StringBuilder boardIdListBld = new StringBuilder();
		int boardIdListCount = 0;
		
		for (int i = 0; i < resultList.size(); i++) {
			boardIdListBld.append(resultList.get(i).getBoardId().trim());
			if (i != resultList.size() - 1) {
				boardIdListBld.append(";");
			}
		}
		
		String boardIdList = boardIdListBld.toString();
		boardIdListCount = boardIdList.split(";").length;
		
		rtv = ezBoardService.get_parentBoardName(boardIdList.trim(), boardIdListCount, userInfo.getLang(), userInfo.getTenantId(), userInfo.getLocale());
		
		logger.debug("parentBoardName ended");
		return "<DATA><TOPBOARDLIST>" + commonUtil.cleanValue(rtv) + "</TOPBOARDLIST></DATA>";
	}
	
	/**
	 * 게시판 나의게시판 설정 표출 Method
	 */
   @RequestMapping(value="/ezBoard/getMyBoardsConfig.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
   @ResponseBody
   public String getMyBoardsConfig(HttpServletRequest req, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse res) throws Exception {
	   logger.debug("getMyBoardsConfig started");

	   userInfo = commonUtil.userInfo(loginCookie);
	   
	   String lang = userInfo.getLang();
	   String pRootTreeID = req.getParameter("rootTreeID");
	   String pCountFlag = req.getParameter("countFlag");
	   // 마이게시판 가져올때 companyID 조건 추가
	   String resultXML = getMyBoardTreeConfig(userInfo.getId(), pRootTreeID, commonUtil.getLangData(lang), userInfo.getCompanyID(), userInfo.getTenantId());
	   resultXML = commonUtil.stripScriptTags(resultXML);
	   
	   if (ezCommonService.getTenantConfig("USE_BOARD_LEFTMENU_COUNT", userInfo.getTenantId()).equals("YES") && pCountFlag != null && pCountFlag.equals("YES")) {
		   Document doc = commonUtil.convertStringToDocument(resultXML);
		   NodeList nList = doc.getElementsByTagName("NODE");
		   String strName = "";
		   int intCount = 0;
		   
		   for (int i = 0; i < nList.getLength(); i++) {
			   if (nList.item(i).getChildNodes().item(4).getTextContent().equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")) {
				   intCount = ezBoardService.getBrdNewItemCount(userInfo.getId(), userInfo.getTenantId());
				   
				   if (intCount != 0) {
					   strName = "(" + intCount + ")";
				   }
				   
				   nList.item(i).getChildNodes().item(0).setTextContent(nList.item(i).getChildNodes().item(0).getTextContent() + strName);
				   
				   resultXML = commonUtil.convertDocumentToString(doc);
			   } else {
				   if (nList.item(i).getChildNodes().item(5).getTextContent().trim().equals("BOARD")) {
					   BoardPropertyVO boardInfo = getBoardInfo(nList.item(i).getChildNodes().item(4).getTextContent().trim(), userInfo);
					   BoardMyFavoriteVO myFavoriteVO = new BoardMyFavoriteVO();
					   myFavoriteVO.setUserId(userInfo.getId());
					   myFavoriteVO.setBoardId(nList.item(i).getChildNodes().item(4).getTextContent());
					   myFavoriteVO.setType("1");
					   myFavoriteVO.setTenantID(userInfo.getTenantId());
					   myFavoriteVO.setNowDate(commonUtil.getTodayUTCTime(""));
					   
					   if (boardInfo != null) {
						   if (boardInfo.getGuBun() != null && boardInfo.getGuBun().equals("4")) {
							   intCount = ezBoardService.getThumbNailCount(myFavoriteVO);
						   } else {
							   intCount = ezBoardService.getBrdTotalItemCount(myFavoriteVO);
						   }
					   }
					   
					   strName = "";
					   
					   /* 2023-06-28 황인경 - 디자인 개선 > 게시판 > 마이게시판 > 좌측메뉴 > 게시물 카운트 괄호 추가 */
					   /* 2018-12-11 홍승비 - 마이게시판리스트 우측 게시물 갯수에서 괄호 제거 */
					   if (intCount != 0) {
						   strName = "(" + intCount + ")";
					   }
					   
					   nList.item(i).getChildNodes().item(0).setTextContent(nList.item(i).getChildNodes().item(0).getTextContent() + strName);
					   
					   resultXML = commonUtil.convertDocumentToString(doc);
				   }
			   }
		   }
	   }

	   logger.debug("getMyBoardsConfig ended");
       return resultXML.replaceAll("onerror=alert", "");
   }
   
   /**
	 * 게시판 나의게시판트리 설정 표출 Method
	 */
	public String getMyBoardTreeConfig(String userID, String pRootTreeID, String lang, String companyID, int tenantID) throws Exception {
		logger.debug("getMyBoardTreeConfig started");

		// 마이게시판 리스트를 가져온다. companyID 조건 추가.
		List<BoardMyFavoriteVO> resultList  = ezBoardAdminService.getMyBoardTree_get3(userID, pRootTreeID.trim(), companyID, tenantID);
		
		StringBuilder sb = new StringBuilder();
		
		sb.append("<TREEVIEWDATA>");
		
		for (int i = 0; i < resultList.size(); i++) {
			sb.append("<NODE>");
			
			// 2023-11-29 조소정 - 게시판 > 마이게시판 일본어, 중국어 TreeName 컬럼 추가
			String treeName = resultList.get(i).getTreeName();

			if ("2".equals(lang)) {
			    treeName = resultList.get(i).getTreeName2();
			} else if ("3".equals(lang) && resultList.get(i).getTreeName3() != null && !resultList.get(i).getTreeName3().isEmpty()) {
			    treeName = resultList.get(i).getTreeName3();
			} else if ("4".equals(lang) && resultList.get(i).getTreeName4() != null && !resultList.get(i).getTreeName4().isEmpty()) {
			    treeName = resultList.get(i).getTreeName4();
			}
			
			sb.append("<VALUE><![CDATA[" + treeName + "]]></VALUE>");
			sb.append("<STYLE><![CDATA[]]></STYLE>");
			sb.append("<DATA1>" + resultList.get(i).getTreeId().trim() + "</DATA1>");
			
			String treeNameData2 = resultList.get(i).getTreeName().trim();

			if ("2".equals(lang)) {
				treeNameData2 = resultList.get(i).getTreeName2().trim();
			} else if ("3".equals(lang) && resultList.get(i).getTreeName3() != null && !resultList.get(i).getTreeName3().isEmpty()) {
				treeNameData2 = resultList.get(i).getTreeName3().trim();
			} else if ("4".equals(lang) && resultList.get(i).getTreeName4() != null && !resultList.get(i).getTreeName4().isEmpty()) {
				treeNameData2 = resultList.get(i).getTreeName4().trim();
			}

			sb.append("<DATA2><![CDATA[" + treeNameData2 + "]]></DATA2>");			
			sb.append("<DATA3><![CDATA[" + resultList.get(i).getTreeBoardId() + "]]></DATA3>");
			
			if (resultList.get(i).getTreeBoardId() == null || resultList.get(i).getTreeBoardId().equals("")) {
				sb.append("<DATA4>TREE</DATA4>");
			} else {
				sb.append("<DATA4>BOARD</DATA4>");
			}
			
			sb.append("<DATA5></DATA5>");
			sb.append("<EXPANDED>FALSE</EXPANDED>");
			
			if (resultList.get(i).getChildCnt() > 0) {
				sb.append("<ISLEAF>FALSE</ISLEAF>");
			} else {
				sb.append("<ISLEAF>TRUE</ISLEAF>");
			}
			
			if (resultList.get(i).getTreeBoardId() != null && resultList.get(i).getTreeBoardId().equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")) {
				sb.append("<SELECT>TRUE</SELECT>");
			}
			
			sb.append("</NODE>");
		}
		
		sb.append("</TREEVIEWDATA>");

		logger.debug("getMyBoardTreeConfig ended");
        return sb.toString();
	}
	
	/**
	 * 게시판 일반,포토,새 게시판리스트 호출 Method
	 */
	@RequestMapping(value= {"/ezBoard/boardItemList_new.do", "/ezBoard/boardItemList_all.do", "/ezBoard/boardItemList.do", "/ezBoard/boardItemListPhoto.do", "/ezBoard/boardItemList_allnew.do"}, method = RequestMethod.GET)
	public String boardItemList(HttpServletRequest request, LoginVO userInfo, BoardPropertyVO boardPropertyVO, @CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("boardItemList started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String use_ocs = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId());
		String use_Editor = ezCommonService.getTenantConfig("MODULEEDITOR", userInfo.getTenantId()); 
		String useRunTime = ezCommonService.getTenantConfig("USERUNTIME", userInfo.getTenantId());
		String use_oneLineCount = "";
		String pBoardID = boardPropertyVO.getBoardID() != null ? boardPropertyVO.getBoardID() : "";
		String requestURL = (String) request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);
		
		//뷰만 다르고 cs가 같은 경우여서 requestURL 사용해서 다이나믹뷰
		requestURL = requestURL.substring(1, requestURL.length() - 3);
		
		BoardPropertyVO boardInfo = getBoardInfo(pBoardID, userInfo);
		
		// 2023-11-29 조소정 - 게시판 리스트 호출 시 게시판 이름 사용자 설정 언어로 표출
		String userLang = userInfo.getLang();
		String pBoardName = boardInfo.getBoardName(); // 기본값은 한국어로 설정

		if (userLang.equals("2") && boardInfo.getBoardName2() != null && !boardInfo.getBoardName2().isEmpty()) {
		    pBoardName = boardInfo.getBoardName2();
		} else if (userLang.equals("3") && boardInfo.getBoardName3() != null && !boardInfo.getBoardName3().isEmpty()) {
		    pBoardName = boardInfo.getBoardName3();
		} else if (userLang.equals("4") && boardInfo.getBoardName4() != null && !boardInfo.getBoardName4().isEmpty()) {
		    pBoardName = boardInfo.getBoardName4();
		}
		
		if (boardPropertyVO.getAdminType() == null) {
			boardInfo.setAdminType("");
		} else {
			boardInfo.setAdminType(boardPropertyVO.getAdminType());
		}
		
		if (boardPropertyVO.getButtonHidden() == null) {
			boardInfo.setButtonHidden("N");
		} else {
			boardInfo.setButtonHidden(commonUtil.stripScriptTags(boardPropertyVO.getButtonHidden()));
		}
		
		if (boardPropertyVO.getBoardType() == null) {
			boardInfo.setBoardType("");
		} else {
			boardInfo.setBoardType(commonUtil.stripScriptTags(boardPropertyVO.getBoardType()));
		}
		
		BoardPropertyVO boardProperty = ezBoardService.getBoardProperty(pBoardID, userInfo.getTenantId());
		
		if (boardProperty != null && boardProperty.getOneLineReply() != null && !boardProperty.getOneLineReply().equals("") && !boardProperty.getOneLineReply().equals("0")) {
			use_oneLineCount = "YES";
		} else {
			use_oneLineCount = "NO";
		}
		
		if (boardInfo.getListView_FG().equals("true")) {
			if (request.getParameter("page") == null || request.getParameter("page").equals("")) {
				boardInfo.setPage(1);
			} else {
				boardInfo.setPage(boardPropertyVO.getPage());
			}
			
			if (boardPropertyVO.getSortBy() != null) {
				boardInfo.setSortBy(boardPropertyVO.getSortBy());
			}
			
//			if (boardInfo.getBoardName() != null) {
//				pBoardName = boardInfo.getBoardName();
//			}
		}
		
		// 현재 자신의 회사에서 즐겨찾기한 게시판 + 그룹사 게시판의 즐겨찾기 여부를 체크
		String isMyBoard = "";
		int isMyBoardExist = ezBoardService.getIsMyBoardExist(pBoardID, userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
		if (isMyBoardExist > 0) {
			isMyBoard = "YES";
		}
		
		//확장컬럼 데이터
		List<BoardAttributeVO> boardAttr = new ArrayList<BoardAttributeVO>();
		int boardAttrCount = 0;

		if (boardInfo.getAttributeYN() != null && boardInfo.getAttributeYN().equals("Y")) {
			boardAttr = ezBoardAdminService.getBoardAttribute(pBoardID, userInfo.getTenantId());
			boardAttrCount = boardAttr.size();
		}

		// 2024-08-14 전인하 - 게시판 > json data 이용 시 문제가 되는 특정 특수문자 이스케이프 추가 
		JsonSerializer<String> stringSerializer = new JsonSerializer<String>() {
			@Override
			public JsonElement serialize(String src, Type typeOfSrc, JsonSerializationContext context) {
				String escapedString = src.replace("\\", "\\\\")
											.replace("\"", "\\\"")
											.replace("/", "\\/");
				return new JsonPrimitive(escapedString);
			}
		};
		
		Gson gson = new GsonBuilder().registerTypeAdapter(String.class, stringSerializer).create();
		String boardAttrJson = gson.toJson(boardAttr);
		
		String endDateOption = checkEndDateConfig(boardInfo, userInfo);

		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("boardName", commonUtil.cleanValue(pBoardName).replace("\\", "&#92;"));
		model.addAttribute("boardID", commonUtil.stripScriptTags(pBoardID));
		model.addAttribute("boardAttrJson", boardAttrJson);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("useRunTime", useRunTime);
		model.addAttribute("use_ocs", use_ocs);
		model.addAttribute("use_Editor", use_Editor);
		model.addAttribute("use_oneLineCount", use_oneLineCount);
		model.addAttribute("isMyBoard", isMyBoard);
		model.addAttribute("endDateOption", endDateOption);
		model.addAttribute("useKeyword", boardProperty.getUseKeyword());
		model.addAttribute("MyBoardScrapFlag", ezCommonService.getTenantConfig("MyBoardScrapFlag", userInfo.getTenantId()));

		logger.debug("boardItemList ended");
		//logger.debug("requestURL : " + requestURL);
        return requestURL;
	}

	/**
	 * 게시판 게시판정보 표출 Method
	 */
	public BoardPropertyVO getBoardInfo(String pBoardID, LoginVO userInfo) throws Exception {
		logger.debug("getBoardInfo started");

		BoardPropertyVO boardInfo = new BoardPropertyVO();
		boardInfo.setSs_board_maxRows(20);
		boardInfo.setSs_searchBoard_maxRows(10);
		
		if (pBoardID == null || pBoardID.equals("")) {
			boardInfo.setBoardName(egovMessageSource.getMessage("ezBoard.t229", userInfo.getLocale()));
			boardInfo.setDelete_FG("true");
			return boardInfo;
		}
		
		String deptPath = userInfo.getDeptPathCode();
		StringBuilder deptPathOrgan = new StringBuilder();
		List<String> addJobDeptList = new ArrayList<String>();
		
		/* 2019-09-24 홍승비 - 개인ID 이후, 부서ID 이전 위치에 직위+직책ID (사내겸직 직위 포함) 추가 */
		String userJJID = ezBoardService.getUserJJID(userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		for (int ch = 0; ch < deptPath.split(",").length; ch++) {
			if (ch == 0) { // 0 : userID
				deptPathOrgan.append(deptPath.split(",")[ch].trim());
				deptPathOrgan.append(",").append(userJJID);
			} else {
				deptPathOrgan.append(",").append(deptPath.split(",")[deptPath.split(",").length - (ch)].trim());
			}
		}
		
		// 권한 AccessID 체크 시 'everyone' 제거 (사용하지 않는 ID임)
		String userDeptPath = deptPathOrgan.toString();
		addJobDeptList.add(userDeptPath);
		
		/* 2019-05-29 홍승비 - 현재 소속 회사의 사내겸직이 존재하면 사내겸직부서ID와 그 상위부서ID까지 권한체크에 포함하도록 수정 */
		List<String> addJobList = ezBoardService.getPDOAddJobDeptID(userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
		StringJoiner addJobStr = new StringJoiner(",");
		addJobStr.add(userInfo.getDeptID());
		if (addJobList != null && addJobList.size() > 0) {
			for (int i = 0; i < addJobList.size(); i++) {
				addJobStr.add(addJobList.get(i));
				// 각 사내겸직부서ID에 대해 상위부서 ~ 회사ID를 전부 가져오는 루프 (Top까지 전부 가져오도록 한다.)
				String upperDept = ezBoardService.getUpperDeptID(addJobList.get(i), userInfo.getTenantId());
				
				if (upperDept != null && !upperDept.equals("")) {
					
					boolean loopContinue = true;
					StringJoiner upperDeptStr = new StringJoiner(",");
					upperDeptStr.add(upperDept);
					
					while (loopContinue) {
						String upperDeptLoop = ezBoardService.getUpperDeptID(upperDept, userInfo.getTenantId());
						// 각 사내겸직의 최상위에 도달하면 루프 종료
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
		
		/* 2019-06-10 홍승비 - 게시판그룹의 관리자권한 체크를 위한 쿼리 파라미터 추가(게시판그룹의 관리자권한과 하위게시판의 관리자권한 혼용 방지) */
		boolean isBoardGroup = false;
		BoardPropertyVO orgBoardProp = ezBoardService.getBoardProperty(pBoardID, userInfo.getTenantId());
		if (orgBoardProp != null) {
			if (orgBoardProp.getBoardGroupID() != null && !orgBoardProp.getBoardGroupID().equals("")) { // 하위게시판
				isBoardGroup = false;
			} else { // 게시판그룹
				isBoardGroup = true;
			}
		}
		
		List<BoardPropertyVO> boardACLListDept = new ArrayList<BoardPropertyVO>();
		List<BoardPropertyVO> boardACLListJJ = new ArrayList<BoardPropertyVO>();
		Set<String> userJJIDSet = new HashSet<String>(Arrays.asList(userJJID.split(",")));
		
		boolean isUserHasACL = false;
		String tempDeptList = addJobStr.toString();
		int addJobDeptListSize = addJobDeptList.size();
		for (int jl = 0; jl < addJobDeptListSize; jl++) {
			// 개인 권한이 존재하지 않는 경우에만 부서 경로에 대해 권한체크 루프
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
					
					int isDept = ezBoardService.isDeptChk(addJobDeptList.get(jl).split(",")[i].trim(), userInfo.getTenantId());
					
					/* 2019-09-18 홍승비 - 동일한 ACCESSID에 대해 리스트로 리턴된 권한을 '허용'권한 기준으로 취합 */
					// 우선순위는 알아서 적용됨(이미 addJobDeptList가 우선순위를 적용한 문자열 순서대로 만들어졌음)
					// 개인 - 직위/직책 - 부서/회사 순으로 알아서 우선순위가 적용되고, 각 루프에서 가장 우선순위가 높은 권한을 찾으면 다음 루프로 빠져나감
					BoardPropertyVO boardInfoTempNew = new BoardPropertyVO();
					List<BoardPropertyVO> boardInfoTempList = ezBoardService.getACLListNew(pBoardID, addJobDeptList.get(jl).split(",")[i].trim(), userInfo.getTenantId(), isDept, isEqualDept);
					if (boardInfoTempList != null && boardInfoTempList.size() > 0) {
						boardInfoTempNew = sumBoardACL(boardInfoTempList, boardInfoTempNew);
					}
					
					/* 2019-09-24 홍승비 - 권한그룹을 포함하여 게시판그룹 관리자권한 체크 */
					// 권한그룹 적용 시 개인권한이 다수 존재 가능하므로, 권한을 리스트로 가져온 뒤 '허용(OK)'기준으로 취합한다.
					String boardGroupAdmin_FG_New = "";
					List<String> boardGroupAdmin_FG_List = ezBoardService.checkIfBoardGroupAdminNew(pBoardID, addJobDeptList.get(jl).split(",")[i].trim(), userInfo.getTenantId(), isDept, isEqualDept, isBoardGroup);
					if (boardGroupAdmin_FG_List != null && boardGroupAdmin_FG_List.size() > 0) { // 권한이 없으면 공백값을 유지 > 다음 루프 진행
						if (boardGroupAdmin_FG_List.contains("OK")) { // 동일한 우선순위의 권한에 대해서, OK가 하나라도 존재한다면 OK로 판정
							boardGroupAdmin_FG_New = "OK";
						} else {
							boardGroupAdmin_FG_New = "NO";
						}
					}
					
					// 사원 개인에 대해 권한이 존재한다면 바로 빠져나오고(isUserHasACL = true) 해당 권한 그대로 사용함 (최우선순위 권한)
					if (boardInfoTempList != null && boardInfoTempList.size() > 0) {
						boardInfoTempNew.setBoardGroupAdmin_FG(boardGroupAdmin_FG_New); // 게시판그룹의 관리자권한 temp에 셋팅
						
						if (addJobDeptList.get(jl).split(",")[i].trim().equals(userInfo.getId())) { // 개인권한
							boardInfo = boardInfoTempNew;
							isUserHasACL = true;
							break;
						}
						else if (userJJIDSet.contains(addJobDeptList.get(jl).split(",")[i].trim())) { // 직위, 직책 권한
							boardACLListJJ.add(boardInfoTempNew);
							isUserHasACL = false;
							// 직위, 직책은 게시판그룹의 관리자권한 레코드를 전부 찾을때까지 break 하지 않는다.
						}
						else { // 부서, 회사의 권한
							boardACLListDept.add(boardInfoTempNew);
							isUserHasACL = false;
							break;
						}
					}
					else if (!boardGroupAdmin_FG_New.equals("")) { // 주어진 ACCESSID에 대하여 해당 게시판에는 권한이 존재하지 않으나, 게시판 그룹에 대하여 관리자권한이 존재하는 경우
						BoardPropertyVO boardGroupAdminFG = new BoardPropertyVO();
						if (boardGroupAdmin_FG_New.equals("OK")) {
							boardGroupAdminFG.setBoardGroupAdmin_FG("OK");
							boardGroupAdminFG.setAccess_("1");
							
							// 게시판그룹의 관리자 권한이 '허용'인 경우에만 break하도록 한다. ('불가'인 경우, 어짜피 관리자 권한을 적용하지 않는거라서 그냥 무시)
							if (addJobDeptList.get(jl).split(",")[i].trim().equals(userInfo.getId())) { // 개인의 게시판그룹 관리자 권한
								// 개인에 대하여 게시판그룹의 관리자 권한이 존재하므로, 루프를 벗어난다.
								boardInfo.setBoardGroupAdmin_FG(boardGroupAdmin_FG_New);
								isUserHasACL = true;
								break;
							}
							else if (userJJIDSet.contains(addJobDeptList.get(jl).split(",")[i].trim())) { // 직위, 직책의 게시판그룹 관리자  권한
								boardGroupAdminFG.setAccessID(addJobDeptList.get(jl).split(",")[i]);
								boardACLListJJ.add(boardGroupAdminFG);
								isUserHasACL = false;
							}
							else { // 부서, 회사의 게시판그룹 관리자  권한
								boardGroupAdminFG.setAccessID(addJobDeptList.get(jl).split(",")[i]);
								boardACLListDept.add(boardGroupAdminFG);
								isUserHasACL = false;
								break;
							}
						} else { // 게시판그룹의 관리자 권한이 '불가'인 경우, 루프를 계속 진행한다.
							boardGroupAdminFG.setBoardGroupAdmin_FG("NO");
						}
					}
				}
			}
		}
		
		if (isUserHasACL == false) { // 개인 권한이 존재하지 않는 경우에만 권한 취합  > 직위, 직책권한이 없으면 부서권한 취합
			if (boardACLListJJ.size() > 0) { // 직위, 직책권한 부여
				boardInfo = sumBoardACL(boardACLListJJ, boardInfo);
			} else { // 직위, 직책권한이 없다면 부서권한 부여
				boardInfo = sumBoardACL(boardACLListDept, boardInfo);
			}
		}
		
		/* 2018-10-17 홍승비 - 해당 게시판의 모든 정보(TBL_BOARD_BOARDINFO오로부터)를 가져오는 부분을 상단으로 이동함 */
		BoardPropertyVO strProp = ezBoardService.getBoardProperty(pBoardID, userInfo.getTenantId());
		boardInfo.setIsAllGroupBoard("");
		
		if (strProp != null) {
			boardInfo.setExpireDays(strProp.getItemExpires() != null ? strProp.getItemExpires() : "-1");
			boardInfo.setAttachSizeLimit(strProp.getAttachSizeLimit());
			
			if (userInfo.getPrimary() != null && strProp.getBoardName2() != null && userInfo.getPrimary().equals("2") && !strProp.getBoardName2().equals("")) {
				boardInfo.setBoardName(strProp.getBoardName2());
			} else {
				boardInfo.setBoardName(strProp.getBoardName());
			}
			/* 2018-12-18 홍승비 - 마이게시판의 다국어 저장을 위한 속성 추가 */
			if (strProp.getBoardName2() != null) {
				boardInfo.setBoardName2(strProp.getBoardName2());
			}

			if (strProp.getBoardName3() != null) {
				boardInfo.setBoardName3(strProp.getBoardName3());
			}

			if (strProp.getBoardName4() != null) {
				boardInfo.setBoardName4(strProp.getBoardName4());
			}

			boardInfo.setReplyNotify(strProp.getReplyNotify());
			boardInfo.setGuBun(strProp.getGuBun());
			boardInfo.setUrl(strProp.getUrl());
			boardInfo.setApprFlag(strProp.getApprFlag());
			boardInfo.setApprMail_FG(strProp.getApprMailFlag());
			boardInfo.setAttributeYN(strProp.getAttributeYN());
			boardInfo.setLikeFlag(strProp.getLikeFlag());
			boardInfo.setDisLikeFlag(strProp.getDisLikeFlag());
			boardInfo.setOneLineReply(strProp.getOneLineReply()); // 댓글옵션정보 추가
			boardInfo.setReactFlag(strProp.getReactFlag()); // 댓글 좋아요/싫어요 사용여부 플래그 추가
			boardInfo.setUseKeyword(strProp.getUseKeyword()); // useKeywordFlag 플래그 추가
			boardInfo.setAttachmentFlag(strProp.getAttachmentFlag()); // 첨부파일 플래그 추가
            boardInfo.setPublicFlag(strProp.getPublicFlag()); // 게시물 공개여부 선택
			boardInfo.setWriterFlag(strProp.getWriterFlag());
			boardInfo.setStarRatingFlag(strProp.getStarRatingFlag()); // 별점 사용여부 플래그 추가
			boardInfo.setVersionManage(strProp.getVersionManage()); // 버전관리 사용여부 플래그 추가

			/* 2018-10-17 홍승비 - 게시판의 그룹게시판이 구분값 99인지 확인하여 게시판 boardInfo에 isAllGroupBoard값 셋팅 */
			String boardGroupID = strProp.getBoardGroupID();
			
			/* 2019-06-03 홍승비 - 게시판그룹에 대해서도 그룹사게시판 여부 적용 */
			if (boardGroupID != null) { // 새게시물과 부모가 top인 게시판들(그룹)은 그룹아이디가 없다.
				BoardPropertyVO strGroupProp = ezBoardService.getBoardProperty(boardGroupID, userInfo.getTenantId());
				if (strGroupProp.getGuBun() != null && strGroupProp.getGuBun().equals("99")) {
					boardInfo.setIsAllGroupBoard("Y");
				} else {
					boardInfo.setIsAllGroupBoard("N");
				}
			} else if (boardInfo.getGuBun() != null && boardInfo.getGuBun().equals("99")) { // 게시판 그룹의 경우
				boardInfo.setIsAllGroupBoard("Y");
			} else {
				boardInfo.setIsAllGroupBoard("N");
			}
		}
		
		if (pBoardID.equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}") || pBoardID.equals("{YYYYYYYY-YYYY-YYYY-YYYY-YYYYYYYYYYYY}") || pBoardID.equals("{ZZZZZZZZ-ZZZZ-ZZZZ-ZZZZ-ZZZZZZZZZZZZ}")) {
			boardInfo.setAccess_("1");
			boardInfo.setAccess_FG("1");
			boardInfo.setBoardAdmin_FG("false");
			boardInfo.setListView_FG("true");
			boardInfo.setRead_FG("true");
			boardInfo.setWrite_FG("true");
			boardInfo.setReply_FG("true");
			boardInfo.setDelete_FG("true");
		} 
		/* 회사관리자, 게시관리자들은 '그룹사게시판이 아닌 경우에만' 고정된 관리자 권한을 갖는다. 전체관리자는 전부 관리자로 허용된다.*/
		else if (commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "c") || 
				(!boardInfo.getIsAllGroupBoard().equals("Y") && (commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "n;k")))) {
			boardInfo.setAccess_("1");
			boardInfo.setAccess_FG("1");
			boardInfo.setBoardAdmin_FG("true");
			boardInfo.setListView_FG("true");
			boardInfo.setRead_FG("true");
			boardInfo.setWrite_FG("true");
			boardInfo.setReply_FG("true");
			boardInfo.setDelete_FG("true");
		} else if (boardInfo.getBoardGroupAdmin_FG() != null && boardInfo.getBoardGroupAdmin_FG().equals("OK")) {
			boardInfo.setAccess_("1");
			boardInfo.setAccess_FG("1");
			boardInfo.setBoardAdmin_FG("true");
			boardInfo.setListView_FG("true");
			boardInfo.setRead_FG("true");
			boardInfo.setWrite_FG("true");
			boardInfo.setReply_FG("true");
			boardInfo.setDelete_FG("true");
		} else if (boardInfo.getBoardAdmin_FG() == null || boardInfo.getBoardAdmin_FG().equals("")) {
			boardInfo.setAccess_("1");
			boardInfo.setAccess_FG("1");
			boardInfo.setBoardAdmin_FG("false");
			boardInfo.setListView_FG("false");
			boardInfo.setRead_FG("false");
			boardInfo.setWrite_FG("false");
			boardInfo.setReply_FG("false");
			boardInfo.setDelete_FG("false");
		}
		
/*		logger.debug("boardInfo before ended    ::   BoardGroupAdmin_FG=" + boardInfo.getBoardGroupAdmin_FG() + " | BoardAdmin_FG=" + boardInfo.getBoardAdmin_FG()  + " | Access_=" + boardInfo.getAccess_()
				+ " | ListView_FG=" + boardInfo.getListView_FG() + " | Read_FG=" + boardInfo.getRead_FG() + " | Write_FG=" + boardInfo.getWrite_FG()
				+ " | Reply_FG=" + boardInfo.getReply_FG() + " | Delete_FG=" + boardInfo.getDelete_FG());*/
		logger.debug("getBoardInfo ended");
        return boardInfo;
	}
	
	/**
	 * 게시판 게시판리스트 표출 Method
	 */
    @RequestMapping(value = "/ezBoard/getBoardList.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
    @ResponseBody
    public String getBoardList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, BoardVO boardVO) throws Exception{
    	logger.debug("getBoardList started");
    	
    	userInfo = commonUtil.userInfo(loginCookie);
    	
    	String boardID = boardVO.getBoardId() != null ? boardVO.getBoardId() : "";
    	String boardType = boardVO.getBoardType() != null ? boardVO.getBoardType() : "0";
    	String mode = boardVO.getMode();
    	String type = "1";
    	String resultXML = "";
    	
    	if (boardVO.getType() != null && !boardVO.getType().equals("")) {
    		type = boardVO.getType();
    	}
    	
    	BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
    	
    	boardVO.setType(type);
    	boardVO.setLang(userInfo.getLang());
    	boardVO.setTenantID(userInfo.getTenantId());
    	boardVO.setLikeFlag(boardInfo.getLikeFlag());
    	boardVO.setDisLikeFlag(boardInfo.getDisLikeFlag());
    	
    	int tempPageNum = new Integer(boardVO.getPageNum()) != null ? boardVO.getPageNum() : 1;
    	boardVO.setPageNum(tempPageNum);
    	
    	String tempOrderOption = boardVO.getOrderOption() != null ? boardVO.getOrderOption() : "";
    	String tempOrderCell = boardVO.getOrderCell() != null ? boardVO.getOrderCell() : "";
    	boardVO.setOrderOption(tempOrderOption);
    	boardVO.setOrderCell(tempOrderCell);
    	
    	if (boardType.equals("4") || boardType.equals("7")) { // 썸네일, 동영상
    		resultXML = getThumbList(boardVO, userInfo, type);
    	} else if (boardType.equals("5")) { //Q&A
    		resultXML = getQnAListItem(boardVO, userInfo, type, boardInfo.getBoardAdmin_FG());
    	} else if (boardType.equals("M")) { //마이게시판 > 나의게시물
    		resultXML = getMyboardList(boardVO, userInfo, mode);
    	} else if (boardType.equals("A")) { //게시판승인
    		resultXML = getApprboardList(boardVO, userInfo, mode, type);
    	} else if (boardType.equals("R")) { // 최근게시물
			resultXML = getAllNewItemList(boardVO, userInfo);
		} else {
    		if (boardID.equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")) { // 새게시물
    			boardVO.setBoardType("N");
    			resultXML = getNewItemList(boardVO, userInfo);
    		} else if (boardID.equals("{ZZZZZZZZ-ZZZZ-ZZZZ-ZZZZ-ZZZZZZZZZZZZ}")) {
    			resultXML = getAllItemList(boardVO, userInfo);
    		} else { // 일반게시판
    			resultXML = getBoardListItem(boardVO, userInfo, type);
    		}
    	}

    	logger.debug("getBoardList ended");
        return resultXML.toString();
    }
    
	/**
	 * 게시판 승인게시판 표출 Method
	 */
    public String getApprboardList(BoardVO boardVO, LoginVO userInfo, String mode, String type) throws Exception {
    	logger.debug("getApprboardList started");

    	String orderOption1 = "";
    	String orderOption2 = "";
    	String strMultiData = commonUtil.getMultiData(boardVO.getLang(), userInfo.getTenantId());
    	
    	List<BoardListHeaderVO> headerList = ezBoardService.getListHeader(userInfo, boardVO);
    	
    	int i = 0;
    	int hlength = headerList.size();
    	int writeDateSN = 0;
    	int titleSN = 0;
    	Map<String, String> orderByMap = new HashMap<String, String>();
    	
		for (i = 0; i < hlength; i++) {
			if (boardVO.getOrderCell() != null && !boardVO.getOrderCell().equals("") && boardVO.getOrderCell().equals(headerList.get(i).getName())) {
				orderByMap.put("orderByCol", headerList.get(i).getColName().toUpperCase());
				if (boardVO.getOrderOption().equals("")) {
					orderByMap.put("orderByColDesc", "N");
					orderOption1 = headerList.get(i).getColName() + " ";
					orderOption2 = headerList.get(i).getColName() + " DESC ";
				} else {
					orderByMap.put("orderByColDesc", "Y");
					orderOption1 = headerList.get(i).getColName() + " DESC ";
					orderOption2 = headerList.get(i).getColName() + " ";
				}
			}
		}
    	
    	int noticeCount = 0;
    	int boardCount = 0;
    	
    	if (mode == null || !mode.equals("temp")) {
    		boardCount = ezBoardService.getApprBoardTotalItemCount(userInfo);
    	} else {
    		boardCount = ezBoardService.getMyBoardTotalItemCountTemp(userInfo);
    	}
    	
    	int startRow = 1;
    	int endRow = 0;
    	
    	BoardConfigVO boardConfigVO = ezBoardService.getPersonalCount(userInfo);
    	
    	int personalCount = boardConfigVO.getListCount();
    	String previewtype = boardConfigVO.getPreview();
    	String fieldName = "";
    	String fieldValue = "";
    	
    	if (boardVO.getPageNum() == 0) {
    		boardVO.setPageNum(1);
    	}
    	
    	StringBuffer resultXML = new StringBuffer();
    	
    	resultXML.append("<DOCLIST>");
    	
    	if (mode == null || !mode.equals("temp")) {
    		noticeCount = 0;
    		
    		// noticeCount 값이 반드시 0으로 고정되므로, 불필요한 분기 주석처리
    		/*if (noticeCount > 0) {
    			int start = ((boardVO.getPageNum() - 1) * personalCount) + 1;
    			int end = (boardVO.getPageNum() * personalCount);
    			
    			List<HashMap<String, Object>> noticeList = ezBoardService.getMyNoticePostItem(userInfo, "Y", start, end);
    			
    			int k = 0;
    			int nlength = noticeList.size();
    			
    			resultXML.append("<TOTALCNT>" + boardCount + "</TOTALCNT>");
    			resultXML.append("<PAGECNT>" + ((int)noticeCount  +  (int)boardCount) + "</PAGECNT>");
    			resultXML.append("<PERSONALCNT>" + personalCount + "</PERSONALCNT>");
    			resultXML.append("<PREVIEWTYPE>" + previewtype + "</PREVIEWTYPE>");
    			resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
    			resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
    			resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
    			resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
    			resultXML.append("<WRITEDATENUM>" + writeDateSN + "</WRITEDATENUM>");
    			resultXML.append("<TITLENUM>" + titleSN + "</TITLENUM>");
    			resultXML.append("<LISTVIEWDATA>");
    			resultXML.append("<HEADERS>");
    			
    			for (BoardListHeaderVO vo:headerList) {
    				resultXML.append("<HEADER>");
    				resultXML.append("<NAME>" + vo.getName() + "</NAME>");
    				resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
    				resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
    				resultXML.append("</HEADER>");
    			}
    			
    			resultXML.append("</HEADERS>");
    			resultXML.append("<ROWS>");
    			
    			for (k=0; k < nlength; k++) {
    				resultXML.append("<ROW>");
    				for (i = 0; i < hlength; i++) {
    					resultXML.append("<CELL>");
    					fieldName = headerList.get(i).getColName().toUpperCase();
    					
    					if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME")) {
    						fieldName = fieldName + strMultiData;
    					}
    					if (fieldName.equals("WRITEDATE")) {
    						fieldValue = commonUtil.getDateStringInUTC((String) noticeList.get(k).get(fieldName), userInfo.getOffset(), false);
    						fieldValue = fieldValue.substring(0, fieldValue.length()-3);
    					} else {
    						fieldValue = commonUtil.cleanValue(String.valueOf(noticeList.get(k).get(fieldName)));
    					}
    					
    					resultXML.append("<VALUE>"+fieldValue+"</VALUE>");
    					
    					if (i == 0) {
    						resultXML.append("<DATA1>" + noticeList.get(k).get("BOARDID") + "</DATA1>");
    						resultXML.append("<DATA2>" + noticeList.get(k).get("ITEMID") + "</DATA2>");
    						resultXML.append("<DATA3>" + noticeList.get(k).get("WRITERID") + "</DATA3>");
    						resultXML.append("<DATA4>" + noticeList.get(k).get("IMPORTANCE") + "</DATA4>");
    						resultXML.append("<DATA5>" + noticeList.get(k).get("READFLAG") + "</DATA5>");
    						resultXML.append("<DATA6>" + commonUtil.cleanValue((String)noticeList.get(k).get("ABSTRACT")) + "</DATA6>");
    						String nowDate = commonUtil.getTodayUTCTime("");
    						nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
    						
    						if (noticeList.get(k).get("WRITEDATE").toString().compareTo(nowDate) > 0) {
    							resultXML.append("<DATA7>Y</DATA7>");
    						} else {
    							resultXML.append("<DATA7>N</DATA7>");
    						}
    						
    						resultXML.append("<DATA8>" + noticeList.get(k).get("ITEMLEVEL") + "</DATA8>");
    						resultXML.append("<DATA9>" + noticeList.get(k).get("NOTICE") + "</DATA9>");
    						resultXML.append("<DATA10></DATA10>");
    						resultXML.append("<DATA11>" + noticeList.get(k).get("ONELINECNT") + "</DATA11>");
    						
    						// 2023-11-17 홍승비 - 게시물 승인 시 게시(답변)알림메일 발송 기능을 위한 파라미터 추가
    						if (noticeList.get(k).get("COMPANYID") == null || noticeList.get(k).get("COMPANYID").equals("")) {
    							resultXML.append("<ISALLGROUPBOARD>Y</ISALLGROUPBOARD>"); // 그룹사게시판 여부 (그룹사게시판은 회사ID 없음)
    						} else {
    							resultXML.append("<ISALLGROUPBOARD>N</ISALLGROUPBOARD>");
    						}
    						
    						resultXML.append("<UPPERITEMIDTREE>" + noticeList.get(k).get("UPPERITEMIDTREE") + "</UPPERITEMIDTREE>");
    						resultXML.append("<PARENTWRITEDATE>" + noticeList.get(k).get("PARENTWRITEDATE") + "</PARENTWRITEDATE>");
    						resultXML.append("<DOCNO>" + noticeList.get(k).get("DOCNO") + "</DOCNO>");
    						resultXML.append("<EXT>" + commonUtil.cleanValue((String) noticeList.get(k).get("EXT")) + "</EXT>");
    						resultXML.append("<FILEPATH>" + commonUtil.cleanValue((String) noticeList.get(k).get("FILEPATH")) + "</FILEPATH>");
    					}
    					
    					resultXML.append("</CELL>");
    				}
    				
    				resultXML.append("</ROW>");
    			}
    		} else { */
			startRow = ((personalCount * (boardVO.getPageNum() - 1))) + 1;
			endRow = (personalCount * boardVO.getPageNum());
			
			resultXML.append("<TOTALCNT>" + boardCount + "</TOTALCNT>");
			resultXML.append("<PAGECNT>" + boardCount + "</PAGECNT>");
			resultXML.append("<PERSONALCNT>" + personalCount + "</PERSONALCNT>");
			resultXML.append("<PREVIEWTYPE>" + previewtype + "</PREVIEWTYPE>");
			resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
			resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
			resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
			resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
			resultXML.append("<WRITEDATENUM>" + writeDateSN + "</WRITEDATENUM>");
			resultXML.append("<TITLENUM>" + titleSN + "</TITLENUM>");
			resultXML.append("<LISTVIEWDATA>");
			resultXML.append("<HEADERS>");
			
			for (BoardListHeaderVO vo:headerList) {
				resultXML.append("<HEADER>");
				resultXML.append("<NAME>"+vo.getName()+"</NAME>");
				resultXML.append("<WIDTH>"+vo.getWidth()+"</WIDTH>");
				resultXML.append("<COLNAME>"+vo.getColName()+"</COLNAME>");
				resultXML.append("</HEADER>");
			}
			
			resultXML.append("</HEADERS>");
			resultXML.append("<ROWS>");
    		//}
    		
    		if (boardVO.getPageNum() != 1) {
    			startRow = ((personalCount * (boardVO.getPageNum() - 1)) - noticeCount) + 1;
    			endRow = (personalCount * boardVO.getPageNum()) - noticeCount;
    		}
    	} else {
    		startRow = ((personalCount * (boardVO.getPageNum() - 1))) + 1;
    		endRow = (personalCount * boardVO.getPageNum());
    		
    		resultXML.append("<TOTALCNT>" + boardCount + "</TOTALCNT>");
    		resultXML.append("<PAGECNT>" + boardCount + "</PAGECNT>");
    		resultXML.append("<PERSONALCNT>" + personalCount + "</PERSONALCNT>");
    		resultXML.append("<PREVIEWTYPE>" + previewtype + "</PREVIEWTYPE>");
    		resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
    		resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
    		resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
    		resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
    		resultXML.append("<WRITEDATENUM>" + writeDateSN + "</WRITEDATENUM>");
    		resultXML.append("<TITLENUM>" + titleSN + "</TITLENUM>");
    		resultXML.append("<LISTVIEWDATA>");
    		resultXML.append("<HEADERS>");
    		
    		for (BoardListHeaderVO vo:headerList) {
    			resultXML.append("<HEADER>");
    			resultXML.append("<NAME>" + vo.getName() + "</NAME>");
    			resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
    			resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
    			resultXML.append("</HEADER>");
    		}
    		
    		resultXML.append("</HEADERS>");
    		resultXML.append("<ROWS>");
    	}
    	
    	startRow = ((personalCount * (boardVO.getPageNum() - 1))) + 1;
    	endRow = (personalCount * boardVO.getPageNum());
    	
    	List<HashMap<String, Object>> boardListItem = new ArrayList<HashMap<String,Object>>();
    	
    	if (mode == null || !mode.equals("temp")) { // 승인게시물 가져올때 companyID 조건 추가
    		boardListItem = ezBoardService.getApprBoardListItem(userInfo, startRow, endRow, boardCount, orderOption1, orderOption2, orderByMap);
    	} else { // 임시보관함 게시물
    		boardListItem = ezBoardService.getMyBoardListItemTemp(userInfo, startRow, endRow, boardCount, orderOption1, orderOption2, orderByMap);
    	}
    	
    	int dlength = boardListItem.size();
    	
    	for (int j = 0; j < dlength; j++) {
    		resultXML.append("<ROW>");
    		for (i = 0; i < hlength; i++) {
    			resultXML.append("<CELL>");
    			fieldName = headerList.get(i).getColName().toUpperCase();
    			
    			if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME")) {
    				fieldName = fieldName + strMultiData;
    			}
    			
    			if (fieldName.equals("WRITEDATE")) {
    				fieldValue = commonUtil.getDateStringInUTC((String) boardListItem.get(j).get(fieldName), userInfo.getOffset(), false);
    				fieldValue = fieldValue.substring(0, fieldValue.length()-3);
    			} else {
    				fieldValue = commonUtil.cleanValue(String.valueOf(boardListItem.get(j).get(fieldName)));
    			}
    			
    			resultXML.append("<VALUE>" + fieldValue + "</VALUE>");
    			
    			if (i == 0) {
    				resultXML.append("<DATA1>" + boardListItem.get(j).get("BOARDID") + "</DATA1>");
    				resultXML.append("<DATA2>" + boardListItem.get(j).get("ITEMID") + "</DATA2>");
    				resultXML.append("<DATA3>" + boardListItem.get(j).get("WRITERID") + "</DATA3>");
    				resultXML.append("<DATA4>" + boardListItem.get(j).get("IMPORTANCE") + "</DATA4>");
    				resultXML.append("<DATA5>" + boardListItem.get(j).get("READFLAG") + "</DATA5>");
    				resultXML.append("<DATA6>" + commonUtil.cleanValue((String)boardListItem.get(j).get("ABSTRACT")) + "</DATA6>");
    				String nowDate = commonUtil.getTodayUTCTime("");
    				nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
    				
    				if (boardListItem.get(j).get("WRITEDATE").toString().compareTo(nowDate) > 0) {
    					resultXML.append("<DATA7>Y</DATA7>");
    				} else {
    					resultXML.append("<DATA7>N</DATA7>");
    				}
    				
    				resultXML.append("<DATA8>" + boardListItem.get(j).get("ITEMLEVEL") + "</DATA8>");
    				resultXML.append("<DATA9>" + boardListItem.get(j).get("NOTICE") + "</DATA9>");
    				resultXML.append("<DATA10>" + boardListItem.get(j).get("GUBUN") + "</DATA10>");
    				resultXML.append("<DATA11>" + boardListItem.get(j).get("ONELINECNT") + "</DATA11>");
    				
    				/* 2023-11-17 홍승비 - 게시물 승인 시 게시(답변)알림메일 발송 기능을 위한 파라미터 추가 */
					if (boardListItem.get(j).get("COMPANYID") == null || boardListItem.get(j).get("COMPANYID").equals("")) {
						resultXML.append("<ISALLGROUPBOARD>Y</ISALLGROUPBOARD>"); // 그룹사게시판 여부 (그룹사게시판은 회사ID 없음)
					} else {
						resultXML.append("<ISALLGROUPBOARD>N</ISALLGROUPBOARD>");
					}
					
					resultXML.append("<UPPERITEMIDTREE>" + boardListItem.get(j).get("UPPERITEMIDTREE") + "</UPPERITEMIDTREE>");
					resultXML.append("<PARENTWRITEDATE>" + boardListItem.get(j).get("PARENTWRITEDATE") + "</PARENTWRITEDATE>");
					resultXML.append("<DOCNO>" + boardListItem.get(j).get("DOCNO") + "</DOCNO>");
					resultXML.append("<PUBLICFLAG>" + boardListItem.get(j).get("PUBLICFLAG") + "</PUBLICFLAG>");
					resultXML.append("<ITEMREAD_FG>" + (accessCheck((String)boardListItem.get(j).get("BOARDID"), (String)boardListItem.get(j).get("ITEMID"),
							"GENERAL", userInfo, "") ? "Y" : "N") + "</ITEMREAD_FG>");
					resultXML.append("<EXT>" + commonUtil.cleanValue((String) boardListItem.get(j).get("EXT")) + "</EXT>");
					resultXML.append("<FILEPATH>" + commonUtil.cleanValue((String) boardListItem.get(j).get("FILEPATH")) + "</FILEPATH>");
    			}
    			
    			resultXML.append("</CELL>");
    		}
    		
    		resultXML.append("</ROW>");
    	}
    	
    	resultXML.append("</ROWS>");
    	resultXML.append("</LISTVIEWDATA>");
    	resultXML.append("</DOCLIST>");

		logger.debug("getApprboardList ended");
		
        return resultXML.toString();
	}
    
	/**
	 * 게시판 나의게시판리스트 표출 Method
	 */
    public String getMyboardList(BoardVO boardVO, LoginVO userInfo, String mode) throws Exception {
    	logger.debug("getMyboardList started");

    	String orderOption1 = "";
    	String orderOption2 = "";
    	String strMultiData = commonUtil.getMultiData(boardVO.getLang(), userInfo.getTenantId());
    	
    	List<BoardListHeaderVO> headerList = ezBoardService.getListHeader(userInfo, boardVO);
    	
    	int i = 0;
    	int hlength = headerList.size();
    	int writeDateSN = 0;
    	int titleSN = 0;
    	Map<String, String> orderByMap = new HashMap<String, String>();
    	
		for (i = 0; i < hlength; i++) {
			if (boardVO.getOrderCell() != null && !boardVO.getOrderCell().equals("") && boardVO.getOrderCell().equals(headerList.get(i).getName())) {
				orderByMap.put("orderByCol", headerList.get(i).getColName().toUpperCase());
				if (boardVO.getOrderOption().equals("")) {
					orderByMap.put("orderByColDesc", "N");
					if (headerList.get(i).getColName().equals("BOARDNAME")) {
						orderOption1 = "B." + headerList.get(i).getColName() + " ";
						orderOption2 = "B." + headerList.get(i).getColName() + " DESC ";
					} else {
						orderOption1 = "A." + headerList.get(i).getColName() + " ";
						orderOption2 = "A." + headerList.get(i).getColName() + " DESC ";
					}
				} else {
					orderByMap.put("orderByColDesc", "Y");
					if (headerList.get(i).getColName().equals("BOARDNAME")) {
						orderOption1 = "B." + headerList.get(i).getColName() + " DESC ";
						orderOption2 = "B." + headerList.get(i).getColName() + " ";
					} else {
						orderOption1 = "A." + headerList.get(i).getColName() + " DESC ";
						orderOption2 = "A." + headerList.get(i).getColName() + " ";
					}
				}
			}
		}
    	
		BoardPropertyVO scrapBoardInfo;
		ArrayList<String> scrapBoardListView_FG = new ArrayList<String>();
		ArrayList<String> scrapBoardListRead_FG = new ArrayList<String>();
		if("scrap".equals(mode) && boardVO.getScrapContID() == null){
			Map<String, ArrayList<String>> scrapBoardListReadView = getScrapBoardListReadView_FG(userInfo);
			scrapBoardListView_FG = scrapBoardListReadView.get("scrapBoardListView_FG");
			scrapBoardListRead_FG = scrapBoardListReadView.get("scrapBoardListRead_FG");
		}
		
		ArrayList<String> scrapContBoardListView_FG = new ArrayList<String>();
		ArrayList<String> scrapContBoardListRead_FG = new ArrayList<String>();
		if("scrap".equals(mode) && boardVO.getScrapContID() != null){
			Map<String, ArrayList<String>> scrapContBoardListReadView = getScrapContBoardListReadView_FG(userInfo, boardVO);
			scrapContBoardListView_FG = scrapContBoardListReadView.get("scrapContBoardListView_FG");
			scrapContBoardListRead_FG = scrapContBoardListReadView.get("scrapContBoardListRead_FG");
		}
		
    	int noticeCount = 0;
    	int boardCount = 0;
    	
    	if (mode == null || !mode.equals("temp") && !mode.equals("scrap")) { // 나의게시물 카운트 companyID 조건 추가
    		boardCount = ezBoardService.getMyBoardTotalItemCount(userInfo);
    	} else if(mode.equals("temp")) { // 임시보관함 카운트 -> companyID 조건 추가
    		boardCount = ezBoardService.getMyBoardTotalItemCountTemp(userInfo);
    	} else if(mode.equals("scrap") && boardVO.getScrapContID() != null) {
    		boardCount = ezBoardService.getUserScrapContlistCount(userInfo, boardVO.getScrapContID(), scrapContBoardListView_FG);//나의 스크랩함 item totalcount
    	} else if(mode.equals("scrap")) {
    		boardCount = ezBoardService.getMyBoardTotalItemCountScrap(userInfo, scrapBoardListView_FG);//나의 스크랩 item totalcount
    	}
    	
    	int startRow = 1;
    	int endRow = 0;
    	
    	BoardConfigVO boardConfigVO = ezBoardService.getPersonalCount(userInfo);
    	
    	int personalCount = boardConfigVO.getListCount();
    	String previewtype = boardConfigVO.getPreview();
    	String fieldName = "";
    	String fieldValue = "";
    	StringBuffer resultXML = new StringBuffer();
    	
    	resultXML.append("<DOCLIST>");
    	
    	if (mode == null || !mode.equals("temp") && !mode.equals("scrap")) {
    		noticeCount = ezBoardService.getMyNoticePostItemCount(userInfo);
    		
    		if (noticeCount > 0) {
    			int start = ((boardVO.getPageNum() - 1) * personalCount) + 1;
    			int end = (boardVO.getPageNum() * personalCount);
    			
    			List<HashMap<String, Object>> noticeList = ezBoardService.getMyNoticePostItem(userInfo, "Y", start, end);
    			
    			int k = 0;
    			int nlength = noticeList.size();
    			
    			resultXML.append("<TOTALCNT>" + boardCount + "</TOTALCNT>");
    			resultXML.append("<PAGECNT>" + (noticeCount + boardCount) + "</PAGECNT>");
    			resultXML.append("<PERSONALCNT>" + personalCount + "</PERSONALCNT>");
    			resultXML.append("<PREVIEWTYPE>" + previewtype + "</PREVIEWTYPE>");
    			resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
    			resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
    			resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
    			resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
    			resultXML.append("<WRITEDATENUM>" + writeDateSN + "</WRITEDATENUM>");
    			resultXML.append("<TITLENUM>" + titleSN + "</TITLENUM>");
    			resultXML.append("<LISTVIEWDATA>");
    			resultXML.append("<HEADERS>");
    			
    			for (BoardListHeaderVO vo:headerList) {
    				resultXML.append("<HEADER>");
    				resultXML.append("<NAME>" + vo.getName() + "</NAME>");
    				resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
    				resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
    				resultXML.append("</HEADER>");
    			}
    			
    			resultXML.append("</HEADERS>");
    			resultXML.append("<ROWS>");
    			
    			for (k=0; k < nlength; k++) {
    				resultXML.append("<ROW>");
    				for (i = 0; i < hlength; i++) {
    					resultXML.append("<CELL>");
    					fieldName = headerList.get(i).getColName().toUpperCase();
    					
    					if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME")) {
    						fieldName = fieldName + strMultiData;
    					}
    					if (fieldName.equals("WRITEDATE")) {
    						fieldValue = commonUtil.getDateStringInUTC((String) noticeList.get(k).get(fieldName), userInfo.getOffset(), false);
    						fieldValue = fieldValue.substring(0, fieldValue.length()-3);
    					} else {
    						fieldValue = commonUtil.cleanValue(String.valueOf(noticeList.get(k).get(fieldName)));
    					}
    					
    					resultXML.append("<VALUE>" + fieldValue + "</VALUE>");
    					
    					if (i == 0) {
    						resultXML.append("<DATA1>" + noticeList.get(k).get("BOARDID") + "</DATA1>");
    						resultXML.append("<DATA2>" + noticeList.get(k).get("ITEMID") + "</DATA2>");
    						resultXML.append("<DATA3>" + noticeList.get(k).get("WRITERID") + "</DATA3>");
    						resultXML.append("<DATA4>" + noticeList.get(k).get("IMPORTANCE") + "</DATA4>");
    						resultXML.append("<DATA5>" + noticeList.get(k).get("READFLAG") + "</DATA5>");
    						resultXML.append("<DATA6>" + commonUtil.cleanValue((String)noticeList.get(k).get("ABSTRACT")) + "</DATA6>");
    						String nowDate = commonUtil.getTodayUTCTime("");
    						nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
    						
    						if (noticeList.get(k).get("WRITEDATE").toString().compareTo(nowDate) > 0) {
    							resultXML.append("<DATA7>Y</DATA7>");
    						} else {
    							resultXML.append("<DATA7>N</DATA7>");
    						}
    						
    						resultXML.append("<DATA8>" + noticeList.get(k).get("ITEMLEVEL") + "</DATA8>");
    						resultXML.append("<DATA9>" + noticeList.get(k).get("NOTICE") + "</DATA9>");
    						resultXML.append("<DATA10>" + noticeList.get(k).get("GUBUN") + "</DATA10>");
    						resultXML.append("<DATA11>" + ezBoardService.getOneLineCNT(noticeList.get(k).get("ITEMID").toString(), userInfo.getTenantId()) + "</DATA11>");
                            resultXML.append("<PUBLICFLAG>").append(noticeList.get(k).get("PUBLICFLAG")).append("</PUBLICFLAG>");
    						resultXML.append("<EXT>" + commonUtil.cleanValue((String) noticeList.get(k).get("EXT")) + "</EXT>");
    						resultXML.append("<FILEPATH>" + commonUtil.cleanValue((String) noticeList.get(k).get("FILEPATH")) + "</FILEPATH>");
    					}
    					
    					resultXML.append("</CELL>");
    				}
    				
    				resultXML.append("</ROW>");
    			}
    		} else {
    			startRow = ((personalCount * (boardVO.getPageNum() - 1))) + 1;
    			endRow = (personalCount * boardVO.getPageNum());
    			
    			resultXML.append("<TOTALCNT>" + boardCount + "</TOTALCNT>");
    			resultXML.append("<PAGECNT>" + boardCount + "</PAGECNT>");
    			resultXML.append("<PERSONALCNT>" + personalCount + "</PERSONALCNT>");
    			resultXML.append("<PREVIEWTYPE>" + previewtype + "</PREVIEWTYPE>");
    			resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
    			resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
    			resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
    			resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
    			resultXML.append("<WRITEDATENUM>" + writeDateSN + "</WRITEDATENUM>");
    			resultXML.append("<TITLENUM>" + titleSN + "</TITLENUM>");
    			resultXML.append("<LISTVIEWDATA>");
    			resultXML.append("<HEADERS>");
    			
    			for (BoardListHeaderVO vo:headerList) {
    				resultXML.append("<HEADER>");
    				resultXML.append("<NAME>" + vo.getName() + "</NAME>");
    				resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
    				resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
    				resultXML.append("</HEADER>");
    			}
    			
    			resultXML.append("</HEADERS>");
    			resultXML.append("<ROWS>");
    		}
    		
    		if (boardVO.getPageNum() != 1) {
    			startRow = ((personalCount * (boardVO.getPageNum() - 1)) - noticeCount)  +  1;
    			endRow = (personalCount * boardVO.getPageNum()) - noticeCount;
    			
    			if (startRow <= 0) {
    				startRow = 1;
    			}
    			
    			if (endRow < 0) {
    				endRow = 0;
    			}
    		} else {
    			startRow = ((personalCount * (boardVO.getPageNum() - 1))) + 1;
    			endRow = (personalCount * boardVO.getPageNum()) - noticeCount;
    			
    			if (endRow < 0) {
    				endRow = 0;
    			}
    		}
    	} else if(mode.equals("temp")) { // 임시저장 게시물의 경우
    		startRow = ((personalCount * (boardVO.getPageNum() - 1)))  +  1;
    		endRow = (personalCount * boardVO.getPageNum());
    		
    		resultXML.append("<TOTALCNT>" + boardCount + "</TOTALCNT>");
    		resultXML.append("<PAGECNT>" + (noticeCount + boardCount) + "</PAGECNT>");
    		resultXML.append("<PERSONALCNT>" + personalCount + "</PERSONALCNT>");
    		resultXML.append("<PREVIEWTYPE>" + previewtype + "</PREVIEWTYPE>");
    		resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
    		resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
    		resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
    		resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
    		resultXML.append("<WRITEDATENUM>" + writeDateSN + "</WRITEDATENUM>");
    		resultXML.append("<TITLENUM>" + titleSN + "</TITLENUM>");
    		resultXML.append("<LISTVIEWDATA>");
    		resultXML.append("<HEADERS>");
    		
    		for (BoardListHeaderVO vo:headerList) {
    			resultXML.append("<HEADER>");
    			resultXML.append("<NAME>" + vo.getName() + "</NAME>");
    			resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
    			resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
    			resultXML.append("</HEADER>");
    		}
    		
    		resultXML.append("</HEADERS>");
    		resultXML.append("<ROWS>");
    	} else if(mode.equals("scrap")){ // 스크랩 게시물의 경우
			
			startRow = ((personalCount * (boardVO.getPageNum() - 1))) + 1;
			endRow = (personalCount * boardVO.getPageNum());
			
			resultXML.append("<TOTALCNT>" + boardCount + "</TOTALCNT>"); 
			resultXML.append("<PAGECNT>" + boardCount + "</PAGECNT>"); 
			resultXML.append("<PERSONALCNT>" + personalCount + "</PERSONALCNT>"); 
			resultXML.append("<PREVIEWTYPE>" + previewtype + "</PREVIEWTYPE>"); 
			resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
			resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
			resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
			resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
			resultXML.append("<WRITEDATENUM>" + writeDateSN + "</WRITEDATENUM>");
			resultXML.append("<TITLENUM>" + titleSN + "</TITLENUM>");
			resultXML.append("<LISTVIEWDATA>");
			resultXML.append("<HEADERS>");
			
			for (BoardListHeaderVO vo:headerList) {
				resultXML.append("<HEADER>");
				resultXML.append("<NAME>" + vo.getName() + "</NAME>");
				resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
				resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
				resultXML.append("</HEADER>");
			}
			
			resultXML.append("</HEADERS>");
			resultXML.append("<ROWS>");
		
		if (boardVO.getPageNum() != 1) {
			startRow = ((personalCount * (boardVO.getPageNum() - 1))) + 1;
			endRow = personalCount * boardVO.getPageNum();
			
			if (startRow <= 0) {
				startRow = 1;
			}
			
			if (endRow < 0) {
				endRow = 0;
			}
		} else {
			startRow = ((personalCount * (boardVO.getPageNum() - 1))) + 1;
			endRow = personalCount * boardVO.getPageNum();

			if (endRow < 0) {
				endRow = 0;
			}
		}
	}
    	
    	List<HashMap<String, Object>> boardListItem = new ArrayList<HashMap<String,Object>>();
    	
    	if (mode == null || !mode.equals("temp") && !mode.equals("scrap")) { // 나의게시물 표출 시 companyID 조건추가
    		boardListItem = ezBoardService.getMyBoardListItem(userInfo, startRow, endRow, boardCount, orderOption1, orderOption2, orderByMap);
    	} else if(mode.equals("temp")) { // 임시저장 게시물 표출 시 companyID 조건 추가
    		boardListItem = ezBoardService.getMyBoardListItemTemp(userInfo, startRow, endRow, boardCount, orderOption1, orderOption2, orderByMap);
    	} else if (mode.equals("scrap") && boardVO.getScrapContID() != null) {
			boardListItem = ezBoardService.getScrapContItemList(userInfo, startRow, endRow, boardCount, orderOption1, orderOption2, boardVO.getScrapContID(), scrapContBoardListView_FG, orderByMap);
    	} else if (mode.equals("scrap")) {
			boardListItem = ezBoardService.getMyBoardListItemScrap(userInfo, startRow, endRow, boardCount, orderOption1, orderOption2, scrapBoardListView_FG, orderByMap);
    	}
    	
    	int dlength = boardListItem.size();
    	
    	for (int j = 0; j < dlength; j++) {
    		resultXML.append("<ROW>");
    		for (i = 0; i < hlength; i++) {
    			resultXML.append("<CELL>");
    			fieldName = headerList.get(i).getColName().toUpperCase();
    			
    			if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME")) {
    				fieldName = fieldName + strMultiData;
    			}
    			
    			if (fieldName.equals("WRITEDATE")) {
    				fieldValue = commonUtil.getDateStringInUTC((String) boardListItem.get(j).get(fieldName), userInfo.getOffset(), false);
    				fieldValue = fieldValue.substring(0, fieldValue.length() - 3);
    			} else {
    				fieldValue = commonUtil.cleanValue(String.valueOf(boardListItem.get(j).get(fieldName)));
    			}
    			
    			resultXML.append("<VALUE>" + fieldValue + "</VALUE>");
    			
    			if (i == 0) {
    				resultXML.append("<DATA1>" + boardListItem.get(j).get("BOARDID") + "</DATA1>");
    				resultXML.append("<DATA2>" + boardListItem.get(j).get("ITEMID") + "</DATA2>");
    				resultXML.append("<DATA3>" + boardListItem.get(j).get("WRITERID") + "</DATA3>");
    				resultXML.append("<DATA4>" + boardListItem.get(j).get("IMPORTANCE") + "</DATA4>");
    				resultXML.append("<DATA5>" + boardListItem.get(j).get("READFLAG") + "</DATA5>");
    				resultXML.append("<DATA6>" + commonUtil.cleanValue((String)boardListItem.get(j).get("ABSTRACT")) + "</DATA6>");
    				String nowDate = commonUtil.getTodayUTCTime("");
    				nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
    				
    				if (boardListItem.get(j).get("WRITEDATE").toString().compareTo(nowDate) > 0) {
    					resultXML.append("<DATA7>Y</DATA7>");
    				} else {
    					resultXML.append("<DATA7>N</DATA7>");
    				}
    				
    				resultXML.append("<DATA8>" + boardListItem.get(j).get("ITEMLEVEL") + "</DATA8>");
    				resultXML.append("<DATA9>" + boardListItem.get(j).get("NOTICE") + "</DATA9>");
    				resultXML.append("<DATA10>" + boardListItem.get(j).get("GUBUN") + "</DATA10>");
    				resultXML.append("<DATA11>" + boardListItem.get(j).get("ONELINECNT") + "</DATA11>");
    				resultXML.append("<DATA12>" + boardListItem.get(j).get("ATTRIBUTEYN") + "</DATA12>");
                    resultXML.append("<PUBLICFLAG>").append(boardListItem.get(j).get("PUBLICFLAG")).append("</PUBLICFLAG>");
    				resultXML.append("<EXT>" + commonUtil.cleanValue((String) boardListItem.get(j).get("EXT")) + "</EXT>");
    				resultXML.append("<FILEPATH>" + commonUtil.cleanValue((String) boardListItem.get(j).get("FILEPATH")) + "</FILEPATH>");

					if("scrap".equals(mode) && boardVO.getScrapContID() == null) {
						if (scrapBoardListRead_FG.contains(boardListItem.get(j).get("BOARDID"))) {
							resultXML.append("<DATA13>" + "Y" + "</DATA13>");
						} else {
							resultXML.append("<DATA13>" + "N" + "</DATA13>");
						}
					}
					
					if("scrap".equals(mode) && boardVO.getScrapContID() != null){
						if (scrapContBoardListRead_FG.contains(boardListItem.get(j).get("BOARDID"))) {
							resultXML.append("<DATA13>" + "Y" + "</DATA13>");
						} else {
							resultXML.append("<DATA13>" + "N" + "</DATA13>");
						}
					}
					resultXML.append("<ITEMREAD_FG>" + (accessCheck((String)boardListItem.get(j).get("BOARDID"), (String)boardListItem.get(j).get("ITEMID"),
							"GENERAL", userInfo, "") ? "Y" : "N") + "</ITEMREAD_FG>");
					resultXML.append("<PUBLICFLAG>").append(boardListItem.get(j).get("PUBLICFLAG")).append("</PUBLICFLAG>");	
    			}
    			
    			resultXML.append("</CELL>");
    		}
    		
    		resultXML.append("</ROW>");
    	}
    	
    	resultXML.append("</ROWS>");
    	resultXML.append("</LISTVIEWDATA>");
    	resultXML.append("</DOCLIST>");

		logger.debug("getMyboardList ended");
        return resultXML.toString();
	}

    /**
	 * 게시판 Q&A게시판리스트 표출 Method
	 */
	public String getQnAListItem(BoardVO boardVO, LoginVO userInfo, String type, String adminType) throws Exception {
		logger.debug("getQnAListItem started");

		String orderOption1 = "";
		String orderOption2 = "";
		String strMultiData = commonUtil.getMultiData(boardVO.getLang(), userInfo.getTenantId());
		String primaryData = commonUtil.getPrimaryData(boardVO.getLang(), userInfo.getTenantId());
		
		List<BoardListHeaderVO> headerList = ezBoardService.getListHeaderBoardID(userInfo, boardVO);
		
		int i = 0;
		int hlength = headerList.size();
		int writeDateSN = 0;    //작성일 순번
		int titleSN = 0;            //제목 순번
		Map<String, String> orderByMap = new HashMap<String, String>();
		
		for (i = 0; i < hlength; i++) {
			if (boardVO.getOrderCell() != null && !boardVO.getOrderCell().equals("") && boardVO.getOrderCell().equals(headerList.get(i).getName())) {
				orderByMap.put("orderByCol", headerList.get(i).getColName().toUpperCase());
				if (boardVO.getOrderOption().equals("")) {
					orderByMap.put("orderByColDesc", "N");
					orderOption1 = headerList.get(i).getColName() + " ";
					orderOption2 = headerList.get(i).getColName() + " DESC ";
				} else {
					orderByMap.put("orderByColDesc", "Y");
					orderOption1 = headerList.get(i).getColName() + " DESC ";
					orderOption2 = headerList.get(i).getColName() + " ";
				}
			}

			if ("WRITEDATE".equals(headerList.get(i).getColName().toUpperCase())) {
				writeDateSN = i;
			}
			if ("TITLE".equals(headerList.get(i).getColName().toUpperCase())) {
				titleSN = i;
			}
		}
		
		int noticeCount = 0;
		
		if (type.equals("1")) {
			boardVO.setNowDate(commonUtil.getTodayUTCTime(""));
			noticeCount = ezBoardService.getNoticePostItemCount(boardVO);
		}
		
		BoardMyFavoriteVO boardMyFavoriteVO = new BoardMyFavoriteVO();
		
		boardMyFavoriteVO.setBoardId(boardVO.getBoardId());
		boardMyFavoriteVO.setUserId(userInfo.getId());
		boardMyFavoriteVO.setType(type);
		boardMyFavoriteVO.setBoardAdmin_FG(adminType);
		boardMyFavoriteVO.setTenantID(userInfo.getTenantId());
		boardMyFavoriteVO.setNowDate(commonUtil.getTodayUTCTime(""));
		
		int boardCount = ezBoardService.getQNABrdTotalItemCount(boardMyFavoriteVO);
		
		int startRow = 1;
		int endRow = 0;
		
		BoardConfigVO boardConfigVO = ezBoardService.getPersonalCount(userInfo);
		
		int personalCount = boardConfigVO.getListCount();
		String previewtype = boardConfigVO.getPreview();
		String fieldName = "";
		String fieldValue = "";
		
		StringBuffer resultXML = new StringBuffer();
		
		resultXML.append("<DOCLIST>");
		
		if (noticeCount > 0 && type.equals("1")) {
			endRow = (personalCount * boardVO.getPageNum()) - noticeCount;
			
			List<HashMap<String, Object>> noticeList = ezBoardService.getNoticePostItem(boardVO, personalCount);
			
			int k = 0;
			int nlength = noticeList.size();
			
			resultXML.append("<TOTALCNT>" + boardCount + "</TOTALCNT>");
			resultXML.append("<PAGECNT>" + ((int)noticeCount  +  (int)boardCount) + "</PAGECNT>");
			resultXML.append("<PERSONALCNT>" + personalCount + "</PERSONALCNT>");
			resultXML.append("<PREVIEWTYPE>" + previewtype + "</PREVIEWTYPE>");
			resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
			resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
			resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
			resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
			resultXML.append("<WRITEDATENUM>" + writeDateSN + "</WRITEDATENUM>");
			resultXML.append("<TITLENUM>" + titleSN + "</TITLENUM>");
			resultXML.append("<LISTVIEWDATA>");
			resultXML.append("<HEADERS>");
			
			for (BoardListHeaderVO vo:headerList) {
				resultXML.append("<HEADER>");
				resultXML.append("<NAME>" + vo.getName() + "</NAME>");
				resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
				resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
				resultXML.append("</HEADER>");
			}
			
			resultXML.append("</HEADERS>");
			resultXML.append("<ROWS>");
			
			for (k=0; k < nlength; k++) {
				resultXML.append("<ROW>");
				for (i = 0; i < hlength; i++) {
					resultXML.append("<CELL>");
					fieldName = headerList.get(i).getColName().toUpperCase();
					
					if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME") || fieldName.equals("WRITERCOMPANYNAME")) {
						fieldName = fieldName + strMultiData;
					}
					
					if (fieldName.equals("WRITEDATE")) {
						fieldValue = commonUtil.getDateStringInUTC((String) noticeList.get(k).get(fieldName), userInfo.getOffset(), false);
						fieldValue = fieldValue.substring(0, fieldValue.length()-3);
					} else {
						fieldValue = commonUtil.cleanValue(String.valueOf(noticeList.get(k).get(fieldName)));
					}
					
					resultXML.append("<VALUE>" + fieldValue + "</VALUE>");
					
					if (i == 0) {
						resultXML.append("<DATA1>" + noticeList.get(k).get("BOARDID") + "</DATA1>");
						resultXML.append("<DATA2>" + noticeList.get(k).get("ITEMID") + "</DATA2>");
						resultXML.append("<DATA3>" + noticeList.get(k).get("WRITERID") + "</DATA3>");
						resultXML.append("<DATA4>" + noticeList.get(k).get("IMPORTANCE") + "</DATA4>");
						resultXML.append("<DATA5>" + noticeList.get(k).get("READFLAG") + "</DATA5>");
						resultXML.append("<DATA6>" + commonUtil.cleanValue((String)noticeList.get(k).get("ABSTRACT")) + "</DATA6>");
						
						String nowDate = commonUtil.getTodayUTCTime("");
						nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
						
						if (noticeList.get(k).get("WRITEDATE").toString().compareTo(nowDate) > 0) {
							resultXML.append("<DATA7>Y</DATA7>");
						} else {
							resultXML.append("<DATA7>N</DATA7>");
						}
						
						resultXML.append("<DATA8>" + noticeList.get(k).get("ITEMLEVEL") + "</DATA8>");
						resultXML.append("<DATA9>" + noticeList.get(k).get("NOTICE") + "</DATA9>");
						resultXML.append("<DATA10></DATA10>");
						resultXML.append("<DATA11>" + ezBoardService.getOneLineCNT(noticeList.get(k).get("ITEMID").toString(), userInfo.getTenantId()) + "</DATA11>");
						resultXML.append("<TITLE>" +  commonUtil.cleanValue((String)noticeList.get(k).get("TITLE"))  + "</TITLE>");
						
						if (primaryData.equals("1")) {
							resultXML.append("<WRITERNAME>" + commonUtil.cleanValue((String)noticeList.get(k).get("WRITERNAME")) + "</WRITERNAME>");
							resultXML.append("<WRITERDEPTNAME>" + commonUtil.cleanValue((String)noticeList.get(k).get("WRITERDEPTNAME")) + "</WRITERDEPTNAME>");
						} else {
							resultXML.append("<WRITERNAME>" + commonUtil.cleanValue((String)noticeList.get(k).get("WRITERNAME2")) + "</WRITERNAME>");
							resultXML.append("<WRITERDEPTNAME>" + commonUtil.cleanValue((String)noticeList.get(k).get("WRITERDEPTNAME2")) + "</WRITERDEPTNAME>");
						}
						
						resultXML.append("<WRITEDATE>" + noticeList.get(k).get("WRITEDATE") + "</WRITEDATE>");
						resultXML.append("<ATTACHMENTS>" + noticeList.get(k).get("ATTACHMENTS") + "</ATTACHMENTS>");
						resultXML.append("<EXT>" + commonUtil.cleanValue((String) noticeList.get(k).get("EXT")) + "</EXT>");
						resultXML.append("<FILEPATH>" + commonUtil.cleanValue((String) noticeList.get(k).get("FILEPATH")) + "</FILEPATH>");
                        resultXML.append("<PUBLICFLAG>").append(noticeList.get(k).get("PUBLICFLAG")).append("</PUBLICFLAG>");
						resultXML.append("<ITEMREAD_FG>" + (accessCheck((String)noticeList.get(k).get("BOARDID"), (String)noticeList.get(k).get("ITEMID"),
								"GENERAL", userInfo, "") ? "Y" : "N") + "</ITEMREAD_FG>");
					}
					
					resultXML.append("</CELL>");
				}
				
				resultXML.append("</ROW>");
			}
		} else {
			startRow = ((personalCount * (boardVO.getPageNum() - 1))) + 1;
			endRow = (personalCount * boardVO.getPageNum());
			
			resultXML.append("<TOTALCNT>" + boardCount + "</TOTALCNT>");
			resultXML.append("<PAGECNT>" + boardCount + "</PAGECNT>");
			resultXML.append("<PERSONALCNT>" + personalCount + "</PERSONALCNT>");
			resultXML.append("<PREVIEWTYPE>" + previewtype + "</PREVIEWTYPE>");
			resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
			resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
			resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
			resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
			resultXML.append("<WRITEDATENUM>" + writeDateSN + "</WRITEDATENUM>");
			resultXML.append("<TITLENUM>" + titleSN + "</TITLENUM>");
			resultXML.append("<LISTVIEWDATA>");
			resultXML.append("<HEADERS>");
			
			for (BoardListHeaderVO vo:headerList) {
				resultXML.append("<HEADER>");
				resultXML.append("<NAME>" + vo.getName() + "</NAME>");
				resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
				resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
				resultXML.append("</HEADER>");
			}
			
			resultXML.append("</HEADERS>");
			resultXML.append("<ROWS>");
		}
		
		if (boardVO.getPageNum() != 1) {
			startRow = ((personalCount * (boardVO.getPageNum() - 1)) - noticeCount) + 1;
			endRow = (personalCount * boardVO.getPageNum()) - noticeCount;
		}
		
		List<HashMap<String, Object>> boardListItem = ezBoardService.getQnABoardListItem(boardVO.getBoardId(), userInfo.getId(), startRow, endRow, boardCount, orderOption1, orderOption2, orderByMap, type, adminType, userInfo.getTenantId());
		
		int dlength = boardListItem.size();
		
		for (int j = 0; j < dlength; j++) {
			resultXML.append("<ROW>");
			for (i = 0; i < hlength; i++) {
				resultXML.append("<CELL>");
				fieldName = headerList.get(i).getColName().toUpperCase();
				
				if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME") || fieldName.equals("WRITERCOMPANYNAME")) {
					fieldName = fieldName + strMultiData;
				}
				
				if (fieldName.equals("WRITEDATE")) {
					fieldValue = commonUtil.getDateStringInUTC((String) boardListItem.get(j).get(fieldName), userInfo.getOffset(), false);
					fieldValue = fieldValue.substring(0, fieldValue.length()-3);
				} else {
					fieldValue = commonUtil.cleanValue(String.valueOf(boardListItem.get(j).get(fieldName)));
				}
				
				resultXML.append("<VALUE>" + fieldValue + "</VALUE>");
				
				if (i == 0) {
					resultXML.append("<DATA1>" + boardListItem.get(j).get("BOARDID") + "</DATA1>");
					resultXML.append("<DATA2>" + boardListItem.get(j).get("ITEMID") + "</DATA2>");
					resultXML.append("<DATA3>" + boardListItem.get(j).get("WRITERID") + "</DATA3>");
					resultXML.append("<DATA4>" + boardListItem.get(j).get("IMPORTANCE") + "</DATA4>");
					resultXML.append("<DATA5>" + boardListItem.get(j).get("READFLAG") + "</DATA5>");
					resultXML.append("<DATA6>" + commonUtil.cleanValue((String)boardListItem.get(j).get("ABSTRACT")) + "</DATA6>");
					
					String nowDate = commonUtil.getTodayUTCTime("");
					nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
					
					if (boardListItem.get(j).get("WRITEDATE").toString().compareTo(nowDate) > 0) {
						resultXML.append("<DATA7>Y</DATA7>");
					} else {
						resultXML.append("<DATA7>N</DATA7>");
					}
					
					resultXML.append("<DATA8>" + boardListItem.get(j).get("ITEMLEVEL") + "</DATA8>");
					resultXML.append("<DATA9>" + boardListItem.get(j).get("NOTICE") + "</DATA9>");
					resultXML.append("<DATA10></DATA10>");
//					resultXML.append("<DATA11>" + boardListItem.get(j).get("ONELINECNT") + "</DATA11>");
					resultXML.append("<DATA11>" + ezBoardService.getOneLineCNT(boardListItem.get(j).get("ITEMID").toString(), userInfo.getTenantId()) + "</DATA11>");
					resultXML.append("<TITLE>" + commonUtil.cleanValue((String)boardListItem.get(j).get("TITLE")) + "</TITLE>");
					resultXML.append("<WRITERNAME>" + commonUtil.cleanValue((String)boardListItem.get(j).get("WRITERNAME")) + "</WRITERNAME>");
					resultXML.append("<WRITERNAME2>" + commonUtil.cleanValue((String)boardListItem.get(j).get("WRITERNAME2")) + "</WRITERNAME2>");
					resultXML.append("<WRITERDEPTNAME>" + commonUtil.cleanValue((String)boardListItem.get(j).get("WRITERDEPTNAME")) + "</WRITERDEPTNAME>");
					resultXML.append("<WRITERDEPTNAME2>" + commonUtil.cleanValue((String)boardListItem.get(j).get("WRITERDEPTNAME2")) + "</WRITERDEPTNAME2>");
					resultXML.append("<WRITEDATE>" + boardListItem.get(j).get("WRITEDATE") + "</WRITEDATE>");
					resultXML.append("<ATTACHMENTS>" + boardListItem.get(j).get("ATTACHMENTS") + "</ATTACHMENTS>");
                    resultXML.append("<PUBLICFLAG>").append(boardListItem.get(j).get("PUBLICFLAG")).append("</PUBLICFLAG>");
					resultXML.append("<EXT>" + commonUtil.cleanValue((String) boardListItem.get(j).get("EXT")) + "</EXT>");
					resultXML.append("<FILEPATH>" + commonUtil.cleanValue((String) boardListItem.get(j).get("FILEPATH")) + "</FILEPATH>");
				}
				
				resultXML.append("</CELL>");
			}
			
			resultXML.append("</ROW>");
		}
		
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		resultXML.append("</DOCLIST>");

		logger.debug("getQnAListItem ended");
        return resultXML.toString();
	}

	/**
	 * 게시판 섬네일게시판리스트 표출 Method
	 */
	public String getThumbList(BoardVO boardVO, LoginVO userInfo, String type) throws Exception {
		logger.debug("getThumbList started");

		String orderOption1 = "";
		String strMultiData = commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId());
		
		List<BoardListHeaderVO> headerList = ezBoardService.getListHeader(userInfo, boardVO);
		
		int i = 0;
		int hlength = headerList.size();
		Map<String, String> orderByMap = new HashMap<String, String>();
		
		for (i = 0; i < hlength; i++) {
			if (headerList.get(i).getColName().equalsIgnoreCase("ATTACHMENTS")) {
				continue;
			}

			if (boardVO.getOrderCell() != null && !boardVO.getOrderCell().equals("") && boardVO.getOrderCell().equals(headerList.get(i).getName())) {
				orderByMap.put("orderByCol", headerList.get(i).getColName().toUpperCase());
				if (boardVO.getOrderOption().equals("")) {
					orderByMap.put("orderByColDesc", "N");
					if (headerList.get(i).getColName().indexOf("WRITEDATE") > -1) {
						orderOption1 = headerList.get(i).getColName().replace("WRITEDATE", "A.WRITEDATE") + " ";
					} else if (headerList.get(i).getColName().indexOf("WRITERNAME") > -1) {
						orderOption1 = headerList.get(i).getColName().replace("WRITERNAME", "A.WRITERNAME") + " ";
					} else {
						orderOption1 = headerList.get(i).getColName()+ " ";
					}
				} else {
					orderByMap.put("orderByColDesc", "Y");
					if (headerList.get(i).getColName().indexOf("WRITEDATE") > -1) {
						orderOption1 = headerList.get(i).getColName().replace("WRITEDATE", "A.WRITEDATE") + " DESC";
					} else if (headerList.get(i).getColName().indexOf("WRITERNAME") > -1) {
						orderOption1 = headerList.get(i).getColName().replace("WRITERNAME", "A.WRITERNAME") + " DESC";
					} else {
						orderOption1 = headerList.get(i).getColName()+ " DESC";
					}
				}
			}
		}
		
		BoardMyFavoriteVO myFavoriteVO = new BoardMyFavoriteVO();

		myFavoriteVO.setBoardId(boardVO.getBoardId());
		/* 2018-05-03 홍승비 - 썸네일게시판 표출 시 사용자 테넌트 id 설정 추가 */
		myFavoriteVO.setTenantID(userInfo.getTenantId());
		myFavoriteVO.setUserId(userInfo.getId());
		myFavoriteVO.setType(type);
		myFavoriteVO.setNowDate(commonUtil.getTodayUTCTime(""));
		
		int boardCount = ezBoardService.getThumbNailCount(myFavoriteVO);
		
		BoardListVO boardListVO = new BoardListVO();
		
		boardListVO.setPageCount(boardCount);
		boardListVO.setTotalCount(boardCount);
		boardListVO.setStartRow(1);
		boardListVO.setEndRow(0);
		boardListVO.setOrderBySub(orderOption1);
		boardListVO.setUserID(userInfo.getId());
		
		BoardConfigVO boardConfigVO = ezBoardService.getPersonalCount(userInfo);
		
		boardListVO.setStartRow(boardConfigVO.getListCount() * (boardVO.getPageNum() - 1) + 1);
		boardListVO.setEndRow(boardConfigVO.getListCount() * boardVO.getPageNum());
		
		if (boardVO.getTitle() == null) {
			boardVO.setTitle("");
		}
		
		if (boardVO.getABSTRACT() == null) {
			boardVO.setABSTRACT("");
		}
		
		if (boardVO.getWriterName() == null) {
			boardVO.setWriterName("");
		}
		
		List<HashMap<String, Object>> boardThumbnailList = ezBoardService.getThumbnailList(boardListVO, boardVO, orderByMap);
		
		int dlength = boardThumbnailList.size();
		StringBuffer resultXML = new StringBuffer();
		
		resultXML.append("<DOCLIST>");
		resultXML.append("<TOTALCNT>" + boardListVO.getTotalCount() + "</TOTALCNT>");
		resultXML.append("<PAGECNT>" + boardListVO.getPageCount() + "</PAGECNT>");
		resultXML.append("<PERSONALCNT>" + boardConfigVO.getListCount() + "</PERSONALCNT>");
		resultXML.append("<PREVIEWTYPE>" + boardConfigVO.getPreview() + "</PREVIEWTYPE>");
		resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
		resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
		resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
		resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (BoardListHeaderVO vo:headerList) {
			if (vo.getColName().equalsIgnoreCase("ATTACHMENTS")) {
				continue;
			}
			
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + vo.getName() + "</NAME>");
			resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
			resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
			resultXML.append("</HEADER>");
		}
		
		resultXML.append("</HEADERS>");
		resultXML.append("<ROWS>");
		
		String fieldName = "";
		String fieldValue = "";
		
		for (int j = 0; j < dlength; j++) {
			resultXML.append("<ROW>");
			for (i = 0; i < hlength; i++) {
				if (headerList.get(i).getColName().equalsIgnoreCase("ATTACHMENTS")) {
					continue;
				}
				
				resultXML.append("<CELL>");
				fieldName = headerList.get(i).getColName().toUpperCase();
				
				if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME") || fieldName.equals("WRITERCOMPANYNAME")) {
					fieldName = fieldName + strMultiData;
				}
				if (fieldName.equals("WRITEDATE")) {
					fieldValue = commonUtil.getDateStringInUTC((String)boardThumbnailList.get(j).get(fieldName), userInfo.getOffset(), false);
					fieldValue = fieldValue.substring(0, fieldValue.length()-3);
				} else {
					fieldValue = commonUtil.cleanValue(String.valueOf(boardThumbnailList.get(j).get(fieldName)));
				}
				
				resultXML.append("<VALUE>" + fieldValue + "</VALUE>");
				
				if (i == 0) {
					resultXML.append("<DATA1>" + boardThumbnailList.get(j).get("BOARDID") + "</DATA1>");
					resultXML.append("<DATA2>" + boardThumbnailList.get(j).get("ITEMID") + "</DATA2>");
					resultXML.append("<DATA3>" + boardThumbnailList.get(j).get("WRITERID") + "</DATA3>");
					String nowDate = commonUtil.getTodayUTCTime("");
					nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
					
					if (boardThumbnailList.get(j).get("WRITEDATE").toString().compareTo(nowDate) > 0) {
						resultXML.append("<DATA4>Y</DATA4>");
					} else {
						resultXML.append("<DATA4>N</DATA4>");
					}
					resultXML.append("<DATA5>" + boardThumbnailList.get(j).get("FILEPATH") + "</DATA5>");
					
					if (globals.getProperty("Globals.DbType").equals("oracle")) {
						resultXML.append("<DATA6>" + commonUtil.cleanValue((String)boardThumbnailList.get(j).get("TO_CHAR(MAINCONTENT)")) + "</DATA6>");
					} else if (globals.getProperty("Globals.DbType").equals("tibero")) {
						resultXML.append("<DATA6>" + commonUtil.cleanValue((String)boardThumbnailList.get(j).get("TO_CHAR(MAINCONTENT)")) + "</DATA6>");
					} else {
						resultXML.append("<DATA6>" + commonUtil.cleanValue((String)boardThumbnailList.get(j).get("MAINCONTENT")) + "</DATA6>");
					}
					
					resultXML.append("<DATA7>" + boardThumbnailList.get(j).get("ONELINECNT") + "</DATA7>");
					resultXML.append("<DATA8>" + boardThumbnailList.get(j).get("READFLAG") + "</DATA8>");
					resultXML.append("<DATA9>" + boardThumbnailList.get(j).get("ADDTHUMBNAIL") + "</DATA9>");
					resultXML.append("<DATA10>" + boardThumbnailList.get(j).get("THUMBNAILEXT") + "</DATA10>");
					/* 2019-04-09 홍승비 - 썸네일게시물 데이터에 제목 추가 */
					resultXML.append("<TITLE>" + commonUtil.cleanValue((String)boardThumbnailList.get(j).get("TITLE")) + "</TITLE>");
					resultXML.append("<PUBLICFLAG>").append(boardThumbnailList.get(j).get("PUBLICFLAG")).append("</PUBLICFLAG>");
					resultXML.append("<ITEMREAD_FG>" + (accessCheck((String)boardThumbnailList.get(j).get("BOARDID"), (String)boardThumbnailList.get(j).get("ITEMID"), 
									"GENERAL", userInfo, "") ? "Y" : "N") + "</ITEMREAD_FG>");
					resultXML.append("<WRITERDEPTID>" + boardThumbnailList.get(j).get("WRITERDEPTID") + "</WRITERDEPTID>");
					resultXML.append("<WRITERNAMETYPE>" + boardThumbnailList.get(j).get("WRITERNAMETYPE") + "</WRITERNAMETYPE>");
				}
				
				resultXML.append("</CELL>");
			}
			
			resultXML.append("</ROW>");
		}
		
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		resultXML.append("</DOCLIST>");

		logger.debug("getThumbList ended");
		return resultXML.toString();
	}

	/**
	 * 게시판 게시판검색리스트 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/getSearchBoardList.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
    @ResponseBody
    public String getSearchBoardList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, BoardVO boardVO) throws Exception {
		logger.debug("getSearchBoardList started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String mode = boardVO.getMode();
		BoardPropertyVO boardInfo = getBoardInfo(boardVO.getBoardId(), userInfo);
		
		boardVO.setSubFlag("N");
		
		Document searchQueryDoc = commonUtil.convertStringToDocument(boardVO.getSearchQuery());
		
		if (boardVO.getSearchQuery().indexOf("SEARCHSUBBOARD;") != -1) {
			boardVO.setSubFlag("Y");
		}

		if (boardVO.getSearchQuery().indexOf("SEARCHSUBSUBBOARD;") != -1) {
			boardVO.setSubFlag("YY");
		}
		
		if (boardVO.getSearchQuery().indexOf("SEARCHGROBOARD;") != -1) {
			boardVO.setSubFlag("G");
		}
		
		if (boardVO.getSearchQuery().indexOf("SEARCHALLBOARD;") != -1) {
			boardVO.setSubFlag("A");
		}
		
		// 20240219 : 김진홍 : CSAP 인증 처리 : 기존 SearchQuery 내용 제거 후 별도의 SearchMap 부여
		Map<String, String> searchMap = new HashMap<String, String>();

		if (boardVO.getSearchQuery().indexOf("TITLE;") != -1) {
			boardVO.setTitle(searchQueryDoc.getElementsByTagName("TITLE").item(0).getTextContent());
			searchMap.put("v_SEARCH_TITLE", boardVO.getTitle());
		}
		
		if (boardVO.getSearchQuery().indexOf("CONTENT;") != -1) {
			boardVO.setContent(searchQueryDoc.getElementsByTagName("CONTENT").item(0).getTextContent());
			searchMap.put("v_SEARCH_CONTENT", boardVO.getContent());
		}
		
		if (boardVO.getSearchQuery().indexOf("WRITERNAME;") != -1) {
			boardVO.setWriterName(searchQueryDoc.getElementsByTagName("WRITERNAME").item(0).getTextContent());
			searchMap.put("v_SEARCH_WRITERNAME", boardVO.getWriterName());
		}
		
		/* 2018-06-22 홍승비 - 썸네일게시판 쿼리 Writedate 중복 문제 수정(TBL_BOARD_ITEM as A) */
		if (boardVO.getSearchQuery().indexOf("STARTDATE;") != -1) {
			searchMap.put("v_SEARCH_STARTDATE", commonUtil.getDateStringInUTC(searchQueryDoc.getElementsByTagName("STARTDATE").item(0).getTextContent() + " 00:00:00", userInfo.getOffset(), true));
		}
		
		if (boardVO.getSearchQuery().indexOf("ENDDATE;") != -1) {
			searchMap.put("v_SEARCH_ENDDATE", commonUtil.getDateStringInUTC(searchQueryDoc.getElementsByTagName("ENDDATE").item(0).getTextContent() + " 23:59:59", userInfo.getOffset(), true));
		}
		
		if (boardVO.getSearchQuery().indexOf("ABSTRACT;") != -1) {
			boardVO.setABSTRACT(searchQueryDoc.getElementsByTagName("ABSTRACT").item(0).getTextContent());
			searchMap.put("v_SEARCH_ABSTRACT", boardVO.getABSTRACT());
		}
		
		if (boardVO.getSearchQuery().indexOf("TNC;") != -1) {
			boardVO.setTitleAndCont(searchQueryDoc.getElementsByTagName("TNC").item(0).getTextContent());
			searchMap.put("v_SEARCH_TITLE_AND_CONTENT", boardVO.getTitleAndCont());
		}
		
		String keywordClick = "";
		// 2024-08-26 전인하 - 게시판 > 검색 > 키워드 값 세팅
		if (boardInfo.getUseKeyword() != null && boardInfo.getUseKeyword().equals("Y")) {
			boardVO.setUseKeyword("Y");
			if (boardVO.getSearchQuery().indexOf("KEYWORD;") != -1) {
				String keyword = commonUtil.cleanValueUnescape(searchQueryDoc.getElementsByTagName("KEYWORD").item(0).getTextContent());
				boardVO.setKeyword(keyword);
			}
		} else if (boardVO.getBoardType().equals("M") || boardVO.getBoardType().equals("A") 
				|| boardVO.getSubFlag().equals("A") || boardVO.getSubFlag().equals("G") || boardVO.getSubFlag().equals("YY")) {
			if (boardVO.getSearchQuery().indexOf("KEYWORD;") != -1) {
				String keyword = commonUtil.cleanValueUnescape(searchQueryDoc.getElementsByTagName("KEYWORD").item(0).getTextContent());
				boardVO.setKeyword(keyword);
			}
			if (boardVO.getSearchQuery().indexOf("KEYWORDCLICK;") != -1) {
				keywordClick = commonUtil.cleanValueUnescape(searchQueryDoc.getElementsByTagName("KEYWORDCLICK").item(0).getTextContent());
				boardVO.setKeyword(keywordClick);
			}
		}
		
		if (boardVO.getBoardType().equals("5") && boardInfo.getBoardAdmin_FG().equals("false")) {
			searchMap.put("v_SEARCH_TOPWRITERID", userInfo.getId());
		}
		
		String boardXML = "";
		
		if (boardVO.getBoardType().equals("4") || boardVO.getBoardType().equals("7")) { // 썸네일 게시판, 동영상 게시판
			boardXML = getSearchThumbListXML(userInfo, boardVO, searchMap);
		} else if (boardVO.getBoardType().equals("M")) { // 나의 게시물, 임시보관함
			boardXML = getSearchMyBoardListItemXML(userInfo, boardVO, mode, searchMap);
		} else if (boardVO.getBoardType().equals("A")) { // 승인게시판
			boardXML = getSearchApprListItemXML(userInfo, boardVO, searchMap);
		} else {
			if (boardVO.getSubFlag().equals("A") || boardVO.getSubFlag().equals("G") || boardVO.getSubFlag().equals("YY")) { // 전체검색, 하위게시판포함 검색
				boardXML = getSearchAllBoardListItemXML(userInfo, boardVO, searchMap, keywordClick);
			} else { // 일반게시판, 익명게시판, 포토게시판, QnA게시판, 새 게시판
				boardXML = getSearchBoardListItemXML(userInfo, boardVO, searchMap);
			}
		}
		
		logger.debug("getSearchBoardList ended");
    	return boardXML;
    }
	
	/**
	 * 게시판 나의게시판검색리스트 표출 Method
	 */
	public String getSearchMyBoardListItemXML(LoginVO userInfo, BoardVO boardVO, String mode, Map<String, String> searchMap) throws Exception {
		logger.debug("getSearchMyBoardListItemXML started");

		String orderOption1 = "";
		String orderOption2 = "";
		String strMultiData = commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId());
		
		boardVO.setLang(userInfo.getLang());
		boardVO.setTenantID(userInfo.getTenantId());
		
		List<BoardListHeaderVO> headerList = ezBoardService.getListHeader(userInfo, boardVO);
		
		// 헤더 정보를 세팅한다.
		int i = 0;
		int hlength = headerList.size();

		//20240215 : 김진홍 : CSAP 인증 처리
		Map<String, String> orderByMap = new HashMap<String, String>();
		
		for (i = 0; i < hlength; i++) {
			if (boardVO.getOrderCell() != null && !boardVO.getOrderCell().equals("") && boardVO.getOrderCell().equals(headerList.get(i).getName())) {
				orderByMap.put("orderByCol",headerList.get(i).getColName().toUpperCase());
				if (boardVO.getOrderOption().equals("")) {
					orderByMap.put("orderByColDesc", "N");
					orderOption1 = headerList.get(i).getColName() + " ";
					orderOption2 = headerList.get(i).getColName() + " DESC ";
				} else {
					orderByMap.put("orderByColDesc", "Y");
					orderOption1 = headerList.get(i).getColName() + " DESC ";
					orderOption2 = headerList.get(i).getColName() + " ";
				}
			}
		}

		BoardPropertyVO scrapBoardInfo;
		ArrayList<String> scrapBoardListView_FG = new ArrayList<String>();
		ArrayList<String> scrapBoardListRead_FG = new ArrayList<String>();
		if("scrap".equals(mode) && boardVO.getScrapContID() == null){
			Map<String, ArrayList<String>> scrapBoardListReadView = getScrapBoardListReadView_FG(userInfo);
			scrapBoardListView_FG = scrapBoardListReadView.get("scrapBoardListView_FG");
			scrapBoardListRead_FG = scrapBoardListReadView.get("scrapBoardListRead_FG");
		}
		
		ArrayList<String> scrapContBoardListView_FG = new ArrayList<String>();
		ArrayList<String> scrapContBoardListRead_FG = new ArrayList<String>();
		if("scrap".equals(mode) && boardVO.getScrapContID() != null){
			Map<String, ArrayList<String>> scrapContBoardListReadView = getScrapContBoardListReadView_FG(userInfo, boardVO);
			scrapContBoardListView_FG = scrapContBoardListReadView.get("scrapContBoardListView_FG");
			scrapContBoardListRead_FG = scrapContBoardListReadView.get("scrapContBoardListRead_FG");
		}
		
		int boardCount = 0;
		
		if (mode == null || !mode.equals("temp") && !mode.equals("scrap")) {
			boardCount = ezBoardService.getSearchMyBoardItemCount(userInfo, boardVO, searchMap);
		} else if(mode.equals("temp")) {
			boardCount = ezBoardService.getSearchMyBoardItemCountTemp(userInfo, boardVO, searchMap);
		} else if(mode.equals("scrap") && boardVO.getScrapContID() != null) {
			boardCount = ezBoardService.getSearchScrapContItemListCount(userInfo, boardVO, scrapContBoardListView_FG, searchMap);
		} else if(mode.equals("scrap")) {
			boardCount = ezBoardService.getSearchMyBoardItemCountScrap(userInfo, boardVO, scrapBoardListView_FG, searchMap);
		}
		
		/* 2018-10-18 홍승비 - 나의게시물 검색을 위해 companyID 추가 */
		BoardListVO boardListVO = new BoardListVO();
		
		boardListVO.setPageCount(boardCount);
		boardListVO.setTotalCount(boardCount);
		boardListVO.setStartRow(1);
		boardListVO.setEndRow(0);
		boardListVO.setOrderBySub(orderOption1);
		boardListVO.setOrderByMain(orderOption2);
		boardListVO.setUserID(userInfo.getId());
		boardListVO.setWriterCompanyID(userInfo.getCompanyID());	
		
		BoardConfigVO boardConfigVO = ezBoardService.getPersonalCount(userInfo);
		
		boardListVO.setStartRow(boardConfigVO.getListCount() * (boardVO.getPageNum()-1) + 1);
		boardListVO.setEndRow(boardConfigVO.getListCount() * boardVO.getPageNum());
		
		if (boardVO.getTitle() == null) {
			boardVO.setTitle("");
		}
		
		if (boardVO.getABSTRACT() == null) {
			boardVO.setABSTRACT("");
		}
		
		if (boardVO.getWriterName() == null) {
			boardVO.setWriterName("");
		}
		
		if (boardVO.getKeyword() == null) {
			boardVO.setKeyword("");
		}
		
		List<HashMap<String, Object>> boardSearchList = null;
		
		if (mode == null || !mode.equals("temp") && !mode.equals("scrap")) {
			boardSearchList = ezBoardService.getSearchMyBoardItemList(boardListVO, boardVO, searchMap, orderByMap);
		} else if(mode.equals("temp")){
			boardSearchList = ezBoardService.getSearchMyBoardItemListTemp(boardListVO, boardVO, searchMap, orderByMap);
		} else if(mode.equals("scrap") && boardVO.getScrapContID() != null) {
			boardSearchList = ezBoardService.getSearchScrapContItemList(boardListVO, boardVO, scrapContBoardListView_FG, searchMap, orderByMap);
		} else if(mode.equals("scrap")){
    		boardSearchList = ezBoardService.getSearchMyBoardItemListScrap(boardListVO, boardVO, scrapBoardListView_FG, searchMap, orderByMap);
		}
		
		int dlength = boardSearchList.size();
		
		StringBuffer resultXML = new StringBuffer();
		
		resultXML.append("<DOCLIST>");
		resultXML.append("<TOTALCNT>" + boardCount + "</TOTALCNT>");
		resultXML.append("<PAGECNT>" + boardCount + "</PAGECNT>");
		resultXML.append("<PERSONALCNT>" + boardConfigVO.getListCount() + "</PERSONALCNT>");
		resultXML.append("<PREVIEWTYPE>" + boardConfigVO.getPreview() + "</PREVIEWTYPE>");
		resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
		resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
		resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
		resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (BoardListHeaderVO vo:headerList) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + vo.getName() + "</NAME>");
			resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
			resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
			resultXML.append("</HEADER>");
		}
		
		resultXML.append("</HEADERS>");
		resultXML.append("<ROWS>");
		
		String fieldName = "";
		String fieldValue = "";
		
		for (int j = 0; j < dlength; j++) {
			resultXML.append("<ROW>");
			for (i = 0; i < hlength; i++) {
				resultXML.append("<CELL>");
				fieldName = headerList.get(i).getColName().toUpperCase();
				
				if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME")) {
					fieldName = fieldName + strMultiData;
				}
				
				if (fieldName.equals("WRITEDATE")) {
					fieldValue = commonUtil.getDateStringInUTC((String)boardSearchList.get(j).get(fieldName), userInfo.getOffset(), false);
					fieldValue = fieldValue.substring(0, fieldValue.length() - 3);
				} else {
					fieldValue = commonUtil.cleanValue(String.valueOf(boardSearchList.get(j).get(fieldName)));
				}
				
				resultXML.append("<VALUE>" + fieldValue + "</VALUE>");
				
				if (i == 0) {
					resultXML.append("<DATA1>" + boardSearchList.get(j).get("BOARDID") + "</DATA1>");
					resultXML.append("<DATA2>" + boardSearchList.get(j).get("ITEMID") + "</DATA2>");
					resultXML.append("<DATA3>" + boardSearchList.get(j).get("WRITERID") + "</DATA3>");
					resultXML.append("<DATA4>" + boardSearchList.get(j).get("IMPORTANCE") + "</DATA4>");
					resultXML.append("<DATA5>" + boardSearchList.get(j).get("READFLAG") + "</DATA5>");
					resultXML.append("<DATA6>" + commonUtil.cleanValue(String.valueOf(boardSearchList.get(j).get("ABSTRACT"))) + "</DATA6>");
					
					String nowDate = commonUtil.getTodayUTCTime("");
					nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
					
					if (boardSearchList.get(j).get("WRITEDATE").toString().compareTo(nowDate) > 0) {
						resultXML.append("<DATA7>Y</DATA7>");
					} else {
						resultXML.append("<DATA7>N</DATA7>");
					}
					
					resultXML.append("<DATA8>" + boardSearchList.get(j).get("ITEMLEVEL") + "</DATA8>");
					resultXML.append("<DATA9>" + boardSearchList.get(j).get("NOTICE") + "</DATA9>");
					resultXML.append("<DATA10>" + boardSearchList.get(j).get("GUBUN") + "</DATA10>");
					resultXML.append("<DATA11>" + boardSearchList.get(j).get("ONELINECNT") + "</DATA11>");
					resultXML.append("<EXT>" + commonUtil.cleanValue(String.valueOf(boardSearchList.get(j).get("EXT"))) + "</EXT>");
					resultXML.append("<FILEPATH>" + commonUtil.cleanValue(String.valueOf(boardSearchList.get(j).get("FILEPATH"))) + "</FILEPATH>");

					if("scrap".equals(mode) && boardVO.getScrapContID() == null) {
                        if (scrapBoardListRead_FG.contains(boardSearchList.get(j).get("BOARDID"))) {
                            resultXML.append("<DATA13>" + "Y" + "</DATA13>");
                        } else {
                            resultXML.append("<DATA13>" + "N" + "</DATA13>");
                        }
                    }
					if("scrap".equals(mode) && boardVO.getScrapContID() != null){
						if (scrapContBoardListRead_FG.contains(boardSearchList.get(j).get("BOARDID"))) {
							resultXML.append("<DATA13>" + "Y" + "</DATA13>");
						} else {
							resultXML.append("<DATA13>" + "N" + "</DATA13>");
						}
					}
					resultXML.append("<PUBLICFLAG>").append(boardSearchList.get(j).get("PUBLICFLAG")).append("</PUBLICFLAG>");
				}
				
				resultXML.append("</CELL>");
			}
			
			resultXML.append("</ROW>");
		}
		
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		resultXML.append("</DOCLIST>");

		logger.debug("getSearchMyBoardListItemXML ended");
		return resultXML.toString();
	}

	/**
	 * 게시판 섬네일게시판검색리스트 표출 Method
	 */
	public String getSearchThumbListXML(LoginVO userInfo, BoardVO boardVO, Map<String, String> searchMap) throws Exception {
		logger.debug("getSearchThumbListXML started");

		String orderOption1 = "";
		String orderOption2 = "";
		String strMultiData = commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId());
		
		boardVO.setLang(userInfo.getLang());
		boardVO.setTenantID(userInfo.getTenantId());
		
		List<BoardListHeaderVO> headerList = ezBoardService.getListHeader(userInfo, boardVO);
		
		int i = 0;
		int hlength = headerList.size();
		Map<String, String> orderByMap = new HashMap<String, String>();
		
		for (i = 0; i < hlength; i++) {
			if (headerList.get(i).getColName().equalsIgnoreCase("ATTACHMENTS")) {
				continue;
			}

			if (boardVO.getOrderCell() != null && !boardVO.getOrderCell().equals("") && boardVO.getOrderCell().equals(headerList.get(i).getName())) {
				orderByMap.put("orderByCol", headerList.get(i).getColName().toUpperCase());
				if (boardVO.getOrderOption().equals("")) {
					orderByMap.put("orderByColDesc", "N");
					if (headerList.get(i).getColName().indexOf("WRITEDATE") > -1) {
						orderOption1 = headerList.get(i).getColName().replace("WRITEDATE", "A.WRITEDATE") + " ";
					} else if (headerList.get(i).getColName().indexOf("WRITERNAME") > -1) {
						orderOption1 = headerList.get(i).getColName().replace("WRITERNAME", "A.WRITERNAME") + " ";
					} else {
						orderOption1 = headerList.get(i).getColName()+ " ";
					}
				} else {
					orderByMap.put("orderByColDesc", "Y");
					if (headerList.get(i).getColName().indexOf("WRITEDATE") > -1) {
						orderOption1 = headerList.get(i).getColName().replace("WRITEDATE", "A.WRITEDATE") + " DESC";
					} else if (headerList.get(i).getColName().indexOf("WRITERNAME") > -1) {
						orderOption1 = headerList.get(i).getColName().replace("WRITERNAME", "A.WRITERNAME") + " DESC";
					} else {
						orderOption1 = headerList.get(i).getColName()+ " DESC";
					}
				}
			}
		}
		
		boardVO.setNowDate(commonUtil.getTodayUTCTime(""));
		
		int boardCount = ezBoardService.getSearchBoardItemCount(boardVO, searchMap);
		
		BoardListVO boardListVO = new BoardListVO();
		
		boardListVO.setPageCount(boardCount);
		boardListVO.setTotalCount(boardCount);
		boardListVO.setStartRow(1);
		boardListVO.setEndRow(0);
		boardListVO.setOrderBySub(orderOption1);
		boardListVO.setOrderByMain(orderOption2);
		boardListVO.setUserID(userInfo.getId());
		
		BoardConfigVO boardConfigVO = ezBoardService.getPersonalCount(userInfo);
		
		boardListVO.setStartRow(boardConfigVO.getListCount() * (boardVO.getPageNum()-1) + 1);
		boardListVO.setEndRow(boardConfigVO.getListCount() * boardVO.getPageNum());
		
		if (boardVO.getTitle() == null) {
			boardVO.setTitle("");
		}
		
		if (boardVO.getABSTRACT() == null) {
			boardVO.setABSTRACT("");
		}
		
		if (boardVO.getWriterName() == null) {
			boardVO.setWriterName("");
		}
		
		if (boardVO.getKeyword() == null) {
			boardVO.setKeyword("");
		}
		
		List<HashMap<String, Object>> boardThumbnailList = ezBoardService.getSearchThumbnailList(boardListVO, boardVO, searchMap, orderByMap);
		
		int dlength = boardThumbnailList.size();
		
		StringBuffer resultXML = new StringBuffer();
		
		resultXML.append("<DOCLIST>");
		resultXML.append("<TOTALCNT>" + boardCount + "</TOTALCNT>");
		resultXML.append("<PAGECNT>" + boardCount + "</PAGECNT>");
		resultXML.append("<PERSONALCNT>" + boardConfigVO.getListCount() + "</PERSONALCNT>");
		resultXML.append("<PREVIEWTYPE>" + boardConfigVO.getPreview() + "</PREVIEWTYPE>");
		resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
		resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
		resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
		resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (BoardListHeaderVO vo:headerList) {
			if (vo.getColName().equalsIgnoreCase("ATTACHMENTS")) {
				continue;
			}
			
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + vo.getName() + "</NAME>");
			resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
			resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
			resultXML.append("</HEADER>");
		}
		
		resultXML.append("</HEADERS>");
		resultXML.append("<ROWS>");
		
		String fieldName = "";
		String fieldValue = "";
		
		for (int j = 0; j < dlength; j++) {
			resultXML.append("<ROW>");
			for (i = 0; i < hlength; i++) {
				if (headerList.get(i).getColName().equalsIgnoreCase("ATTACHMENTS")) {
					continue;
				}
				
				resultXML.append("<CELL>");
				fieldName = headerList.get(i).getColName().toUpperCase();
				
				if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME") || fieldName.equals("WRITERCOMPANYNAME")) {
					fieldName = fieldName + strMultiData;
				}
				if (fieldName.equals("WRITEDATE")) {
					fieldValue = commonUtil.getDateStringInUTC((String)boardThumbnailList.get(j).get(fieldName), userInfo.getOffset(), false);
					fieldValue = fieldValue.substring(0, fieldValue.length()-3);
				} else {
					fieldValue = commonUtil.cleanValue(String.valueOf(boardThumbnailList.get(j).get(fieldName)));
				}
				
				resultXML.append("<VALUE>" + fieldValue + "</VALUE>");
				
				if (i == 0) {
					resultXML.append("<DATA1>" + boardThumbnailList.get(j).get("BOARDID") + "</DATA1>");
					resultXML.append("<DATA2>" + boardThumbnailList.get(j).get("ITEMID") + "</DATA2>");
					resultXML.append("<DATA3>" + boardThumbnailList.get(j).get("WRITERID") + "</DATA3>");
					String nowDate = commonUtil.getTodayUTCTime("");
					nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
					
					if (boardThumbnailList.get(j).get("WRITEDATE").toString().compareTo(nowDate) > 0) {
						resultXML.append("<DATA4>Y</DATA4>");
					} else {
						resultXML.append("<DATA4>N</DATA4>");
					}
					
					resultXML.append("<DATA5>" + boardThumbnailList.get(j).get("FILEPATH") + "</DATA5>");
					
					if (globals.getProperty("Globals.DbType").equals("oracle")) {
						resultXML.append("<DATA6>" + commonUtil.cleanValue((String)boardThumbnailList.get(j).get("TO_CHAR(MAINCONTENT)")) + "</DATA6>");
					} else if (globals.getProperty("Globals.DbType").equals("tibero")) {
						resultXML.append("<DATA6>" + commonUtil.cleanValue((String)boardThumbnailList.get(j).get("TO_CHAR(MAINCONTENT)")) + "</DATA6>");
					} else {
						resultXML.append("<DATA6>" + commonUtil.cleanValue((String)boardThumbnailList.get(j).get("MAINCONTENT")) + "</DATA6>");
					}
					
					resultXML.append("<DATA7>" + boardThumbnailList.get(j).get("ONELINECNT") + "</DATA7>");
					resultXML.append("<DATA8>" + boardThumbnailList.get(j).get("READFLAG") + "</DATA8>");
					/* 2019-04-09 홍승비 - 썸네일게시물 데이터에 제목 추가 */
					resultXML.append("<TITLE>" + commonUtil.cleanValue((String)boardThumbnailList.get(j).get("TITLE")) + "</TITLE>");
				}
				
				resultXML.append("</CELL>");
			}
			
			resultXML.append("</ROW>");
		}
		
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		resultXML.append("</DOCLIST>");

		logger.debug("getSearchThumbListXML ended");
		return resultXML.toString();
	}

	/**
	 * 게시판 게시판리스트검색 표출 Method
	 */
	public String getSearchBoardListItemXML(LoginVO userInfo, BoardVO boardVO, Map<String, String> searchMap) throws Exception {
		logger.debug("getSearchBoardListItemXML started");

		String orderOption1 = "";
		String orderOption2 = "";
		String strMultiData = commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId());
		boardVO.setLang(userInfo.getLang());
		boardVO.setTenantID(userInfo.getTenantId());
		
		List<BoardListHeaderVO> headerList = ezBoardService.getListHeaderBoardID(userInfo, boardVO);
		
		// 헤더 정보를 세팅한다.
		int i = 0;
		int hlength = headerList.size();

		//20240215 : 김진홍 : CSAP 인증 처리
		Map<String, String> orderByMap = new HashMap<String, String>();
		
		for (i = 0; i < hlength; i++) {
			if (boardVO.getOrderCell() != null && !boardVO.getOrderCell().equals("") && boardVO.getOrderCell().equals(headerList.get(i).getName())) {
				orderByMap.put("orderByCol", headerList.get(i).getColName().toUpperCase());
				if (boardVO.getOrderOption().equals("")) {
					orderByMap.put("orderByColDesc", "N");
					orderOption1 = headerList.get(i).getColName() + " ";
					orderOption2 = headerList.get(i).getColName() + " DESC ";
				} else {
					orderByMap.put("orderByColDesc", "Y");
					orderOption1 = headerList.get(i).getColName() + " DESC ";
					orderOption2 = headerList.get(i).getColName() + " ";
				}
			}
		}
		
		boardVO.setNowDate(commonUtil.getTodayUTCTime(""));
		
		int boardCount = ezBoardService.getSearchBoardItemCount(boardVO, searchMap);
		
		BoardListVO boardListVO = new BoardListVO();
		boardListVO.setPageCount(boardCount);
		boardListVO.setTotalCount(boardCount);
		boardListVO.setStartRow(1);
		boardListVO.setEndRow(0);
		boardListVO.setOrderBySub(orderOption1);
		boardListVO.setOrderByMain(orderOption2);
		boardListVO.setUserID(userInfo.getId());
		
		BoardConfigVO boardConfigVO = ezBoardService.getPersonalCount(userInfo);
		
		boardListVO.setStartRow(boardConfigVO.getListCount() * (boardVO.getPageNum()-1) + 1);
		boardListVO.setEndRow(boardConfigVO.getListCount() * boardVO.getPageNum());
		
		if (boardVO.getTitle() == null) {
			boardVO.setTitle("");
		}
		
		if (boardVO.getABSTRACT() == null) {
			boardVO.setABSTRACT("");
		}
		
		if (boardVO.getWriterName() == null) {
			boardVO.setWriterName("");
		}

		if (boardVO.getKeyword() == null) {
			boardVO.setKeyword("");
		}
		
		List<HashMap<String, Object>> boardSearchList = ezBoardService.getSearchBoardItemList(boardListVO, boardVO, searchMap, orderByMap);
		
		int dlength = boardSearchList.size();
		
		StringBuffer resultXML = new StringBuffer();
		
		resultXML.append("<DOCLIST>");
		resultXML.append("<TOTALCNT>" + boardCount + "</TOTALCNT>");
		resultXML.append("<PAGECNT>" + boardCount + "</PAGECNT>");
		resultXML.append("<PERSONALCNT>" + boardConfigVO.getListCount() + "</PERSONALCNT>");
		resultXML.append("<PREVIEWTYPE>" + boardConfigVO.getPreview() + "</PREVIEWTYPE>");
		resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
		resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
		resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
		resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (BoardListHeaderVO vo:headerList) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + vo.getName() + "</NAME>");
			resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
			resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
			resultXML.append("</HEADER>");
		}
		
		resultXML.append("</HEADERS>");
		resultXML.append("<ROWS>");
		
		String fieldName = "";
		String fieldValue = "";
		
		
		for (int j = 0; j < dlength; j++) {
			resultXML.append("<ROW>");
			for (i = 0; i < hlength; i++) {
				resultXML.append("<CELL>");
				fieldName = headerList.get(i).getColName().toUpperCase();
				
				if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME") || fieldName.equals("BOARDNAME") || fieldName.equals("WRITERCOMPANYNAME")) {
					fieldName = fieldName + strMultiData;
				}
				if (fieldName.equals("WRITEDATE")) {
					fieldValue = commonUtil.getDateStringInUTC((String)boardSearchList.get(j).get(fieldName), userInfo.getOffset(), false);
					fieldValue = fieldValue.substring(0, fieldValue.length()-3);
				} else {
					fieldValue = commonUtil.cleanValue(String.valueOf(boardSearchList.get(j).get(fieldName)));
				}
				
				if (fieldValue == null || fieldValue.equals("null")) {
					fieldValue = "";
				}
				
				resultXML.append("<VALUE>"+fieldValue+"</VALUE>");
				
				if (i == 0) {
					resultXML.append("<DATA1>" + boardSearchList.get(j).get("BOARDID") + "</DATA1>"); 
					resultXML.append("<DATA2>" + boardSearchList.get(j).get("ITEMID") + "</DATA2>");
					resultXML.append("<DATA3>" + boardSearchList.get(j).get("WRITERID") + "</DATA3>");
					resultXML.append("<DATA4>" + boardSearchList.get(j).get("IMPORTANCE") + "</DATA4>");
					resultXML.append("<DATA5>" + boardSearchList.get(j).get("READFLAG") + "</DATA5>");
					resultXML.append("<DATA6>" + commonUtil.cleanValue(String.valueOf(boardSearchList.get(j).get("ABSTRACT"))) + "</DATA6>");
					String nowDate = commonUtil.getTodayUTCTime("");
					nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
					
					if (boardSearchList.get(j).get("WRITEDATE").toString().compareTo(nowDate) > 0) {
						resultXML.append("<DATA7>Y</DATA7>");
					} else {
						resultXML.append("<DATA7>N</DATA7>");
					}
					
					resultXML.append("<DATA8>" + boardSearchList.get(j).get("ITEMLEVEL") + "</DATA8>");
					resultXML.append("<DATA9>" + boardSearchList.get(j).get("NOTICE") + "</DATA9>");
					resultXML.append("<DATA10>" + boardSearchList.get(j).get("GUBUN") + "</DATA10>");
					resultXML.append("<DATA11>" + boardSearchList.get(j).get("ONELINECNT") + "</DATA11>");
					
					if (globals.getProperty("Globals.DbType").equals("oracle")) {
						resultXML.append("<DATA12>" + commonUtil.cleanValue((String)boardSearchList.get(j).get("TO_CHAR(MAINCONTENT)")) + "</DATA12>");
					} else if (globals.getProperty("Globals.DbType").equals("tibero")) {
						resultXML.append("<DATA12>" + commonUtil.cleanValue((String)boardSearchList.get(j).get("TO_CHAR(MAINCONTENT)")) + "</DATA12>");
					} else {
						resultXML.append("<DATA12>" + commonUtil.cleanValue((String)boardSearchList.get(j).get("MAINCONTENT")) + "</DATA12>");
					}
						
					resultXML.append("<EXT>" + commonUtil.cleanValue(String.valueOf(boardSearchList.get(j).get("EXT"))) + "</EXT>");
					resultXML.append("<FILEPATH>" + commonUtil.cleanValue(String.valueOf(boardSearchList.get(j).get("FILEPATH"))) + "</FILEPATH>");
					
					resultXML.append("<PUBLICFLAG>" + boardSearchList.get(j).get("PUBLICFLAG") + "</PUBLICFLAG>");
				}
				resultXML.append("</CELL>");
			}
			resultXML.append("</ROW>");
		}
		
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		resultXML.append("</DOCLIST>");

		logger.debug("getSearchBoardListItemXML ended");
		return resultXML.toString();
	}

	/**
	 * 게시판 새게시판리스트 표출 Method
	 */
	public String getNewItemList(BoardVO boardVO, LoginVO userInfo) throws Exception {
		logger.debug("getNewItemList started");

		String orderOption1 = "";
		String orderOption2 = "";
		String strMultiData = commonUtil.getMultiData(boardVO.getLang(), userInfo.getTenantId());
		String anonyMsg = "";
		
		BoardListVO boardListVO = new BoardListVO();
		
		List<BoardListHeaderVO> headerList = ezBoardService.getListHeader(userInfo, boardVO);
		
		int i = 0;
		int hlength = headerList.size();
		Map<String, String> orderByMap = new HashMap<String, String>();
		
		for (i = 0; i < hlength; i++) {
			if (boardVO.getOrderCell() != null && !boardVO.getOrderCell().equals("") && boardVO.getOrderCell().equals(headerList.get(i).getName())) {
				orderByMap.put("orderByCol", headerList.get(i).getColName().toUpperCase());
				if (boardVO.getOrderOption().equals("")) {
					orderByMap.put("orderByColDesc", "N");
					if (headerList.get(i).getName().indexOf("BOARDNAME") > -1) {
						orderOption1 = headerList.get(i).getColName().replace("BOARDNAME", "B.BOARDNAME") + " ";
					} else {
						orderOption1 = headerList.get(i).getColName() + " ";
					}
				} else {
					orderByMap.put("orderByColDesc", "Y");
					if (headerList.get(i).getColName().indexOf("BOARDNAME") > -1) {
						orderOption1 = headerList.get(i).getColName().replace("BOARDNAME", "B.BOARDNAME") + " DESC ";
					} else {
						orderOption1 = headerList.get(i).getColName() + " DESC ";
					}
				}
			}
		}
		
		String fieldName = "";
		String fieldValue = "";
		
		BoardConfigVO boardConfigVO = ezBoardService.getPersonalCount(userInfo);
		
		// 새게시물 카운트 시 companyID 조건 추가
		int boardCount = ezBoardService.getNewItemListCount(userInfo);
		int startRow = 1;
		int endRow = 0;
		int personalCount_ = boardConfigVO.getListCount();
		
		boardConfigVO.setPageCnt(boardCount);
		boardConfigVO.setTotalCnt(boardCount);
		
		startRow = (personalCount_ * (boardVO.getPageNum() - 1)) + 1;
		endRow = (personalCount_ * boardVO.getPageNum());
		
		boardListVO.setUserID(userInfo.getId());
		boardListVO.setWriterCompanyID(userInfo.getCompanyID());
		boardListVO.setTenantID(userInfo.getTenantId());
		boardListVO.setStartRow(startRow);
		boardListVO.setEndRow(endRow);
		boardListVO.setTotalCount(boardCount);
		boardListVO.setOrderBySub(orderOption1);
		boardListVO.setOrderByMain(orderOption2);
		
		// 새게시물 표출 시 companyID 조건 추가
		List<HashMap<String, Object>> boardList = ezBoardService.getNewItemList(boardListVO, orderByMap);
		
		int dlength = boardList.size();
		StringBuffer resultXML = new StringBuffer();
		
		resultXML.append("<DOCLIST>");
		resultXML.append("<TOTALCNT>" + boardCount + "</TOTALCNT>");
		resultXML.append("<PAGECNT>" + boardCount + "</PAGECNT>");
		resultXML.append("<PERSONALCNT>" + personalCount_ + "</PERSONALCNT>");
		resultXML.append("<PREVIEWTYPE>" + boardConfigVO.getPreview() + "</PREVIEWTYPE>");
		resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
		resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
		resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
		resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (BoardListHeaderVO vo:headerList) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + vo.getName() + "</NAME>");
			resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
			resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
			resultXML.append("</HEADER>");
		}
		
		resultXML.append("</HEADERS>");
		resultXML.append("<ROWS>");
		
		/* 2018-11-28 홍승비 - 새게시물 리스트의 익명게시물 부서칼럼 '익명'으로 표출 */
		anonyMsg = egovMessageSource.getMessage("ezBoard.t249", userInfo.getLocale()).split(";")[0];
		
		for (int j = 0; j < dlength; j++) {
			resultXML.append("<ROW>");
			
			/* 2019-08-02 홍승비 - 다국어 환경에서 부서명 '익명'처리되지 않는 오류 수정 */
			if (String.valueOf(boardList.get(j).get("GUBUN")).equals("2")) {
				boardList.get(j).replace("WRITERDEPTNAME", anonyMsg);
				boardList.get(j).replace("WRITERDEPTNAME2", anonyMsg);
			}
			
			for (i = 0; i < hlength; i++) {
				resultXML.append("<CELL>");
				fieldName = headerList.get(i).getColName().toUpperCase();
				
				if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME") || fieldName.equals("BOARDNAME")) {
					fieldName = fieldName + strMultiData;
				}
				if (fieldName.equals("WRITEDATE")) {
					fieldValue = commonUtil.getDateStringInUTC((String)boardList.get(j).get(fieldName), userInfo.getOffset(), false);
					fieldValue = fieldValue.substring(0, fieldValue.length()-3);
				} else {
					fieldValue = commonUtil.cleanValue(String.valueOf(boardList.get(j).get(fieldName)));
				}
				
				resultXML.append("<VALUE>" + fieldValue + "</VALUE>");
				
				if (i == 0) {
					resultXML.append("<DATA1>" + boardList.get(j).get("BOARDID") + "</DATA1>");
					resultXML.append("<DATA2>" + boardList.get(j).get("ITEMID") + "</DATA2>");
					resultXML.append("<DATA3>" + boardList.get(j).get("WRITERID") + "</DATA3>");
					resultXML.append("<DATA4>" + boardList.get(j).get("IMPORTANCE") + "</DATA4>");
					resultXML.append("<DATA5>1</DATA5>");
					resultXML.append("<DATA6>" + commonUtil.cleanValue((String)boardList.get(j).get("ABSTRACT")) + "</DATA6>");
					resultXML.append("<DATA7>N</DATA7>");
					resultXML.append("<DATA8>" + boardList.get(j).get("ITEMLEVEL") + "</DATA8>");
					resultXML.append("<DATA9>" + boardList.get(j).get("NOTICE") + "</DATA9>");
					resultXML.append("<DATA10>" + boardList.get(j).get("GUBUN") + "</DATA10>");
					resultXML.append("<DATA11>" + boardList.get(j).get("ONELINECNT") + "</DATA11>");
					
					if (globals.getProperty("Globals.DbType").equals("oracle")) {
						resultXML.append("<DATA12>" + commonUtil.cleanValue((String)boardList.get(j).get("TO_CHAR(MAINCONTENT)")) + "</DATA12>");
					} else if (globals.getProperty("Globals.DbType").equals("tibero")) {
						resultXML.append("<DATA12>" + commonUtil.cleanValue((String)boardList.get(j).get("TO_CHAR(MAINCONTENT)")) + "</DATA12>");
					} else {
						resultXML.append("<DATA12>" + commonUtil.cleanValue((String)boardList.get(j).get("MAINCONTENT")) + "</DATA12>");
					}

					resultXML.append("<TITLE>" + commonUtil.cleanValue((String)boardList.get(j).get("TITLE")) + "</TITLE>");
					/* 2019-07-04 홍승비 - 게시판 미독건수 읽음표시 처리용 boardGroupID 추가 */
					resultXML.append("<BOARDGROUPID>" + boardList.get(j).get("BOARDGROUPID") + "</BOARDGROUPID>");
                    resultXML.append("<PUBLICFLAG>").append(boardList.get(j).get("PUBLICFLAG")).append("</PUBLICFLAG>");
					resultXML.append("<EXT>" + commonUtil.cleanValue((String) boardList.get(j).get("EXT")) + "</EXT>");
					resultXML.append("<FILEPATH>" + commonUtil.cleanValue((String) boardList.get(j).get("FILEPATH")) + "</FILEPATH>");
					resultXML.append("<ITEMREAD_FG>" + (accessCheck((String)boardList.get(j).get("BOARDID"), (String)boardList.get(j).get("ITEMID"),
							"GENERAL", userInfo, "") ? "Y" : "N") + "</ITEMREAD_FG>");
				}
				resultXML.append("</CELL>");
			}
			resultXML.append("</ROW>");
		}
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		resultXML.append("</DOCLIST>");

		logger.debug("getNewItemList ended");
		return resultXML.toString();
	}
	
	/**
	 * 게시판 게시판게시물 표출 Method
	 */
	public String getBoardListItem(BoardVO boardVO, LoginVO userInfo, String type) throws Exception {
		logger.debug("getBoardListItem started");

		String orderOption1 = "";
		String orderOption2 = "";
		String strMultiData = commonUtil.getMultiData(boardVO.getLang(), userInfo.getTenantId());
		String primaryData = commonUtil.getPrimaryData(boardVO.getLang(), userInfo.getTenantId());
		String useVersion = ezBoardService.getUseVersionFlag(boardVO.getBoardId(), userInfo.getTenantId());
		
		List<BoardListHeaderVO> headerList = ezBoardService.getListHeaderBoardID(userInfo, boardVO);
		
		// 헤더 정보를 세팅한다.
		int i = 0;
		int hlength = headerList.size(); 
		int writeDateSN = 0; //작성일 순번
		int titleSN = 0; //제목 순번
		Map<String, String> orderByMap = new HashMap<String, String>();
		
		for (i = 0; i < hlength; i++) {
			if (boardVO.getOrderCell() != null && !boardVO.getOrderCell().equals("") && boardVO.getOrderCell().equals(headerList.get(i).getName())) {
				orderByMap.put("orderByCol", headerList.get(i).getColName().toUpperCase());
				if (boardVO.getOrderOption().equals("")) {
					orderByMap.put("orderByColDesc", "N");
					orderOption1 = headerList.get(i).getColName() + " ";
					orderOption2 = headerList.get(i).getColName() + " DESC ";
				} else {
					orderByMap.put("orderByColDesc", "Y");
					orderOption1 = headerList.get(i).getColName() + " DESC ";
					orderOption2 = headerList.get(i).getColName() + " ";
				}
			}
			if ("WRITEDATE".equals(headerList.get(i).getColName().toUpperCase())) {
				writeDateSN = i;
			}
			if ("TITLE".equals(headerList.get(i).getColName().toUpperCase())) {
				titleSN = i;
			}
		}
		
		int noticeCount = 0;
		
		if (type.equals("1")) {
			boardVO.setNowDate(commonUtil.getTodayUTCTime(""));
			noticeCount = ezBoardService.getNoticePostItemCount(boardVO);
		}
		
		BoardMyFavoriteVO boardMyFavoriteVO = new BoardMyFavoriteVO();
		boardMyFavoriteVO.setBoardId(boardVO.getBoardId());
		boardMyFavoriteVO.setUserId(userInfo.getId());
		boardMyFavoriteVO.setType(type);
		boardMyFavoriteVO.setTenantID(userInfo.getTenantId());
		boardMyFavoriteVO.setNowDate(commonUtil.getTodayUTCTime(""));
		boardMyFavoriteVO.setUseVersion(useVersion);
		
		int boardCount = ezBoardService.getBrdTotalItemCount(boardMyFavoriteVO);
		int startRow = 1;
		int endRow = 0;
		
		BoardConfigVO boardConfigVO = ezBoardService.getPersonalCount(userInfo);
		
		int personalCount = boardConfigVO.getListCount();

		String previewtype = boardConfigVO.getPreview();
		String fieldName = "";
		String fieldValue = "";
		StringBuffer resultXML = new StringBuffer();
		
		resultXML.append("<DOCLIST>");
		
		if (noticeCount > 0 && type.equals("1")) {
			endRow = (personalCount * boardVO.getPageNum()) - noticeCount;
			
			if (endRow < 0) {
				endRow = 0;
			}
			
			List<HashMap<String, Object>> noticeList = ezBoardService.getNoticePostItem(boardVO, personalCount);
			
			int k = 0;
			int nlength = noticeList.size();
			
			resultXML.append("<TOTALCNT>" + boardCount + "</TOTALCNT>");
			resultXML.append("<PAGECNT>" + ((int)noticeCount + (int)boardCount) + "</PAGECNT>");
			resultXML.append("<PERSONALCNT>" + personalCount + "</PERSONALCNT>");
			resultXML.append("<PREVIEWTYPE>" + previewtype + "</PREVIEWTYPE>");
			resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
			resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
			resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
			resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
			resultXML.append("<WRITEDATENUM>" + writeDateSN + "</WRITEDATENUM>");
			resultXML.append("<TITLENUM>" + titleSN + "</TITLENUM>");
			resultXML.append("<LISTVIEWDATA>");
			resultXML.append("<HEADERS>");
			
			for (BoardListHeaderVO vo:headerList) {
				resultXML.append("<HEADER>");
				resultXML.append("<NAME>"+vo.getName()+"</NAME>");
				resultXML.append("<WIDTH>"+vo.getWidth()+"</WIDTH>");
				resultXML.append("<COLNAME>"+vo.getColName()+"</COLNAME>");
				resultXML.append("</HEADER>");
			}
			
			resultXML.append("</HEADERS>");
			resultXML.append("<ROWS>");
			
			for (k=0; k < nlength; k++) {
				resultXML.append("<ROW>");
				for (i = 0; i < hlength; i++) {
					resultXML.append("<CELL>");
					fieldName = headerList.get(i).getColName().toUpperCase();
					
					if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME") || fieldName.equals("WRITERCOMPANYNAME")) {
						fieldName = fieldName + strMultiData;
					}
					if (fieldName.equals("WRITEDATE")) {
						fieldValue = commonUtil.getDateStringInUTC((String) noticeList.get(k).get(fieldName), userInfo.getOffset(), false);
						fieldValue = fieldValue.substring(0, fieldValue.length()-3);
					} else {
						fieldValue = commonUtil.cleanValue(String.valueOf(noticeList.get(k).get(fieldName)));
					}
					
					if (fieldValue == null || fieldValue.equals("null")) {
						fieldValue = "";
					}
					
					resultXML.append("<VALUE>" + fieldValue + "</VALUE>");
					
					if (i == 0) {
						resultXML.append("<DATA1>" + noticeList.get(k).get("BOARDID") + "</DATA1>");
						resultXML.append("<DATA2>" + noticeList.get(k).get("ITEMID") + "</DATA2>");
						resultXML.append("<DATA3>" + noticeList.get(k).get("WRITERID") + "</DATA3>");
						resultXML.append("<DATA4>" + noticeList.get(k).get("IMPORTANCE") + "</DATA4>");
						resultXML.append("<DATA5>" + noticeList.get(k).get("READFLAG") + "</DATA5>");
						resultXML.append("<DATA6>" + commonUtil.cleanValue((String)noticeList.get(k).get("ABSTRACT")) + "</DATA6>");
						String nowDate = commonUtil.getTodayUTCTime("");
						nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
						
						if (noticeList.get(k).get("WRITEDATE").toString().compareTo(nowDate) > 0) {
							resultXML.append("<DATA7>Y</DATA7>");
						} else {
							resultXML.append("<DATA7>N</DATA7>");
						}
						
						resultXML.append("<DATA8>" + noticeList.get(k).get("ITEMLEVEL") + "</DATA8>");
						resultXML.append("<DATA9>" + noticeList.get(k).get("NOTICE") + "</DATA9>");
						resultXML.append("<DATA10></DATA10>");
						/* 2024-01-08 홍승비 - 일반게시판 > 공지사항 게시물 댓글 카운트 서브쿼리 제거, 각 게시물에 대해 별도로 리턴 */
						resultXML.append("<DATA11>" + ezBoardService.getOneLineCNT(noticeList.get(k).get("ITEMID").toString(), userInfo.getTenantId()) + "</DATA11>");
						
						if (globals.getProperty("Globals.DbType").equals("oracle")) {
							resultXML.append("<DATA12>" + commonUtil.cleanValue((String)noticeList.get(k).get("TO_CHAR(MAINCONTENT)")) + "</DATA12>");
						} else if (globals.getProperty("Globals.DbType").equals("tibero")) {
							resultXML.append("<DATA12>" + commonUtil.cleanValue((String)noticeList.get(k).get("TO_CHAR(MAINCONTENT)")) + "</DATA12>");
						} else {
							resultXML.append("<DATA12>" + commonUtil.cleanValue((String)noticeList.get(k).get("MAINCONTENT")) + "</DATA12>");
						}
						
						resultXML.append("<TITLE>" +  commonUtil.cleanValue((String)noticeList.get(k).get("TITLE"))  + "</TITLE>");
						
						if (primaryData.equals("1")) {
							resultXML.append("<WRITERNAME>" + commonUtil.cleanValue((String)noticeList.get(k).get("WRITERNAME")) + "</WRITERNAME>");
							resultXML.append("<WRITERDEPTNAME>" + commonUtil.cleanValue((String)noticeList.get(k).get("WRITERDEPTNAME")) + "</WRITERDEPTNAME>");
						} else {
							resultXML.append("<WRITERNAME>" + commonUtil.cleanValue((String)noticeList.get(k).get("WRITERNAME2")) + "</WRITERNAME>");
							resultXML.append("<WRITERDEPTNAME>" + commonUtil.cleanValue((String)noticeList.get(k).get("WRITERDEPTNAME2")) + "</WRITERDEPTNAME>");
						}
						
						resultXML.append("<WRITEDATE>" + commonUtil.getDateStringInUTC((String)noticeList.get(k).get("WRITEDATE"), userInfo.getOffset(), false) + "</WRITEDATE>");
						resultXML.append("<ATTACHMENTS>" + noticeList.get(k).get("ATTACHMENTS") + "</ATTACHMENTS>");
						resultXML.append("<GUBUN>" + noticeList.get(k).get("GUBUN") + "</GUBUN>");
                        resultXML.append("<PUBLICFLAG>").append(noticeList.get(k).get("PUBLICFLAG")).append("</PUBLICFLAG>");
						resultXML.append("<EXT>" +  commonUtil.cleanValue((String)noticeList.get(k).get("EXT"))  + "</EXT>");
						resultXML.append("<FILEPATH>" +  commonUtil.cleanValue((String)noticeList.get(k).get("FILEPATH"))  + "</FILEPATH>");
						resultXML.append("<ITEMREAD_FG>" + (accessCheck((String)noticeList.get(k).get("BOARDID"), (String)noticeList.get(k).get("ITEMID"),
								"GENERAL", userInfo, "") ? "Y" : "N") + "</ITEMREAD_FG>");
						resultXML.append("<WRITERDEPTID>" + noticeList.get(k).get("WRITERDEPTID") + "</WRITERDEPTID>");
						resultXML.append("<WRITERNAMETYPE>" + noticeList.get(k).get("WRITERNAMETYPE") + "</WRITERNAMETYPE>");
					}
					resultXML.append("</CELL>");
				}
				resultXML.append("</ROW>");
			}
		} else {
			startRow = ((personalCount * (boardVO.getPageNum() - 1))) + 1;
			endRow = (personalCount * boardVO.getPageNum());
			
			resultXML.append("<TOTALCNT>" + boardCount + "</TOTALCNT>");
			resultXML.append("<PAGECNT>" + boardCount + "</PAGECNT>");
			resultXML.append("<PERSONALCNT>" + personalCount + "</PERSONALCNT>");
			resultXML.append("<PREVIEWTYPE>" + previewtype + "</PREVIEWTYPE>");
			resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
			resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
			resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
			resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
			resultXML.append("<WRITEDATENUM>" + writeDateSN + "</WRITEDATENUM>");
			resultXML.append("<TITLENUM>" + titleSN + "</TITLENUM>");
			resultXML.append("<LISTVIEWDATA>");
			resultXML.append("<HEADERS>");
			
			for (BoardListHeaderVO vo:headerList) {
				resultXML.append("<HEADER>");
				resultXML.append("<NAME>" + vo.getName() + "</NAME>");
				resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
				resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
				resultXML.append("</HEADER>");
			}
			
			resultXML.append("</HEADERS>");
			resultXML.append("<ROWS>");
			
		}
		if (boardVO.getPageNum() != 1) {
			startRow = ((personalCount * (boardVO.getPageNum() - 1)) - noticeCount) + 1;
			endRow = (personalCount * boardVO.getPageNum()) - noticeCount;
			
			if (startRow <= 0) {
				startRow = 1;
			}
		}
		
		List<HashMap<String, Object>> boardListItem = null;
		
		// 2024-10-24 조수빈 - 같은 리스트 형이나, 데이터를 저장하는 테이블이 달라 일반게시판과 포토게시판 조회 메소드를 분리함
		if ("3".equals(boardVO.getBoardType())) {
			boardListItem = ezBoardService.getPhotoBoardListItem(boardVO.getBoardId(), userInfo.getId(), startRow, endRow, boardCount, orderOption1, orderOption2, orderByMap, type, userInfo.getTenantId(), boardVO.getBoardType());
		} else {
			boardListItem = ezBoardService.getBoardListItem(boardVO.getBoardId(), userInfo.getId(), startRow, endRow, boardCount, orderOption1, orderOption2, orderByMap, type, userInfo.getTenantId(), useVersion);
		}
		
		int dlength = boardListItem.size();
		
		for (int j = 0; j < dlength; j++) {
			resultXML.append("<ROW>");
			for (i = 0; i < hlength; i++) {
				resultXML.append("<CELL>");
				fieldName = headerList.get(i).getColName().toUpperCase();
				
				if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME") || fieldName.equals("WRITERCOMPANYNAME")) {
					fieldName = fieldName + strMultiData;
				}
				
				if (fieldName.equals("WRITEDATE")) {
					fieldValue = commonUtil.getDateStringInUTC((String) boardListItem.get(j).get(fieldName), userInfo.getOffset(), false);
					fieldValue = fieldValue.substring(0, fieldValue.length()-3);
				} else {
					fieldValue = commonUtil.cleanValue(String.valueOf(boardListItem.get(j).get(fieldName)));
				}
				
				if (fieldValue == null || fieldValue.equals("null")) {
					fieldValue = "";
				}
				
				resultXML.append("<VALUE>" + fieldValue + "</VALUE>");
				
				if (i == 0) {
					resultXML.append("<DATA1>" + boardListItem.get(j).get("BOARDID") + "</DATA1>");
					resultXML.append("<DATA2>" + boardListItem.get(j).get("ITEMID") + "</DATA2>");
					resultXML.append("<DATA3>" + boardListItem.get(j).get("WRITERID") + "</DATA3>");
					resultXML.append("<DATA4>" + boardListItem.get(j).get("IMPORTANCE") + "</DATA4>");
					
					/* 2021-01-06 홍승비 - 게시물의 읽음여부 판별 시, 현재 사용자가 읽은 게시물을 셀렉트하도록 수정 */
					int readCount = ezBoardService.getReaderListCount2(boardListItem.get(j).get("BOARDID").toString(), boardListItem.get(j).get("ITEMID").toString(), userInfo.getId(), userInfo.getTenantId());
					if (readCount > 0) {
						resultXML.append("<DATA5>1</DATA5>");
					} else {
						resultXML.append("<DATA5>0</DATA5>");
					}
					
					resultXML.append("<DATA6>" + commonUtil.cleanValue((String)boardListItem.get(j).get("ABSTRACT")) + "</DATA6>");
					String nowDate = commonUtil.getTodayUTCTime("");
					nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
					
					if (boardListItem.get(j).get("WRITEDATE").toString().compareTo(nowDate) > 0) {
						resultXML.append("<DATA7>Y</DATA7>");
					} else {
						resultXML.append("<DATA7>N</DATA7>");
					}
					
					resultXML.append("<DATA8>" + boardListItem.get(j).get("ITEMLEVEL") + "</DATA8>");
					resultXML.append("<DATA9>" + boardListItem.get(j).get("NOTICE") + "</DATA9>");
					resultXML.append("<DATA10></DATA10>");
					resultXML.append("<DATA11>" + ezBoardService.getOneLineCNT(boardListItem.get(j).get("ITEMID").toString(), userInfo.getTenantId()) + "</DATA11>");
					
					if (globals.getProperty("Globals.DbType").equals("oracle")) {
						resultXML.append("<DATA12>" + commonUtil.cleanValue((String)boardListItem.get(j).get("TO_CHAR(MAINCONTENT)")) + "</DATA12>");
					} else if (globals.getProperty("Globals.DbType").equals("tibero")) {
						resultXML.append("<DATA12>" + commonUtil.cleanValue((String)boardListItem.get(j).get("TO_CHAR(MAINCONTENT)")) + "</DATA12>");
					} else {
						resultXML.append("<DATA12>" + commonUtil.cleanValue((String)boardListItem.get(j).get("MAINCONTENT")) + "</DATA12>");
					}
					
					resultXML.append("<TITLE>" + commonUtil.cleanValue((String)boardListItem.get(j).get("TITLE")) + "</TITLE>");
					resultXML.append("<WRITERNAME>" + commonUtil.cleanValue((String)boardListItem.get(j).get("WRITERNAME")) + "</WRITERNAME>");
					resultXML.append("<WRITERNAME2>" + commonUtil.cleanValue((String)boardListItem.get(j).get("WRITERNAME2")) + "</WRITERNAME2>");
					resultXML.append("<WRITERDEPTNAME>" + commonUtil.cleanValue((String)boardListItem.get(j).get("WRITERDEPTNAME")) + "</WRITERDEPTNAME>");
					resultXML.append("<WRITERDEPTNAME2>" + commonUtil.cleanValue((String)boardListItem.get(j).get("WRITERDEPTNAME2")) + "</WRITERDEPTNAME2>");
					resultXML.append("<WRITEDATE>" + commonUtil.getDateStringInUTC((String)boardListItem.get(j).get("WRITEDATE"), userInfo.getOffset(), false) + "</WRITEDATE>");
					resultXML.append("<ATTACHMENTS>" + boardListItem.get(j).get("ATTACHMENTS") + "</ATTACHMENTS>");
					resultXML.append("<EXT>" + commonUtil.cleanValue((String) boardListItem.get(j).get("EXT")) + "</EXT>");
					resultXML.append("<FILEPATH>" + commonUtil.cleanValue((String) boardListItem.get(j).get("FILEPATH")) + "</FILEPATH>");
					resultXML.append("<GUBUN>" + boardListItem.get(j).get("GUBUN") + "</GUBUN>");
					resultXML.append("<PUBLICFLAG>").append(boardListItem.get(j).get("PUBLICFLAG")).append("</PUBLICFLAG>");
					resultXML.append("<ITEMREAD_FG>" + (accessCheck((String)boardListItem.get(j).get("BOARDID"), (String)boardListItem.get(j).get("ITEMID"),
							"GENERAL", userInfo, "") ? "Y" : "N") + "</ITEMREAD_FG>");
					resultXML.append("<WRITERDEPTID>" + boardListItem.get(j).get("WRITERDEPTID") + "</WRITERDEPTID>");
					resultXML.append("<WRITERNAMETYPE>" + boardListItem.get(j).get("WRITERNAMETYPE") + "</WRITERNAMETYPE>");
				}
				resultXML.append("</CELL>");
			}
			resultXML.append("</ROW>");
		}
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		resultXML.append("</DOCLIST>");
		
		logger.debug("getBoardListItem ended");
        return resultXML.toString();
    }
	
	/**
	 * 게시판 서브게시판 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/getSubBoards.do", method = RequestMethod.POST)
	@ResponseBody
	public void getSubBoards(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, BoardPropertyVO boardInfo, HttpServletRequest req, HttpServletResponse res) throws Exception {
		logger.debug("getSubBoards started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String pRootBoardID = "";
		String pSubFlag = "";
		int pSelectBy = 0;
		String pExcludeBoardID = " ";
		String isAdminLeft = "";
		String companyID = Optional.ofNullable(req.getParameter("companyID")).orElse(userInfo.getCompanyID());
		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());
		boolean isCompanyAdmin = organAuth.isAuth(AdminAuth.ADMIN_MASTER,"");

		if (req.getParameter("rootBoardID") != null && !req.getParameter("rootBoardID").equals("")) {
			pRootBoardID = req.getParameter("rootBoardID");
		}
		
		if (req.getParameter("subFlag") != null && !req.getParameter("subFlag").equals("")) {
			pSubFlag = req.getParameter("subFlag");
		}
		
		if (req.getParameter("selectFlag") != null && !req.getParameter("selectFlag").equals("")) {
			pSelectBy = Integer.parseInt(req.getParameter("selectFlag"));
		}
		
		if (req.getParameter("pExcludeBoardID") != null && !req.getParameter("pExcludeBoardID").equals("")) {
			pExcludeBoardID = req.getParameter("pExcludeBoardID");
		}
		/* 2018-10-16 홍승비 - 관리자단에서 접근했는지 판단하는 플래그 추가 */
		if (req.getParameter("isAdminLeft") != null && !req.getParameter("isAdminLeft").equals("")) {
			isAdminLeft = req.getParameter("isAdminLeft");
		}

		/* 2019-06-03 홍승비 - 게시판그룹 관리자권한 체크 시 사내겸직 및 하위부서 허용여부 체크하도록 수정 */
		String boardGroupAdmin_FG = checkIfBoardGroupAdmin(pRootBoardID, userInfo);

		int pMode = isCompanyAdmin || organAuth.isAuth(AdminAuth.COMPANY_MANAGER, companyID)
				|| organAuth.isAuth(AdminAuth.BOARD_MANAGER, companyID)
				|| boardGroupAdmin_FG.equals("OK") ? 0 : 1;
		
		/* 2018-10-16 홍승비 - 관리자단에서 접근했는지 판단하는 플래그를 인자로 추가 */
		String strXML = ezBoardService.getBoardTree(pRootBoardID, userInfo.getId(), userInfo.getDeptID(), companyID, pMode, Integer.parseInt(pSubFlag), pSelectBy, pExcludeBoardID,
				commonUtil.getLangData(userInfo.getLang()), isAdminLeft, isCompanyAdmin, boardGroupAdmin_FG, userInfo.getRollInfo(), userInfo.getTenantId());
		
		Document doc = commonUtil.convertStringToDocument(strXML);
		NodeList nList = doc.getElementsByTagName("NODE");
		
		if (!strXML.substring(0, 5).toUpperCase().equals("ERROR")) {
			if (ezCommonService.getTenantConfig("USE_BOARD_LEFTMENU_COUNT", userInfo.getTenantId()).equals("YES")) {
				BoardMyFavoriteVO myFavoriteVO = new BoardMyFavoriteVO();
				int intCount = 0;
				
				if (nList != null) {
					for (int i = 0; i < nList.getLength(); i++) {
						Node node = nList.item(i);
						String boardID = node.getChildNodes().item(2).getTextContent();
						
						myFavoriteVO.setBoardId(boardID);
						myFavoriteVO.setUserId(userInfo.getId());
						myFavoriteVO.setType("1");
						myFavoriteVO.setTenantID(userInfo.getTenantId());
						myFavoriteVO.setNowDate(commonUtil.getTodayUTCTime(""));
						myFavoriteVO.setUseVersion(ezBoardService.getUseVersionFlag(boardID, userInfo.getTenantId()));
						
						if (node.getChildNodes().item(6).getTextContent().equals("4")) {
							intCount = ezBoardService.getThumbNailCount(myFavoriteVO);
						} else if (node.getChildNodes().item(6).getTextContent().equals("5")) {
							boardInfo = getBoardInfo(node.getChildNodes().item(2).getTextContent(), userInfo);
							myFavoriteVO.setBoardAdmin_FG(boardInfo.getBoardAdmin_FG());
							intCount = ezBoardService.getQNABrdTotalItemCount(myFavoriteVO);
						} else {
							intCount = ezBoardService.getBrdTotalItemCount(myFavoriteVO);
						}
						
						String strName = "";
						
						/* 2023-06-28 황인경 - 디자인 개선 > 게시판 > 마이게시판 > 좌측메뉴 > 게시물 카운트 괄호 추가 */
						if (intCount != 0) {
							strName = "(" + intCount + ")";
						}
						
						node.getChildNodes().item(0).setTextContent(node.getChildNodes().item(0).getTextContent() + strName);
					}
				}
			}
		} else {
			doc = commonUtil.convertStringToDocument("<RESULT>ERROR</RESULT>");
		}
		
		String output = commonUtil.convertDocumentToString(doc);
		
		res.setContentType("text/xml"); 
		res.setCharacterEncoding("UTF-8");
		res.setHeader("Cache-Control", "no-cache");
		res.getWriter().write(commonUtil.stripScriptTags(output));
		
		logger.debug("getSubBoards ended");
	}
	
	/**
	 * 게시판 환경설정 순서  표출 Method
	 */
	@RequestMapping(value="/ezBoard/saveListOrder.do", method = RequestMethod.POST)
	@ResponseBody
	public void saveListOrder(@CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("saveListOrder started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String pBoardList = request.getParameter("pBoardList");
		String pDelBoardList = request.getParameter("pDelboardList");
		
		ezBoardService.setListOrder(userInfo, pBoardList, pDelBoardList);

		logger.debug("saveListOrder ended");
	}
	
	/**
	 * 게시판 환경설정 탭 표출 Method
	 */
	@RequestMapping(value="/ezBoard/set_TabUse.do", method = RequestMethod.POST)
	@ResponseBody
	public void set_TabUse(@CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("set_TabUse started");

		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		
		String pUserID = loginVO.getId();
		String pBoardList = request.getParameter("pBoardList");
		String tabUsed = request.getParameter("tabUsed");
		int tenantID = loginVO.getTenantId();
		
		// 즐겨찾기 탭 저장 시 companyID 삽입
		ezBoardService.setTabUsed(pUserID, pBoardList, tabUsed, loginVO.getCompanyID(), tenantID);

		logger.debug("set_TabUse ended");
	}
	
	/**
	 * 게시판 게시물 읽기권한체크 Method
	 */
	public boolean accessCheck(String boardID, String itemID, String boardType, LoginVO userInfo, String password) throws Exception {
		logger.debug("accessCheck started");
		
		/* 2019-05-31 홍승비 - 현재 소속 회사의 사내겸직이 존재하면 사내겸직부서ID와 그 상위부서ID까지 권한체크에 포함하도록 수정 */
		BoardPropertyVO boardProp = ezBoardService.getBoardProperty(boardID, userInfo.getTenantId());
		BoardListVO boardItemVO = ezBoardService.getBrdGetItemInfo(boardID, itemID, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
		String boardGroupID = "";
		String isAllGroupBoard = "N";
		
		// boardType은 일반(GENERAL), 임시(TEMP) 두 개가 존재
		if (boardType == null || boardType.toUpperCase().equals("")) {
			boardType = "GENERAL";
		}
		
		// 임시저장된 게시물의 경우, 기존 getCheckItemID 쿼리를 타도록 유지
		if (boardType.equalsIgnoreCase("TEMP")) {
			int result = ezBoardService.getCheckItemID(itemID, boardType, userInfo.getId(), userInfo.getTenantId(), 0, 0);
			if (result > 0) {
				return true;
			} else {
				return false;
			}
		}
		
		/* 2019-06-10 홍승비 - 게시판그룹의 관리자권한 체크를 위한 쿼리 파라미터 추가(게시판그룹의 관리자권한과 하위게시판의 관리자권한 혼용 방지) */
		boolean isBoardGroup = false;
		if (boardProp.getBoardGroupID() != null) { // 하위게시판
			boardGroupID = boardProp.getBoardGroupID();
			BoardPropertyVO strGroupProp = ezBoardService.getBoardProperty(boardGroupID, userInfo.getTenantId());
			if (strGroupProp.getGuBun() != null && strGroupProp.getGuBun().equals("99")) {
				isAllGroupBoard = "Y";
			}
			isBoardGroup = false;
		} else { // 게시판그룹
			isBoardGroup = true;
		}
		
		String deptPath = userInfo.getDeptPathCode();
		StringBuilder deptPathOrgan = new StringBuilder();
		List<String> addJobDeptList = new ArrayList<String>();
		
		/* 2019-09-24 홍승비 - 개인ID 이후, 부서ID 이전 위치에 직위+직책ID (사내겸직 직위 포함) 추가 */
		String userJJID = ezBoardService.getUserJJID(userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
		
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
		
		//logger.debug("accessCheck userDeptPath in web    ::    " + userDeptPath);
		
		List<String> addJobList = ezBoardService.getPDOAddJobDeptID(userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
		StringJoiner addJobStr = new StringJoiner(",");
		addJobStr.add(userInfo.getDeptID());
		if (addJobList != null && addJobList.size() > 0) {
			for (int i = 0; i < addJobList.size(); i++) {
				addJobStr.add(addJobList.get(i));
				String upperDept = ezBoardService.getUpperDeptID(addJobList.get(i), userInfo.getTenantId());
				
				if (upperDept != null && !upperDept.equals("")) {
					boolean loopContinue = true;
					StringJoiner upperDeptStr = new StringJoiner(",");
					upperDeptStr.add(upperDept);
					
					while (loopContinue) {
						String upperDeptLoop = ezBoardService.getUpperDeptID(upperDept, userInfo.getTenantId());
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
					
					int isDept = ezBoardService.isDeptChk(addJobDeptList.get(jl).split(",")[i].trim(), userInfo.getTenantId());
					
					/* 2019-09-24 홍승비 - 권한그룹을 포함하여 게시판그룹 관리자권한 체크 */
					// 권한그룹 적용 시 개인권한이 다수 존재 가능하므로, 권한을 리스트로 가져온 뒤 '허용(OK)'기준으로 취합한다.
					String boardGroupAdmin_FG_New = "";
					List<String> boardGroupAdmin_FG_List = ezBoardService.checkIfBoardGroupAdminNew(boardID, addJobDeptList.get(jl).split(",")[i].trim(), userInfo.getTenantId(), isDept, isEqualDept, isBoardGroup);
					if (boardGroupAdmin_FG_List != null && boardGroupAdmin_FG_List.size() > 0) { // 권한이 없으면 공백값을 유지 > 다음 루프 진행
						if (boardGroupAdmin_FG_List.contains("OK")) { // 동일한 우선순위의 권한에 대해서, OK가 하나라도 존재한다면 OK로 판정
							boardGroupAdmin_FG_New = "OK";
						} else {
							boardGroupAdmin_FG_New = "NO";
						}
					}
					
					if ((commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(),userInfo.getRollInfo(), "c") || boardGroupAdmin_FG_New.equals("OK")) ||
							(isAllGroupBoard.equals("N") && commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "n;k"))) {
						logger.debug("user has admin roll, accessCheck ended");
						return true;
					} else {
						List<String> resultNewList = new ArrayList<String>();
						boolean resultNew = false;
						
						/* 2019-09-24 홍승비 - 권한그룹 적용하여 읽기권한 '허용' 기준으로 취합을 위해 리스트로 리턴 */
						resultNewList = ezBoardService.getCheckItemIDNew(itemID, boardType, addJobDeptList.get(jl).split(",")[i].trim(), userInfo.getTenantId(), isDept, isEqualDept);
						
						if (resultNewList != null && resultNewList.size() > 0) { // 넘겨준 ACCESSID에  대하여 읽기권한 레코드가 존재
							if (resultNewList.contains("true")) { // 읽기권한 '허용' 기준으로 취합
								resultNew = true;
							} else { // '허용'이 아예 없는 경우 '불가'로 판정
								resultNew = false;
							}
							
							/* 2019-09-24 홍승비 - 읽기권한 체크를 숫자가 아닌 문자열(true/false)로 수정 */
							if (addJobDeptList.get(jl).split(",")[i].equals(userInfo.getId())) { // 개인권한
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
		} // 개인, 직위/직책, 부서권한 전부 존재하지 않는다면 false

		// 2024-11-19 비공개 게시판의경우 관리자와 글쓴이만 접근 가능 - 관리자일경우는 return true 됨
		if (rtv && "N".equals(boardItemVO.getPublicFlag())) {
			// 익명일 경우 비번 체크
			if ("2".equals(boardProp.getGuBun()) || boardItemVO.getWriterID() == null) {
				rtv = ezBoardService.chkPasswordAnonymous(boardItemVO.getItemID(), password, userInfo.getTenantId());
			} else {
				rtv = boardItemVO.getWriterID().equalsIgnoreCase(userInfo.getId());
			}
		}
		
		//logger.debug("accessCheck rtv      ::     " + rtv);
		logger.debug("accessCheck ended");
		return rtv;
    }
	
	/**
	 * 게시판 게시판게시물 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardItemView.do", method = RequestMethod.GET)
	public String getBoardItemView(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo, Model model) throws Exception {
		logger.debug("getBoardItemView started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String extenLang = "1";
		String location = "";
		String useOcs = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId());
		String useEditor = ezCommonService.getTenantConfig("MODULEEDITOR", userInfo.getTenantId());
		String publicModulus = egovFileScrty.getPbm();
		String publicExponent = "10001";
		String scrapContID = request.getParameter("scrapContID");
		String adjacentItemsEnableFlag = ezCommonService.getTenantConfig("ADJACENT_ITEMS_ENABLE", userInfo.getTenantId());
		String showAdjacent = request.getParameter("showAdjacent");
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		String pReservedItem = request.getParameter("pReservedItem");
		//2018.08.08 캐비넷 추가
		String use_cabinet = ezCommonService.getTenantConfig("useCabinet", userInfo.getTenantId());
		if (use_cabinet.equals("YES")) {
			use_cabinet = cabinetAdminService.checkModuleActive("board", userInfo);
		}
		String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", userInfo.getTenantId());
		if (useExternalMailServer == null || useExternalMailServer.equals("")) {
			useExternalMailServer = "NO";
		}
		
		location = request.getParameter("location");
		
		boolean isExistBoardItem = ezBoardService.confirmBoardItemDeletion(boardID, itemID, userInfo.getTenantId());
		
		if (!isExistBoardItem) {
			model.addAttribute("messageContent", egovMessageSource.getMessage("ezMain.delete.hth01", userInfo.getLocale()));
			return "/common/error";
		}

		/* 2018-06-29 홍승비 - 해당 게시물을 작성한 사람의 WriterDeptID(겸직상태로 저장됨)도 함께 가져오도록 함 */
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		BoardListVO boardItem = ezBoardService.getBrdGetItemInfo(boardID, itemID, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
		
		String authorization = request.getHeader("Authorization");
		String password = StringUtils.isNotBlank(authorization) ? new String(java.util.Base64.getDecoder().decode(StringUtils.removeStart(authorization, "Basic").trim())) : "";
		
		if (!accessCheck(boardID, itemID, location, userInfo, password)) {
			return "main/warning";
		}
		
		//KMS 안써서 픽스
		String useEzKMS = "NO";
		String guBun = boardInfo.getGuBun();
		String userId = userInfo.getId();
		String offset = userInfo.getOffset();
		
		if (!boardInfo.getRead_FG().equals("true")) {
			return "main/warning";
		} else if ("5".equals(guBun) && "false".equals(boardInfo.getBoardAdmin_FG())) {
			// 게시관리자가 아닌 사람은 QNA게시판에서 본인이 쓴 게시물과, 본인이 쓴 게시물에 달린 답 게시물, 공지게시물만 볼 수 있음
			if (!userId.equals(boardItem.getWriterID()) && !userId.equals(boardItem.getTopWriterID()) 
					&& !("1".equals(boardItem.getExtensionAttribute2()) && commonUtil.isTodayBetween(boardItem.getNotiStart(), boardItem.getNotiEnd(), offset))) {
				return "main/warning";
			}
		}
		
		//추가항목이 있을 경우 추가항목을 가져온다
		List<BoardAttributeVO> boardAttr = new ArrayList<BoardAttributeVO>();
		
		int boardAttrCount = 0; 
		
		if (boardInfo.getAttributeYN() != null && boardInfo.getAttributeYN().equals("Y")) {
			boardAttr = ezBoardAdminService.getBoardAttribute(boardID, userInfo.getTenantId());
			boardAttrCount = boardAttr.size();
			
			if (!commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId()).equals("1")) {
				extenLang = "2";
			}
		}
		
		if (boardItem == null) {
			return "main/warning";
		}
		
		ezBoardService.setAsRead(userInfo, boardID, itemID);
		
		if (boardItem.getApprFlag() != null && boardItem.getApprFlag().equals("N")) {
			int checkCnt = ezBoardService.getCheckApprUserList(userInfo.getId(), itemID, userInfo.getTenantId());
			
			if (checkCnt == 0) {
				boardItem.setApprFlag("W");
			}
		}
		
		BoardPropertyVO boardPropertyVO = ezBoardService.getBoardProperty(boardID, userInfo.getTenantId());
		
		String nowTime = commonUtil.getTodayUTCTime("");
		String writeTime = boardItem.getWriteDate();
		
		if (EgovDateUtil.getDaysDiff(writeTime.substring(0,10), nowTime.substring(0,10)) < 0) {
			pReservedItem = "true";
		}
		
		boardItem.setWriteDate(commonUtil.getDateStringInUTC(boardItem.getWriteDate(), userInfo.getOffset(), false));
		boardItem.setEndDate(commonUtil.getDateStringInUTC(boardItem.getEndDate(), userInfo.getOffset(), false));
		if (!StringUtils.isBlank(boardItem.getUpdateDate())) {
			boardItem.setUpdateDate(commonUtil.getDateStringInUTC(boardItem.getUpdateDate(), userInfo.getOffset(), false));
		}
		
		/* 2019-12-23 홍승비 - 게시만료일을 메세지로 치환하여 전달하는 부분 주석처리 (jsp단에서 영구게시 메세지 분기처리하므로) */
/*		if (boardItem.getEndDate() != null && boardItem.getEndDate().substring(0, 4).equals("9999")) {
			boardItem.setEndDate(egovMessageSource.getMessage("ezBoard.t287", userInfo.getLocale()));
		}*/
		
		BoardVO adjacentItem = new BoardVO();
		if (adjacentItemsEnableFlag != null && showAdjacent != null && adjacentItemsEnableFlag.equals("1") && showAdjacent.equals("1")) {
			if (boardItem.getUpperItemIDTree() == null || boardItem.getUpperItemIDTree().equals("") ) {
				boardItem.setUpperItemIDTree(itemID);
			}
			
			if (!guBun.equals("3")) {
				adjacentItem = getAdjacentItems(itemID, boardID, boardItem.getUpperItemIDTree(), boardItem.getParentWriteDate(), userInfo.getTenantId());
			} else {
				adjacentItem = getAdjacentItemsPhoto(itemID, boardID, boardItem.getUpperItemIDTree(), boardItem.getParentWriteDate(), userInfo.getTenantId());
			}
			
			if (adjacentItem.getPreviousTitle().equals("")) {
				adjacentItem.setPreviousTitle(egovMessageSource.getMessage("ezBoard.t330", userInfo.getLocale()));
			}
			
			if (adjacentItem.getNextTitle().equals("")) {
				adjacentItem.setNextTitle(egovMessageSource.getMessage("ezBoard.t331", userInfo.getLocale()));
			}
		}
		
		if (boardInfo.getBoardName() != null && !boardInfo.getBoardName().equals("")) {
			boardInfo.setBoardName(commonUtil.cleanValue(boardInfo.getBoardName()));
		}
		
		if (boardInfo.getBoardName1() != null && !boardInfo.getBoardName1().equals("")) {
			boardInfo.setBoardName1(commonUtil.cleanValue(boardInfo.getBoardName1()));
		}
		
		if (boardInfo.getBoardName2() != null && !boardInfo.getBoardName2().equals("")) {
			boardInfo.setBoardName2(commonUtil.cleanValue(boardInfo.getBoardName2()));
		}
		// 2017.12.29 강민수92 댓글 갯수 구하기
		if (boardPropertyVO.getOneLineReply() != null && !boardPropertyVO.getOneLineReply().equals("") && !boardPropertyVO.getOneLineReply().equals("0")) {
			String commentCount = ezBoardService.getOneLineReplyCount(boardID, itemID, userInfo.getTenantId());
			model.addAttribute("commentCount", commentCount);
		}
		
		/* 2019-01-31 홍승비 - 게시물 보기 시 게시자 이름 특문처리 (익명게시판 오류수정) */
		if (boardItem.getWriterName() != null && !boardItem.getWriterName().equals("")) {
			boardItem.setWriterName(commonUtil.htmlUnescape(boardItem.getWriterName()).replace("\\", "&#92;"));
		}
		
		/* 2019-04-05 홍승비 - 해당 게시물에 대해 사용자가 좋아요를 표시했는지 체크 */
		String isLikeChecked = ezBoardService.likeCheck(userInfo.getId(), itemID, userInfo.getTenantId());
		
		// 2023-05-25 조수빈 - 게시판 첨부파일 미리보기 기능 사용 여부
		String useBoardFilePrvw = ezCommonService.getTenantConfig("useBoardFilePrvw", userInfo.getTenantId());
		// 2023-10-26 조수빈 - 문서변환 솔루션 사용 여부
		String useImageConvertServer = ezCommonService.getTenantConfig("useImageConvertServer", userInfo.getTenantId());
		
		if (useBoardFilePrvw.equals("1") && useImageConvertServer.equals("1")) {
			useBoardFilePrvw = "1";
		} else {
			useBoardFilePrvw = "0";
		}

		String version = request.getParameter("version") == null ? "" : request.getParameter("version");
		
		// 2024-08-14 전인하 - 게시판 > json data 이용 시 문제가 되는 특정 특수문자 이스케이프 추가 
		JsonSerializer<String> stringSerializer = new JsonSerializer<String>() {
			@Override
			public JsonElement serialize(String src, Type typeOfSrc, JsonSerializationContext context) {
				String escapedString = src.replace("\\", "\\\\")
											.replace("\"", "\\\"")
											.replace("/", "\\/");
						
				return new JsonPrimitive(escapedString);
			}
		};

		Gson gson = new GsonBuilder().registerTypeAdapter(String.class, stringSerializer).create();
		String boardAttrJson = gson.toJson(boardAttr);
		String boardItemJson = gson.toJson(boardItem);
		 		
		/* 2023-03-20 기민혁 - 해당 게시물에 대해 사용자가 싫어요를 표시했는지 체크 */
		String isDisLikeChecked = ezBoardService.disLikeCheck(userInfo.getId(), itemID, userInfo.getTenantId());
		
		List<BoardKeywordVO> keywordList = new ArrayList<>();
		if (boardInfo.getUseKeyword() != null && boardInfo.getUseKeyword().equals("Y")) {
			keywordList = ezBoardService.selectBoardKeywordByBoardItem(boardItem.getItemID(), boardItem.getBoardID(), userInfo.getTenantId());
		}

		String useVersion = ezBoardService.getUseVersionFlag(boardID, userInfo.getTenantId());
		
		/* 2023-05-03 기민혁 - 해당 게시물에 대해 사용자가 스크랩을 했는지 체크 */
		String isScrap = ezBoardService.getScrapItemCount(userInfo.getId(), itemID, boardID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		// 2024-10-07 이혜림 - 게시판 > 별점 평가하기 조회
		Map<String, Object> itemStarRating = ezBoardService.getItemStarRating(itemID, userInfo.getId(), userInfo.getTenantId());

		/* 게시판 환경설정 > 본문크기설정값 적용 */
		BoardConfigVO boardConfig = ezBoardService.getBoardList_Config(userInfo.getId(), userInfo.getTenantId());
		int contentSize = 100; // 기본값
		double mozContentSize = 1; // 기본값

		if (boardConfig != null) { // 사용자 설정값
			for (int i = 1; i <= 10; i++) {
				if (boardConfig.getContentSize() == i) {
					contentSize = 100 + (i * 10);
					mozContentSize = 1 + (i * 0.1);
					break;
				}
			}
		}
		
		// ai 관련 컨피그 추가
		// AI 첨부파일 이름 최대 길이 - 기존 첨부파일과 동일한 값 사용
		String attachFileNameMaxLength = ezCommonService.getTenantConfig("attachFileNameMaxLength", userInfo.getTenantId());
		// AI 사용여부 확인
		boolean useAI = aICommonUtil.checkUseAI(userInfo.getTenantId());
		// AI 챗봇 첨부파일 최대용량
		String aiAttachMBSize = ezCommonService.getTenantConfig("aiAttachMBSize", userInfo.getTenantId());
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("boardItem", boardItem);
		model.addAttribute("boardItemJson", boardItemJson);
		model.addAttribute("boardAttr", boardAttr);
		model.addAttribute("boardAttrJson", boardAttrJson);
		model.addAttribute("boardAttrCount", boardAttrCount);
		model.addAttribute("adjacentItem", adjacentItem);
		model.addAttribute("boardPropertyVO", boardPropertyVO);
		model.addAttribute("apprFlag", boardItem.getApprFlag());
		model.addAttribute("extenLang", extenLang);
		model.addAttribute("location", location);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("adjacentItemsEnableFlag", adjacentItemsEnableFlag);
		model.addAttribute("showAdjacent", showAdjacent);
		model.addAttribute("boardID", boardID);
		model.addAttribute("itemID", itemID);
		model.addAttribute("pReservedItem", pReservedItem);
		model.addAttribute("useEzKMS", useEzKMS);
		model.addAttribute("guBun", guBun);
		model.addAttribute("publicModulus", publicModulus);
		model.addAttribute("publicExponent", publicExponent);
		model.addAttribute("isLikeChecked", isLikeChecked);
		model.addAttribute("useCabinet", use_cabinet);
		model.addAttribute("useExternalMailServer", useExternalMailServer);
		model.addAttribute("useBoardFilePrvw", useBoardFilePrvw);
		model.addAttribute("isDisLikeChecked", isDisLikeChecked);
		model.addAttribute("keywordList", keywordList);
		model.addAttribute("isScrap", isScrap);
		model.addAttribute("MyBoardScrapFlag", ezCommonService.getTenantConfig("MyBoardScrapFlag", userInfo.getTenantId()));
		model.addAttribute("scrapContID", scrapContID);
		model.addAttribute("attachFileNameMaxLength", ezCommonService.getTenantConfig("attachFileNameMaxLength", userInfo.getTenantId()));
		model.addAttribute("itemStarRating", itemStarRating);
		model.addAttribute("moduleType", "board");
		model.addAttribute("moduleSubType", "view");
		model.addAttribute("useAI", useAI);
		model.addAttribute("attachFileNameMaxLength", attachFileNameMaxLength);
		model.addAttribute("aiAttachMBSize", aiAttachMBSize);
		model.addAttribute("useVersion", useVersion);
		model.addAttribute("historyCheck", request.getParameter("historyCheck"));
		model.addAttribute("leftAddr", request.getParameter("leftAddr"));
		model.addAttribute("rightAddr", request.getParameter("rightAddr"));
		model.addAttribute("selectedAddr", request.getParameter("selectedAddr"));
		model.addAttribute("selectedViewFlag", request.getParameter("selectedViewFlag"));
		model.addAttribute("historyModify", request.getParameter("historyModify") == null ? "false" : request.getParameter("historyModify"));
		model.addAttribute("version", version);
		model.addAttribute("newestVersionFlag", ezBoardService.checkIsNewestVersion(boardID, itemID, userInfo.getTenantId(), version));
		model.addAttribute("contentSize", contentSize);
		model.addAttribute("mozContentSize", mozContentSize);
		
		logger.debug("getBoardItemView ended");
        return "ezBoard/boardItemView";
    }
	
	/**
	 * 게시판 읽음표시 실행 Method
	 */
	@RequestMapping(value="/ezBoard/setRead.do", method = RequestMethod.POST)
	@ResponseBody
	public void setAsRead(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, LoginVO userInfo) throws Exception {
		logger.debug("setAsRead started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String pBoardID = "";
		String pItemIDList = "";
		
		if (request.getParameter("boardID") != null) {
			pBoardID = request.getParameter("boardID");
		}
		
		if (request.getParameter("itemIDList") != null) {
			pItemIDList = request.getParameter("itemIDList");
		}
		
		String[] itemIDs = pItemIDList.split(";");
		
		for (int k = 0; k < itemIDs.length; k++) {
			ezBoardService.setAsRead(userInfo, pBoardID, itemIDs[k]);
		}

		logger.debug("setAsRead ended");
	}
	/**
	 * 게시판 읽음표시 실행 // 새게시물 전용
	 */
	@RequestMapping(value="/ezBoard/setReadNew.do", method = RequestMethod.POST)
	@ResponseBody
	public void setAsReadNew(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, LoginVO userInfo) throws Exception {
		logger.debug("setAsReadNew started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String pBoardIDList = "";
		String pItemIDList = "";
		
		if (request.getParameter("pBoardIDList") != null) {
			pBoardIDList = request.getParameter("pBoardIDList");
		}
		
		if (request.getParameter("itemIDList") != null) {
			pItemIDList = request.getParameter("itemIDList");
		}
		
		String[] boardIDs = pBoardIDList.split(";");
		String[] itemIDs = pItemIDList.split(";");
		
		/* 2019-07-04 홍승비 - 새게시물의 게시판ID를 읽음표시 기능에서 사용하지 않도록 수정 */
		for (int k = 0; k < itemIDs.length; k++) {
			ezBoardService.setAsRead(userInfo, boardIDs[k], itemIDs[k]);
		}

		logger.debug("setAsReadNew ended");
	}
	
	/**
	 * 게시판 새게시물,임시게시물게시하기 호출 Method
	 */
	@RequestMapping(value = {"/ezBoard/boardNewItem.do", "/ezBoard/boardNewItemTempPhoto.do", "/ezBoard/boardNewItemTempMovie.do"}, method = RequestMethod.GET)
	public String newBoardItem(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo, BoardListVO boardListVO, Model model) throws Exception {
		logger.debug("newBoardItem started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String extenLang = "1";
		String editor = ezCommonService.getTenantConfig("MODULEEDITOR", userInfo.getTenantId());
		String uploadFilePath = commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId());
		String publicModulus = egovFileScrty.getPbm();
		String publicExponent = "10001";
		String mode = "";
		String boardID = "";
		String itemID = "";
		String url = "";
		String hasAttach = "";
		String strWriterFakeName = "";
		String reservedItem = "";
		String checkForm = "";
		String useBackGround = "";
		String docID = "";
		String boardType = "";
		String requestURL = (String) request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);
		String browser = ClientUtil.getClientInfo(request, "browser");
		String orgCompanyID = request.getParameter("orgCompanyID");
		/* 2024-05-21 김유진 - 일정 > 게시판 게시에 사용 */
		String scheduleId = request.getParameter("scheduleId") != null ? request.getParameter("scheduleId") : "";
		boolean isCrossBrowser = browser.equals("IE9") ? false : true;
		String companyID = userInfo.getCompanyID();
		int tenantID = userInfo.getTenantId();
		
		requestURL = requestURL.substring(1, requestURL.length() - 3);
		
		if (request.getParameter("mode") != null) {
			mode = request.getParameter("mode");
		}
		
		if (boardListVO.getBoardID() != null) {
			boardID = boardListVO.getBoardID();
		}
		
		if (boardListVO.getItemID() != null) {
			itemID = boardListVO.getItemID();
		}
		
		if (request.getParameter("url") != null) {
			url = request.getParameter("url");
		}
		
		if (request.getParameter("bType") != null) {
			boardType = request.getParameter("bType");
		}
		
		if (request.getParameter("docID") != null) {
			docID = request.getParameter("docID");
		}
		
		if (request.getParameter("reservedItem") != null) {
			reservedItem = request.getParameter("reservedItem");
		}
		
		if (orgCompanyID == null) {
			orgCompanyID = "";
		}
		
		String newGuid = UUID.randomUUID().toString();
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		
		if (boardInfo.getWrite_FG() != null && boardInfo.getWrite_FG().equals("false")) {
			return "main/warning";
		}
		
		String guBun = boardInfo.getGuBun();
		String paramGuBun = request.getParameter("gubun");
		boolean isTempPhoto = requestURL.contains("TempPhoto");
		boolean isTempMovie = requestURL.contains("TempMovie");
		
		// 포토, 썸네일, 동영상 타입의 게시판이면서 게시하기 호출 url은 일반 게시판으로 들어왔을 때,
		// 리스트 페이지에서 넘겨받은 게시판타입과 DB에서 받은 게시판타입이 상이할 때,
		// 관리자페이지에서 게시판 타입이 변경된 것으로 그룹웨어 새로고침을 요구함
		if ((!Arrays.asList("3", "4", "7").contains(guBun) && (isTempPhoto || isTempMovie)) ||
			(StringUtils.isNotEmpty(paramGuBun) && !guBun.equals(paramGuBun)) ) {
			model.addAttribute("gubunExchanged", "Y");
			return "main/warning_board";
		}
		
		//추가 항목 가져오는 소스 
		List<BoardAttributeVO> boardAttributeListVO = new ArrayList<BoardAttributeVO>();
		if (boardInfo.getAttributeYN() != null && boardInfo.getAttributeYN().equals("Y")) {
			boardAttributeListVO = ezBoardAdminService.getBoardAttribute(boardID, userInfo.getTenantId());
			if (!commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId()).equals("1")) {
				extenLang = "2";
			}
			/* 2021-04-26 홍승비 - 확장칼럼의 COLNAME, VALUE에 대한 ', "문자 파싱 추가 (jsp단에서 추가 파싱 없이 value 속성으로 쓰기 위해)*/
			for (int i = 0; i < boardAttributeListVO.size(); i++) {
				String tempValue = boardAttributeListVO.get(i).getValue();
				String tempColName1 = boardAttributeListVO.get(i).getColName1();
				String tempColName2 = boardAttributeListVO.get(i).getColName2();
				boardAttributeListVO.get(i).setColName1(tempColName1.replaceAll("\'", "&#039;").replaceAll("\"", "&#034;"));
				boardAttributeListVO.get(i).setColName2(tempColName2.replaceAll("\'", "&#039;").replaceAll("\"", "&#034;"));
				boardAttributeListVO.get(i).setValue(tempValue.replaceAll("\'", "&#039;").replaceAll("\"", "&#034;"));
			}
		}
		
		String startDateTime = "";
		String endDateTime = "";
		String expireDays = "";
		String expireItem = "";
		String strTitle = "";
		String today = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
		
		/* 2021-12-22 홍승비 - 전자결재문서를 게시하는 경우(new1), 일반적인 신규 게시물 등록 동작(new)과 게시만료일이 동일하게 유지되도록 수정 */
		expireDays = boardInfo.getExpireDays();
		if (!mode.equals("new") && !mode.equals("new1")) {
			if (!mode.equals("temp")) {
				boardListVO = ezBoardService.getBrdGetItemInfo(boardID, itemID, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
			} else {
				boardListVO = ezBoardService.getBrdGetItemInfoTemp(boardID, itemID, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
			}
			
			if (mode.equals("modify") && !boardListVO.getGuBun().equals("2")) {
				/* 2020-12-11 홍승비 - URL 변조하여 임의의 게시물 수정 가능한 취약점 수정 */
				// 게시물과 게시판의 boardID 정보가 서로 맞지 않는 경우 오류 페이지 리턴
				if (boardListVO.getBoardID() == null || boardID == null || !boardListVO.getBoardID().equals(boardID)) {
					return "main/warning";
				}
				// 해당 게시판에 관리자 권한이 없으면서 다른 사용자의 게시물을 수정하려는 경우 오류 페이지 리턴
				/* 2025-01-21 임정은 - 부서명으로 작성된 게시물의 경우(writerNameType이 1인 경우) 사용자의 deptID와 게시물의 writerDeptID를 비교 */
				else if ((boardInfo.getBoardAdmin_FG() == null || (boardInfo.getBoardAdmin_FG() != null && boardInfo.getBoardAdmin_FG().equals("false")))
						&& !boardListVO.getWriterID().equals(userInfo.getId())
						&& !("1".equals(boardListVO.getWriterNameType()) && boardListVO.getWriterDeptID().equals(userInfo.getDeptID()))
				) {
					return "main/warning";
				}
			}
			
			boardListVO.setWriteDate(commonUtil.getDateStringInUTC(boardListVO.getWriteDate(), userInfo.getOffset(), false));
			boardListVO.setNotiStart(commonUtil.getDateStringInUTC(boardListVO.getNotiStart(), userInfo.getOffset(), false));
			boardListVO.setNotiEnd(commonUtil.getDateStringInUTC(boardListVO.getNotiEnd(), userInfo.getOffset(), false));
			
			if (mode.equals("reply")) {
				boardListVO.setItemLevel(String.valueOf((Integer.parseInt(boardListVO.getItemLevel()) + 1)));
				boardListVO.setABSTRACT("");
			}
			
			if (Integer.parseInt(boardListVO.getAttachments()) > 0) {
				hasAttach = "YES";
			}
		}
		startDateTime = today;
		
		if (mode.equals("modify") || mode.equals("temp")) {
			if (boardListVO.getEndDate().substring(0, 4).equals("9999")) {
				expireItem = "YES";
				if (expireDays.equals("-1")) {
					endDateTime = "9999-12-31";
				} else {
					endDateTime = EgovDateUtil.addDay(today, Integer.parseInt(expireDays), "yyyy-MM-dd");
				}
			} else {
				//boardListVO.setEndDate(commonUtil.getDateStringInUTC(boardListVO.getEndDate(), userInfo.getOffset(), false));
				//endDateTime = commonUtil.getDateStringInUTC(boardListVO.getEndDate(), userInfo.getOffset(), false).split(" ")[0];
				//2017-12-01 게시글 만료일을 지정하고, 그 만료일보다 더 늦은 날짜를 지정할 수 있게 하기 위해 수정
				endDateTime = "9999-12-31";
			}
			
			startDateTime = commonUtil.getDateStringInUTC(boardListVO.getStartDate(), userInfo.getOffset(), false);
		} else {
			if (expireDays.equals("-1")) {
				endDateTime = "9999-12-31";
			} else {
				endDateTime = EgovDateUtil.addDay(today, Integer.parseInt(expireDays), "yyyy-MM-dd");
			}
		}
		
		if (boardInfo.getGuBun().equals("2")) {
			strWriterFakeName = boardListVO.getWriterName();
			if (strWriterFakeName != null) {
				strWriterFakeName = strWriterFakeName.replace("\\", "&#92;");
			}
		}

		String defaultFontAndSize = "style='font-size:13px;font-family:" + egovMessageSource.getMessage("main.t246", userInfo.getLocale()) + "'";
		
		//사용자 언어가 한국어이고 editorFontStyle값이 있을 경우 editorFontStyle값 적용
		if (userInfo.getLang().equals("1")) {
			String editorFontStyle = ezCommonService.getTenantConfig("editorFontStyle", userInfo.getTenantId());
			
			if (!editorFontStyle.equals("")) {
				String fontFamily = editorFontStyle.split("\\|")[0];
				String fontSize = editorFontStyle.split("\\|")[1];
				
				defaultFontAndSize = "style='font-size:" + fontSize + ";font-family:" + fontFamily + "'";
			}
		}
		
		ZoneId utc = ZoneId.ofOffset("UTC", ZoneOffset.of(userInfo.getOffset().split("\\|")[1]));
		ZonedDateTime getTime = ZonedDateTime.of(LocalDateTime.now(utc), utc);
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH");
		
		if (getTime.getMinute() > 30) {
			getTime = getTime.plusHours(1);
			startDateTime = getTime.format(formatter);
			startDateTime = startDateTime + ":00:00"; 
		} else {
			startDateTime = getTime.format(formatter);
			startDateTime = startDateTime + ":30:00"; 
		}
		
		/* 2019-12-02 홍승비 - 임시저장된 게시물 재작성 시 예약게시물 판단 분기 추가 */
		if (mode.equals("temp") && boardListVO.getIsReserved().equals("true")) {
			reservedItem = "true";
		}
		
		if (reservedItem.equals("true")) {
			startDateTime = commonUtil.getDateStringInUTC(boardListVO.getStartDate(), userInfo.getOffset(), false);
		}
		
		checkForm = ezBoardService.checkForm(boardID, "Y", userInfo.getTenantId());
		useBackGround = ezBoardService.checkBackGroundImage(boardID, userInfo.getTenantId());
		
		// 2024-08-22 조소정 - 게시판 리스트 호출 시 게시판 이름 사용자 설정 언어로 표출
		String userLang = userInfo.getLang();		
		String boardName = boardInfo.getBoardName(); // 기본값은 한국어로 설정

		if (userLang.equals("2") && boardInfo.getBoardName2() != null && !boardInfo.getBoardName2().isEmpty()) {
			boardName = boardInfo.getBoardName2();
		} else if (userLang.equals("3") && boardInfo.getBoardName3() != null && !boardInfo.getBoardName3().isEmpty()) {
			boardName = boardInfo.getBoardName3();
		} else if (userLang.equals("4") && boardInfo.getBoardName4() != null && !boardInfo.getBoardName4().isEmpty()) {
			boardName = boardInfo.getBoardName4();
		}
		
		if (boardListVO.getTitle() != null && !boardListVO.getTitle().equals("")) {
			boardListVO.setTitle(boardListVO.getTitle().replace("\\", "&#92;"));
		}
		/* 2018-04-27 홍승비 - 게시요약의 \문자 변환 */ 
		if (boardListVO.getABSTRACT() != null && !boardListVO.getABSTRACT().equals("")) {
			boardListVO.setABSTRACT(boardListVO.getABSTRACT().replace("\\", "&#92;"));
		}
		
		/* 2018-07-09 홍승비 - 임시저장 게시물 더블클릭 시 조회한 것으로 확인되지 않는 현상 수정 */
		if (mode.equals("temp")) {
			ezBoardService.setAsRead(userInfo, boardID, itemID);
		}
		
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());
		
		if (useSharedMailbox.equals("YES")) {
			model.addAttribute("mailShareId", request.getParameter("mailShareId"));
		}
		
		/* 2019-08-06 홍승비 - 포토/썸네일/동영상 게시물 작성 시 작성자 이름 다국어 처리(임시보관함) */
		String displayName = "";
		if (userInfo.getPrimary().equals("1")) {
			displayName = userInfo.getDisplayName1();
		} else {
			displayName = userInfo.getDisplayName2();
		}
		
		String deptName = "";
		if (userInfo.getPrimary().equals("1")) {
			deptName = userInfo.getDeptName1();
		} else {
			deptName = userInfo.getDeptName2();
		}
		
		String useHwpDownSecurity = ezCommonService.getTenantConfig("useHwpDownSecurity", userInfo.getTenantId());
		String webHWPUrl = ezCommonService.getTenantConfig("webHWPUrl", userInfo.getTenantId());
		String HwpSecurityNum = "";
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		
		/* 2023-05-17 김우철 - 한글문서 배포(수정 및 복사 제한)를 위한 배포용 암호 설정 테넌트 컨피그로 추가 */
		if (useHwpDownSecurity.equals("Y") && approvalFlag.equals("G")) {
			HwpSecurityNum = ezCommonService.getTenantConfig("HwpSecurityNum", userInfo.getTenantId());
		}
		
		String useKeyword = boardInfo.getUseKeyword();
		List<BoardKeywordVO> keywordListForModify = new ArrayList<>();
		if ((mode.equals("modify") || mode.equals("temp")) && useKeyword != null && useKeyword.equals("Y")) {
			keywordListForModify = ezBoardService.selectBoardKeywordByBoardItem(itemID, boardID, userInfo.getTenantId());
		}
		
		if (mode.equals("reply")) { // 답변 시 writerNameType 리셋
			boardListVO.setWriterNameType("0");
		}
		
		// 버전관리 사용 여부
		String useVersion = ezBoardService.getUseVersionFlag(boardID, tenantID);
		
		if (useVersion.equals("Y")) {
			String newestVersion = "";
			if (!mode.equals("reply")) {
				newestVersion = ezBoardService.getItemVersion(itemID, companyID, tenantID);
			}
			
			model.addAttribute("newestVersion", newestVersion);
			
			if (!itemID.isEmpty() && !mode.equals("reply")) {
				model.addAttribute("parentItemID", ezBoardService.getParentItemID(itemID, companyID, tenantID));
			}
		}
		
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("boardListVO", boardListVO);
		model.addAttribute("boardAttributeListVO", boardAttributeListVO);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("extenLang", extenLang);
		model.addAttribute("editor", editor);
		model.addAttribute("uploadFilePath", uploadFilePath);
		model.addAttribute("mode", mode);
		model.addAttribute("boardID", boardID);
		model.addAttribute("itemID", itemID);
		model.addAttribute("url", url);
		model.addAttribute("hasAttach", hasAttach);
		model.addAttribute("strWriterFakeName", strWriterFakeName);
		model.addAttribute("reservedItem", reservedItem);
		model.addAttribute("checkForm", checkForm);
		model.addAttribute("useBackGround", useBackGround);
		model.addAttribute("strNow", today);
		model.addAttribute("startDateTime", startDateTime);
		model.addAttribute("endDateTime", endDateTime);
		model.addAttribute("expireDays", expireDays);
		model.addAttribute("expireItem", expireItem);
		model.addAttribute("strTitle", strTitle);
		model.addAttribute("newGuid", newGuid);
		model.addAttribute("docID", docID);
		model.addAttribute("boardType", boardType);
		model.addAttribute("publicModulus", publicModulus);
		model.addAttribute("publicExponent", publicExponent);
		model.addAttribute("isCrossBrowser", isCrossBrowser);
		model.addAttribute("defaultFontAndSize", defaultFontAndSize);
		model.addAttribute("orgCompanyID", orgCompanyID);
		model.addAttribute("displayName", displayName);
		model.addAttribute("deptName", deptName);
		model.addAttribute("useHwpDownSecurity", useHwpDownSecurity);
		model.addAttribute("webHWPUrl", webHWPUrl);
		model.addAttribute("HwpSecurityNum", HwpSecurityNum);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("useHWP", ezCommonService.getTenantConfig("useHWP", userInfo.getTenantId()));
		model.addAttribute("scheduleId", scheduleId);
		model.addAttribute("boardName", boardName);
		model.addAttribute("useKeyword", useKeyword);
		model.addAttribute("keywordListForModify", keywordListForModify);
		if ("Y".equals(boardInfo.getWriterFlag())) {
			model.addAttribute("writerOption", ezBoardService.getWriterOption(userInfo));
		}
		model.addAttribute("useVersion", useVersion);
		model.addAttribute("historyModify", request.getParameter("historyModify") == null ? "false" : request.getParameter("historyModify"));
		String version = "";
		if (!mode.equals("reply")) {
			version = request.getParameter("version") == null ? "" : request.getParameter("version");
		}
		model.addAttribute("version", version);
		model.addAttribute("boardNoticePeriod", ezCommonService.getTenantConfig("boardNoticePeriod", userInfo.getTenantId()));
		
		logger.debug("newBoardItem ended");
		return requestURL;
	}
	
	/**
	 * 게시판 draganddrop 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/dragAndDrop.do", method = RequestMethod.GET)
	public String dragAndDrop(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("dragAndDrop started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String attachFileNameMaxLength = ezCommonService.getTenantConfig("attachFileNameMaxLength", userInfo.getTenantId());
		
		if (attachFileNameMaxLength.equals("")) {
			attachFileNameMaxLength = "100";
		}
		
		model.addAttribute("userInfo",userInfo);
		model.addAttribute("attachFileNameMaxLength", attachFileNameMaxLength);
		
		logger.debug("dragAndDrop ended");
		return "ezBoard/boardDragAndDrop";
	}
	
	/**
	 * 게시판 게시물저장 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/saveItem.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String saveItem(@CookieValue("loginCookie") String loginCookie, @RequestBody String xmlData, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("saveItem started.");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String prm = egovFileScrty.getPrm();
    	String pre = egovFileScrty.getPre();
		String pMode = "";
        String gubun = "";
        String realPath = commonUtil.getRealPath(request);
        
        if (request.getParameter("mode") != null) {
        	pMode = request.getParameter("mode");
        }
        
        if (request.getParameter("guBun") != null) {
        	gubun = request.getParameter("guBun");
        }
        
        Document doc = commonUtil.convertStringToDocument(xmlData.toString());
		BoardPropertyVO boardInfo = getBoardInfo(doc.getElementsByTagName("BOARDID").item(0).getTextContent(), userInfo);
		
    	if (gubun.equals("2")) {
    		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
    		String rpwd = EgovFileScrty.decryptRsa(pk, doc.getElementsByTagName("DOCPASSWORD").item(0).getTextContent());
    		
    		doc.getElementsByTagName("DOCPASSWORD").item(0).setTextContent(EgovFileScrty.encryptPassword(rpwd, "unknown"));
    	} else if ("9".equals(gubun) && !"temp".equals(pMode) && !"modify".equals(pMode)) { // 2025-05-29 양지혜 - 파일뷰어게시판 > 글 중복 등록 체크 추가
			String boardID = doc.getElementsByTagName("BOARDID").item(0).getTextContent();
			String parentItemID = doc.getElementsByTagName("parentItemID").item(0).getTextContent();
			if (ezBoardService.isPostDuplicated(boardInfo.getVersionManage(), boardID, parentItemID, userInfo.getTenantId())) {
				return 	"<RESULT>DUPLICATED</RESULT>";
			}
		}
        
        if (boardInfo.getWrite_FG().equals("false")) {
            return "<RESULT>INACCESSIBLE</RESULT>";
        }
		
		if (!boardInfo.getGuBun().equals(gubun)) {
			return 	"<RESULT>GUBUNCHANGED</RESULT>";
		}

        String ret = ezBoardService.insertNewItem(doc, pMode, realPath, userInfo);
        
        logger.debug("saveItem ended. ret=" + ret);
        
        return "<RESULT>" + ret + "</RESULT>";
	}

	/**
	 * 게시판 게시물첨부 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/uploadItemAttach.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String uploadItemAttach(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("uploadItemAttach started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		List<MultipartFile> multiFile = request.getFiles("fileToUpload"); 
		
		int cnt = multiFile.size();
		String realPath = commonUtil.getRealPath(request);
		String[] pFileName = new String[cnt];
		Long[] fileSize = new Long[cnt];
		String[] fileLocation = new String[cnt];
		String[] resultUpload = new String[cnt];
		String[] sGUID = new String[cnt];
		String[] sFileTitle = new String[cnt];
		String[] sExt = new String[cnt];
		String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", userInfo.getTenantId());
		
		if (cnt == 0) {
			return "";
		}
		
		long maxSize = 0;
		String pBoardID = "";
		String pMode = "";
		maxSize = Long.parseLong(request.getParameter("maxSize"));
		pBoardID = request.getParameter("boardID");
		pMode = request.getParameter("mode");
		
		if (StringUtils.isNotEmpty(multiFile.get(0).getOriginalFilename()) && StringUtils.isNotBlank(multiFile.get(0).getOriginalFilename())) {
			for (int i = 0; i < cnt; i++) {
				String _pFileName = multiFile.get(i).getOriginalFilename();
				
				if (_pFileName.indexOf(commonUtil.separator) > 0) {
					_pFileName = _pFileName.split("/")[_pFileName.split("/").length - 1];
				}
				pFileName[i] = _pFileName;
			}
		}
		
		String pDirPath = commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId());
		pDirPath = realPath + pDirPath;
		
		if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
			pDirPath = pDirPath + commonUtil.separator;
		}
		
		File file = new File(commonUtil.detectPathTraversal(pDirPath));
		File file2 = new File(commonUtil.detectPathTraversal(pDirPath + pBoardID + commonUtil.separator + "uploadFile"));
		
		if (!file.exists()) {
			file.mkdirs();
			file2.mkdirs();
		}
		
		if (multiFile.get(0).getOriginalFilename() != null && StringUtils.isNotBlank(multiFile.get(0).getOriginalFilename())){
			boolean isEmpty = false;
			String _pFileName = "";

			// 파일명과 확장자를 구한다.
			for (int i = 0; i < cnt; i++) {
				_pFileName = multiFile.get(i).getOriginalFilename();

				// 폴더 경로를 제외한 파일명만을 구한다.
				if (_pFileName.indexOf(commonUtil.separator) > 0) {
					_pFileName = _pFileName.split(commonUtil.separator)[_pFileName.split(commonUtil.separator).length - 1];
				}

				pFileName[i] = _pFileName;

				// 파일 확장자를 구한다.
				if (pFileName[i].lastIndexOf(".") > -1) {
					sFileTitle[i] = pFileName[i].substring(0, pFileName[i].lastIndexOf("."));
					sExt[i] = pFileName[i].substring(pFileName[i].lastIndexOf(".") + 1);
				} else {
					sFileTitle[i] = pFileName[i];
					sExt[i] = "";
				}
				
				if (multiFile.get(i).getSize() == 0) {
					isEmpty = true;
				}
			}
			
			if (isEmpty) {
				return "OVERFLOW";
			}
		}
		
		for (int i = 0; i < cnt; i++) {
			resultUpload[i] = "false";
			sGUID[i] = UUID.randomUUID().toString() + "." + sExt[i];
		}
		
		for (int i = 0; i < cnt; i++) {
			fileSize[i] = multiFile.get(i).getSize();
			
			if (fileSize[i] > maxSize) {
				resultUpload[i] = "overflow";
			} else {
				if (pMode.equals("ATT")) {
					// dhlee : 20220527 - 파일 업로드 시 .으로 끝나는 파일(예: .jsp.)이 무조건 업로드 허용되는 문제 수정
					String extStr = pFileName[i].substring(pFileName[i].lastIndexOf(".") + 1).toString().toLowerCase();

					if ((extStr.isEmpty() || useExtension.toLowerCase().indexOf(extStr) == -1) && !useExtension.equals("*")) {
						resultUpload[i] = "denied";
					} else {
						String pAttachPath = realPath + commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", userInfo.getTenantId()) + commonUtil.separator;
						File fTemp = new File(pAttachPath, sGUID[i]);
						
						if (!file.exists()) {
							fTemp.mkdirs();
						}
						
						writeUploadedFile(multiFile.get(i), sGUID[i], pAttachPath);
						
						fileLocation[i] = commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", userInfo.getTenantId()) + commonUtil.separator + sGUID[i];
						resultUpload[i] = "true";
					}
				}
			}
		}
		
		StringBuffer strXML = new StringBuffer();
		
		strXML.append("<ROOT><NODES>");
		
		for (int i = 0; i < cnt; i++) {
			if (pMode.equals("PHOTO")) {
				strXML.append("<NODE><PUPLOADSN><![CDATA[" + sGUID[i] + "]]></PUPLOADSN>");
			} else {
				strXML.append("<NODE><PUPLOADSN><![CDATA[" + sGUID[i] + "]]></PUPLOADSN>");
			}
			
			strXML.append("<RESULTUPLOADA><![CDATA[" + resultUpload[i] + "]]></RESULTUPLOADA>");
			/* 2018-04-27 홍승비 - 화면에 표시되는 파일명 특문처리 수정 */
			strXML.append("<PFILENAME><![CDATA[" + commonUtil.cleanValue(pFileName[i]) + "]]></PFILENAME>");
			strXML.append("<FILESIZE>" + fileSize[i] + "</FILESIZE>");
			strXML.append("<FILELOCATION><![CDATA[" + fileLocation[i] + "]]></FILELOCATION>");
			strXML.append("</NODE>");
		}
		
		strXML.append("</NODES></ROOT>");

		logger.debug("uploadItemAttach ended");
        return strXML.toString();
    }
	
	/**
	 * 게시판 게시물첨부(IE9) 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/itemAttachFile.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String itemAttachFile(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception {
		logger.debug("itemAttachFile started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String returnVal = "";
		String guid = "";
		String fileTitle = "";
		String ext = "";
		String prefix = "";
		String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", userInfo.getTenantId());
		
		if (request.getParameter("guid") != null) {
			guid = request.getParameter("guid");
		}
		
		if (request.getParameter("name") != null) {
			fileTitle = request.getParameter("name");
		}
		
		if (request.getParameter("ext") != null) {
			ext = request.getParameter("ext");
		}
		
		if (request.getParameter("prefix") != null) {
			prefix = request.getParameter("prefix");
		}
		
		String boardID = commonUtil.detectPathTraversal(prefix);
		String uploadSN = "{" + guid + "}";
		String fileName = fileTitle + "." + ext;
		
		if (request.getParameter("filename") != null) {
			fileName = request.getParameter("filename");
		}
		
		fileName = fileName.replace("+", "%2b");
		fileName = fileName.replace(";", "%3b");
		fileName = fileName.replace("~", "%7e");
		fileName = fileName.replace("=", "%3d");
		
		String dirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		
		// dhlee : 20220527 - 파일 업로드 시 .으로 끝나는 파일(예: .jsp.)이 무조건 업로드 허용되는 문제 수정
		String extStr = fileName.substring(fileName.lastIndexOf(".") + 1).toString().toLowerCase();

		if ((extStr.isEmpty() || useExtension.toLowerCase().indexOf(extStr) == -1) && !useExtension.equals("*")) {
			returnVal = "denied";
		} else {
			if (!new File(dirPath + "tempUploadFile").exists()) {
				new File(dirPath + "tempUploadFile").mkdirs();
			}
			
			if (!new File(dirPath + boardID).exists()) {
				new File(dirPath + boardID + commonUtil.separator + "uploadFile").mkdirs();
				new File(dirPath + boardID + commonUtil.separator + "doc").mkdirs();
			} else if (!new File(dirPath + boardID + commonUtil.separator + "uploadFile").exists()) {
				new File(dirPath + boardID + commonUtil.separator + "uploadFile").mkdirs();
			}
			
			String attachPath = dirPath + "tempUploadFile" + commonUtil.separator + uploadSN + "_" + commonUtil.detectPathTraversal(fileName);
			
			InputStream stream = null;
			OutputStream bos = null;         
			
			try {
				stream = request.getInputStream();
				bos = new FileOutputStream(commonUtil.detectPathTraversal(attachPath));
//                long fileSize = 0;
				int bytesRead = 0;
				byte[] buffer = new byte[BUFF_SIZE];
				
				while ((bytesRead = stream.read(buffer, 0, BUFF_SIZE)) != -1) {
					bos.write(buffer, 0, bytesRead);
//                    fileSize += bytesRead;
				}
			} catch (Exception e) {
				throw e;                
			} finally {
				if (bos != null) {
					try {
						bos.close();
					} catch (Exception e) {
						logger.debug("e.message=" + e.getMessage());
					}
				}
				if (stream != null) {
					try {
						stream.close();
					} catch (Exception e) {
						logger.debug("e.message=" + e.getMessage());
					}
				}
			}
			returnVal = "OK_" + uploadSN + "_" + fileName;
		}
		
		logger.debug("itemAttachFile ended");
		return returnVal;
	}
	
	/**
	 * 포토게시판 게시물첨부(IE9) 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/itemAttachFilePhoto.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String itemAttachFilePhoto(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception {
		logger.debug("itemAttachFilePhoto started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String returnVal = "";
		String guid = "";
		String fileTitle = "";
		String ext = "";
		String prefix = "";
		
		if (request.getParameter("guid") != null) {
			guid = request.getParameter("guid");
		}
		
		if (request.getParameter("name") != null) {
			fileTitle = request.getParameter("name");
		}
		
		if (request.getParameter("ext") != null) {
			ext = request.getParameter("ext");
		}
		
		if (request.getParameter("prefix") != null) {
			prefix = request.getParameter("prefix");
		}
		
		String boardID = commonUtil.detectPathTraversal(prefix);
		String uploadSN = "{" + guid + "}";
		String fileName = fileTitle + "." + ext;
		
		fileName = fileName.replace("+", "%2b");
		fileName = fileName.replace(";", "%3b");
		fileName = fileName.replace("~", "%7e");
		fileName = fileName.replace("=", "%3d");
		
		String fileExt = "";
		String extension = "";
		
		if (fileName.length() > 4) {
			fileExt = fileName.substring(fileName.length() - 4).toLowerCase();
			extension = fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length());
		}
		
		String dirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		
		if (!new File(dirPath + "tempUploadFile").exists()) {
			new File(dirPath + "tempUploadFile").mkdirs();
		}
		
		if (!new File(dirPath + boardID).exists()) {
			new File(dirPath + boardID + commonUtil.separator + "uploadFile").mkdirs();
			new File(dirPath + boardID + commonUtil.separator + "doc").mkdirs();
		} else if (!new File(dirPath + boardID + commonUtil.separator + "uploadFile").exists()) {
			new File(dirPath + boardID + commonUtil.separator + "uploadFile").mkdirs();
		}
		
		String attachPath = dirPath + "tempUploadFile" + commonUtil.separator + uploadSN + "." + commonUtil.detectPathTraversal(ext);
		String mapPath = dirPath + "tempUploadFile" + commonUtil.separator;
		
		InputStream stream = null;
		OutputStream bos = null;         
		
		try {
			stream = request.getInputStream();
			bos = new FileOutputStream(commonUtil.detectPathTraversal(attachPath));
//			long fileSize = 0;
			int bytesRead = 0;
			byte[] buffer = new byte[BUFF_SIZE];
			
			while ((bytesRead = stream.read(buffer, 0, BUFF_SIZE)) != -1) {
				bos.write(buffer, 0, bytesRead);
//				fileSize += bytesRead;
			}
		} catch (Exception e) {
			throw e;                
		} finally {
			if (bos != null) {
				try {
					bos.close();
				} catch (Exception e) {
					logger.debug("e.message=" + e.getMessage());
				}
			}
			if (stream != null) {
				try {
					stream.close();
				} catch (Exception e) {
					logger.debug("e.message=" + e.getMessage());
				}
			}
		}
		
		File imageFile = new File(commonUtil.detectPathTraversal(attachPath));
		
		int nImgWidth = 0;
		int nImgHeight = 0;
		
		if (imageFile.exists()) {			
			BufferedImage bi = ImageIO.read(imageFile);
			nImgWidth = bi.getWidth();
			nImgHeight = bi.getHeight();
			int nWidth = 0, nHeight = 0;
			
			if (nImgWidth > nImgHeight) {
				nWidth = 200;
				nHeight = (bi.getHeight() * nWidth) / bi.getWidth();
			} else {
				nHeight = 200;
				nWidth = (bi.getWidth() * nHeight) / bi.getHeight();
			}
			
			BufferedImage bufferedImage = null;
			/* 2019-10-21 홍승비 - png파일의 경우, 썸네일 이미지 저장 시 타입을 TYPE_4BYTE_ABGR로 고정 */
			if (bi.getType() == 0 || extension.equals("png")) { // 일부 png 파일의 경우, type값이 0으로 넘어오거나 검은색으로 저장된다.
				bufferedImage = new BufferedImage(nWidth, nHeight, BufferedImage.TYPE_4BYTE_ABGR);
			} else {
				bufferedImage = new BufferedImage(nWidth, nHeight, bi.getType());
			}
			bufferedImage.createGraphics().drawImage(bi, 0, 0, nWidth, nHeight, null);
			ImageIO.write(bufferedImage, ext, new File(commonUtil.detectPathTraversal(mapPath + "s_" + uploadSN + fileExt)));
		}
		
		returnVal = "OK_" + commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", userInfo.getTenantId()) + commonUtil.separator + uploadSN + fileExt;

		logger.debug("itemAttachFilePhoto ended");
		return returnVal;
	}
	
	/**
	 * 게시판 첨부파일가져오기 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/getItemAttachments.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String getItemAttachments(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception {
		logger.debug("getItemAttachments started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String pItemID = "";
		String pTitle = "";
		String pConLocation = "";
		String pMode = "";
		String strXML = "";
		String realPath = commonUtil.getRealPath(request);
		
		pItemID = request.getParameter("itemID");
		pTitle = request.getParameter("title");
		pConLocation = request.getParameter("conLocation");
		pMode = request.getParameter("mode");
		
		if (pTitle != null) {
			pTitle = pTitle.replaceAll("[\\\\/:*?\"<>|]", "_");
		}
		
		if (pMode != null && (pMode.equals("boardContent") || pMode.equals("boardAttach"))) {
			strXML = getItemAttachmentXML_Retrans(pItemID, realPath, pMode, pConLocation, pTitle, userInfo.getTenantId());
		} else {
			strXML = getItemAttachmentXML(pItemID, userInfo.getTenantId());
		}

		logger.debug("getItemAttachments ended");
        return strXML;
	}

	/**
	 * 게시판 재전송관련 표출 Method
	 * @param tenantID 
	 */
	public String getItemAttachmentXML_Retrans(String pItemID, String filePath, String pMode, String pConLocation, String pTitle, int tenantID) throws Exception {
		logger.debug("getItemAttachmentXML_Retrans started");

		List<BoardAttachVO> boardAttachVOList = ezBoardService.brdGetItemAttachmentInfo(pItemID, tenantID);
		
		StringBuilder resultXML = new StringBuilder();
		resultXML.append("<NODES>");
		
		if (pMode.equals("boardAttach")) {
			File file = new File(commonUtil.detectPathTraversal(filePath + pConLocation));
			String fileExtension = pConLocation.substring(pConLocation.lastIndexOf("."));
			String newFilePath = "tempUploadFile" + commonUtil.separator + "{" + UUID.randomUUID() + "}_" + pTitle + fileExtension;
			File fileMove = new File(commonUtil.detectPathTraversal(filePath + commonUtil.getUploadPath("upload_board.ROOT", tenantID) + commonUtil.separator + commonUtil.detectPathTraversal(newFilePath)));
			FileUtils.copyFile(file, fileMove);
			
			long mhtSize = file.length();
			
			resultXML.append("<NODE>");
			resultXML.append("<ItemID>" + pItemID + "</ItemID>");
			resultXML.append("<FileName>" + commonUtil.cleanValue(pTitle + fileExtension) + "</FileName>");
			resultXML.append("<FilePath>" + commonUtil.cleanValue(newFilePath) + "</FilePath>");
			resultXML.append("<FileSize>" + getProperSizeDisplay(String.valueOf(mhtSize)) + "</FileSize>");
			resultXML.append("<FileSize2>" + mhtSize + "</FileSize2>");
			resultXML.append("</NODE>");
		}
		
		for (int i = 0; i < boardAttachVOList.size(); i++) {
			String pFilePath = boardAttachVOList.get(i).getFilePath();
			String fileExtension = boardAttachVOList.get(i).getFilePath().substring(boardAttachVOList.get(i).getFilePath().lastIndexOf("."));
			String newFilePath = "tempUploadFile" + commonUtil.separator + "{" + UUID.randomUUID() + "}" + fileExtension;
			
			File file = new File(commonUtil.detectPathTraversal(filePath + commonUtil.separator + pFilePath));
			File fileMove = new File(commonUtil.detectPathTraversal(filePath + commonUtil.getUploadPath("upload_board.ROOT", tenantID) + commonUtil.separator + commonUtil.detectPathTraversal(newFilePath)));
			FileUtils.copyFile(file, fileMove);
			
			resultXML.append("<NODE>");
			resultXML.append("<ItemID>" + boardAttachVOList.get(i).getItemID() + "</ItemID>");
			resultXML.append("<FileName>" + commonUtil.cleanValue(boardAttachVOList.get(i).getFileName()) + "</FileName>");
			resultXML.append("<FilePath>" + commonUtil.cleanValue(newFilePath) + "</FilePath>");
			resultXML.append("<FileSize>" + getProperSizeDisplay(boardAttachVOList.get(i).getFileSize()) + "</FileSize>");
			resultXML.append("<FileSize2>" + boardAttachVOList.get(i).getFileSize() + "</FileSize2>");
			resultXML.append("</NODE>");
		}
		
		resultXML.append("</NODES>");
		
		logger.debug("getItemAttachmentXML_Retrans ended");
        return resultXML.toString();
	}

	/**
	 * 게시판 첨부파일관련 표출 Method
	 * @param tenantID 
	 */
	public String getItemAttachmentXML(String pItemID, int tenantID) throws Exception {
		logger.debug("getItemAttachmentXML started");

		List<BoardAttachVO> boardAttachVOList = ezBoardService.brdGetItemAttachmentInfo(pItemID, tenantID);
		
		StringBuilder resultXML = new StringBuilder();
		resultXML.append("<NODES>");
		
		for (int i = 0; i < boardAttachVOList.size(); i++) {
			resultXML.append("<NODE>");
			resultXML.append("<ItemID>" + boardAttachVOList.get(i).getItemID() + "</ItemID>");
			resultXML.append("<GUID>" + boardAttachVOList.get(i).getGuid().trim() + "</GUID>");
			resultXML.append("<FilePath>" + commonUtil.cleanValue(boardAttachVOList.get(i).getFilePath()) + "</FilePath>");
			resultXML.append("<FileName>" + commonUtil.cleanValue(boardAttachVOList.get(i).getFileName()) + "</FileName>");
			resultXML.append("<FileSize>" + commonUtil.getSizeWithUnit(Double.parseDouble(boardAttachVOList.get(i).getFileSize())) + "</FileSize>");
			resultXML.append("<FileSize2>" + boardAttachVOList.get(i).getFileSize() + "</FileSize2>");
			resultXML.append("</NODE>");
		}
		
		resultXML.append("</NODES>");

		logger.debug("getItemAttachmentXML ended");
		return resultXML.toString();
	}
	
	/**
	 * 게시판 사용자가 보기에 편리한 형태로 파일 사이즈를 변환해 주는 Method
	 */
	public String getProperSizeDisplay(String pSize) throws Exception {
		logger.debug("getProperSizeDisplay started");
		int size = Integer.parseInt(pSize);
		
		if (size > 1048576) {
			logger.debug("getProperSizeDisplay ended");
			return Math.round(((float)size / 1024 / 102.4) / 10) + " MB";
		} else if (size > 1024) {
			logger.debug("getProperSizeDisplay ended");
			return Math.round((size / 102.4) / 10) + " KB";
		} else {
			logger.debug("getProperSizeDisplay ended");
			return pSize + " Byte";
		}
	}
	
	/**
	 * 게시판 첨부파일다운 실행 Method
	 */
	@RequestMapping(value = "/ezBoard/boardAttachDown.do", method = RequestMethod.GET)
	@ResponseBody
	public void boardAttachDown(HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("boardAttachDown started");

		String filePath = commonUtil.detectPathTraversal(request.getParameter("filePath"));
		String fileName = commonUtil.detectPathTraversal(request.getParameter("fileName"));
		String attID = commonUtil.detectPathTraversal(request.getParameter("attID"));
		String realPath = commonUtil.getRealPath(request);
		
		//logger.debug("FilePath: " + filePath + " || File Name: " + fileName + " || attID: " + attID);

		if (!fileName.endsWith(".mht")) {
			if (attID != null && !attID.equals("")) {
				downFile(request, response, realPath + filePath, attID);
			} else {
				downFile(request, response, realPath + filePath, fileName);
			}
		} else {
			ezBoardService.downloadBackgroundItemFile(request, response, realPath, filePath, fileName);
		}

		logger.debug("boardAttachDown ended");
	}
	
	/**
	 * 게시판 게시물답변여부 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/checkIfHasReply.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String checkIfHasReply(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("checkIfHasReply started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String itemList = "";
		String result = ""; 
		
		itemList = request.getParameter("itemList");
		
		for (int i = 0; i < itemList.split(";").length; i++) {
			String tempItemID = itemList.split(";")[i].split(",")[0];
			
			result = ezBoardService.brdCheckIfHasReply(tempItemID, userInfo.getTenantId());
			
			if (result.equals("TRUE")) {
				break;
			}
		}

		logger.debug("checkIfHasReply ended");
		return result;
	}
	
	/**
	 * 게시판 게시물삭제 실행 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/deleteItem.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String deleteItem(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("deleteItem started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String mode = "";
		String itemList = "";
		String boardID = "";
		String realPath = commonUtil.getRealPath(request);
		String companyID = userInfo.getCompanyID();
		int tenantID = userInfo.getTenantId();
		
		itemList = request.getParameter("itemList");
		mode = request.getParameter("mode") != null ? request.getParameter("mode") : "";
		boardID = request.getParameter("boardID");
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		
		logger.debug("deleteItem mode = " + mode + " / boardID = " + boardID + " / boardName = " + boardInfo.getBoardName());
		
		String result = ezBoardService.deleteItem(itemList, mode, boardID, realPath, userInfo, boardInfo);

		// 2023-05-03 기민혁 - 게시물 삭제시 scrap 목록 삭제
	    ezBoardService.deleteBoardScrapItem(itemList, companyID, tenantID);

	    // 2023-05-22 기민혁 - 게시물 삭제시 scrapcont 목록 삭제
	    ezBoardService.deleteBoardScrapContItem(itemList, companyID, tenantID);

		logger.debug("deleteItem ended, userID = " + userInfo.getId());
		return result;
	}
	
	/**
	 * 게시판 게시물복사 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/copyBoardItem.do", method = RequestMethod.GET)
	public String copyBoardItem(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("copyBoardItem started");

		String itemIDList = "";
		String boardIDs = "";
		
		userInfo = commonUtil.userInfo(loginCookie);
		itemIDList = request.getParameter("itemIDList");
		boardIDs = request.getParameter("boardID");
		String guBun = request.getParameter("guBun");
		
		/* 2019-07-12 홍승비 - 나의 게시물에서 복사 시 구분값 전부 합쳐지는 오류 수정 */
		HashSet<String> gubunSet = new HashSet<String>(); 
		if (guBun != null && !guBun.equals("")) {
			String[] guBuns = guBun.split(";");
			for (int i = 0; i < guBuns.length; i++) {
				gubunSet.add(guBuns[i]);
			}
			
			// 타입이 다른 게시판에서 게시물을 복사 시도, 또는 split한 구분값 없음
			if (gubunSet.size() > 1 || gubunSet.isEmpty()) {
				guBun = "error";
			} else {
				guBun = gubunSet.iterator().next();
			}
		} else { // 구분값이 null 또는 공백이라면 에러
			guBun = "error";
		}
		
		/* 2019-08-08 홍승비 - 잘못된 권한체크 제거(주석처리) */
/*		String[] boardID = boardIDs.split(";");
		
		for (int k = 0; k < boardID.length - 1; k++) {
			BoardPropertyVO boardInfo = getBoardInfo(boardID[k], userInfo);
			
			if (!boardInfo.getRead_FG().equals("true")) {
				return "main/warning";
			}
			
			if (!boardInfo.getBoardAdmin_FG().equals("true")) {
				if (!boardInfo.getBoardGroupAdmin_FG().equals("true")) {
					return "main/warning";
				}
			}
		}
		*/
		model.addAttribute("itemIDList", itemIDList);
		model.addAttribute("boardID", boardIDs);
		model.addAttribute("guBun", guBun);

		logger.debug("copyBoardItem ended");
		return "ezBoard/boardCopyItem";
	}
	
	/**
	 * 게시판 권한 단독 체크 후 XML형식 문자열로 리턴 Method
	 */
	@RequestMapping(value = "/ezBoard/getACL.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getACL(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("getACL started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String strACLXML = "";
		String boardGroupID = "";
		String isAllGroupBoard = "N";
		
		BoardPropertyVO boardPropertyVO = ezBoardService.getBoardProperty(boardID, userInfo.getTenantId());
		
		boolean isBoardGroup = false;
		if (boardPropertyVO.getBoardGroupID() != null) { // 하위게시판
			boardGroupID = boardPropertyVO.getBoardGroupID();
			BoardPropertyVO strGroupProp = ezBoardService.getBoardProperty(boardGroupID, userInfo.getTenantId());
			if (strGroupProp.getGuBun() != null && strGroupProp.getGuBun().equals("99")) {
				isAllGroupBoard = "Y";
			}
			isBoardGroup = false;
		} else { // 게시판그룹
			isBoardGroup = true;
		}
		
		String deptPath = userInfo.getDeptPathCode();
		StringBuilder deptPathOrgan = new StringBuilder();
		List<String> addJobDeptList = new ArrayList<String>();
		
		/* 2019-09-18 홍승비 - 개인ID 이후, 부서ID 이전 위치에 직위+직책ID (사내겸직 직위 포함) 추가 */
		String userJJID = ezBoardService.getUserJJID(userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
		
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
		
		/* 2019-06-03 홍승비 - 현재 소속 회사의 사내겸직이 존재하면 사내겸직부서ID와 그 상위부서ID까지 권한체크에 포함하도록 수정 */
		List<String> addJobList = ezBoardService.getPDOAddJobDeptID(userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
		StringJoiner addJobStr = new StringJoiner(",");
		addJobStr.add(userInfo.getDeptID());
		if (addJobList != null && addJobList.size() > 0) {
			for (int i = 0; i < addJobList.size(); i++) {
				addJobStr.add(addJobList.get(i));
				String upperDept = ezBoardService.getUpperDeptID(addJobList.get(i), userInfo.getTenantId());
				
				if (upperDept != null && !upperDept.equals("")) {
					boolean loopContinue = true;
					StringJoiner upperDeptStr = new StringJoiner(",");
					upperDeptStr.add(upperDept);
					
					while (loopContinue) {
						String upperDeptLoop = ezBoardService.getUpperDeptID(upperDept, userInfo.getTenantId());
						if (upperDeptLoop != null && !upperDeptLoop.equals("")) {
							upperDeptStr.add(upperDeptLoop);
							upperDept = upperDeptLoop;
						} else {
							loopContinue = false;
						}
					}
					addJobDeptList.add(addJobList.get(i) + "," + upperDeptStr.toString()); // 각각의 부서경로 어레이리스트에 add
				}
			}
		}
		
		List<BoardPropertyVO> boardACLListDept = new ArrayList<BoardPropertyVO>();
		List<BoardPropertyVO> boardACLListJJ = new ArrayList<BoardPropertyVO>();
		Set<String> userJJIDSet = new HashSet<String>(Arrays.asList(userJJID.split(",")));
		
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
					int isDept = ezBoardService.isDeptChk(addJobDeptList.get(jl).split(",")[i].trim(), userInfo.getTenantId());
					
					
					/* 2019-09-18 홍승비 - 동일한 ACCESSID에 대해 리스트로 리턴된 권한을 '허용'권한 기준으로 취합 */
					// 우선순위는 알아서 적용됨(이미 addJobDeptList가 우선순위를 적용한 문자열 순서대로 만들어졌음)
					// 개인 - 직위/직책 - 부서/회사 순으로 알아서 우선순위가 적용되고, 각 루프에서 가장 우선순위가 높은 권한을 찾으면 다음 루프로 빠져나감
					BoardPropertyVO boardInfoTempNew = new BoardPropertyVO();
					List<BoardPropertyVO> boardInfoTempList = ezBoardService.getACLListNew(boardID, addJobDeptList.get(jl).split(",")[i].trim(), userInfo.getTenantId(), isDept, isEqualDept);
					if (boardInfoTempList != null && boardInfoTempList.size() > 0) {
						boardInfoTempNew = sumBoardACL(boardInfoTempList, boardInfoTempNew);
					}
					
					/* 2019-09-24 홍승비 - 권한그룹을 포함하여 게시판그룹 관리자권한 체크 */
					// 권한그룹 적용 시 개인권한이 다수 존재 가능하므로, 권한을 리스트로 가져온 뒤 '허용(OK)'기준으로 취합한다.
					String boardGroupAdmin_FG_New = "";
					List<String> boardGroupAdmin_FG_List = ezBoardService.checkIfBoardGroupAdminNew(boardID, addJobDeptList.get(jl).split(",")[i].trim(), userInfo.getTenantId(), isDept, isEqualDept, isBoardGroup);
					if (boardGroupAdmin_FG_List != null && boardGroupAdmin_FG_List.size() > 0) { // 권한이 없으면 공백값을 유지 > 다음 루프 진행
						if (boardGroupAdmin_FG_List.contains("OK")) { // 동일한 우선순위의 권한에 대해서, OK가 하나라도 존재한다면 OK로 판정
							boardGroupAdmin_FG_New = "OK";
						} else {
							boardGroupAdmin_FG_New = "NO";
						}
					}
					
					if (boardInfoTempList != null && boardInfoTempList.size() > 0) {
						boardInfoTempNew.setBoardGroupAdmin_FG(boardGroupAdmin_FG_New);
						
						if (addJobDeptList.get(jl).split(",")[i].trim().equals(userInfo.getId())) { // 개인권한
							boardPropertyVO = boardInfoTempNew;
							isUserHasACL = true;
							break;
						}
						else if (userJJIDSet.contains(addJobDeptList.get(jl).split(",")[i].trim())) { // 직위, 직책 권한
							boardACLListJJ.add(boardInfoTempNew);
							isUserHasACL = false;
							// 직위, 직책권한은 레코드 전부 찾을때까지 break 안함
						}
						else { // 부서권한
							boardACLListDept.add(boardInfoTempNew);
							isUserHasACL = false;
							break;
						}
					}
					else if (!boardGroupAdmin_FG_New.equals("")) { // 해당 게시판에는 권한이 존재하지 않으나, 게시판 그룹에 대하여 관리자권한이 존재하는 경우
						BoardPropertyVO boardGroupAdminFG = new BoardPropertyVO();
						if (boardGroupAdmin_FG_New.equals("OK")) {
							boardGroupAdminFG.setBoardGroupAdmin_FG("OK");
							boardGroupAdminFG.setAccess_("1");
							
							// 게시판그룹의 관리자 권한이 '허용'인 경우에만 추가하도록 한다.
							if (addJobDeptList.get(jl).split(",")[i].trim().equals(userInfo.getId())) { // 개인의 게시판그룹 관리자 권한
								// 개인에 대하여 게시판그룹의 관리자 권한이 존재하므로, 루프를 벗어난다.
								boardPropertyVO.setBoardGroupAdmin_FG(boardGroupAdmin_FG_New);
								isUserHasACL = true;
								break;
							}
							else if (userJJIDSet.contains(addJobDeptList.get(jl).split(",")[i].trim())) { // 직위, 직책의 게시판그룹 관리자  권한
								boardGroupAdminFG.setAccessID(addJobDeptList.get(jl).split(",")[i]);
								boardACLListJJ.add(boardGroupAdminFG);
							}
							else { // 부서, 회사의 게시판그룹 관리자  권한
								boardGroupAdminFG.setAccessID(addJobDeptList.get(jl).split(",")[i]);
								boardACLListDept.add(boardGroupAdminFG);
								break;
							}
						} else {
							boardGroupAdminFG.setBoardGroupAdmin_FG("NO");
						}
					}
				}
			}
		}
		
		if (isUserHasACL == false) { // 개인 권한이 존재하지 않는 경우에만 권한 취합
			if (boardACLListJJ.size() > 0) { // 직위, 직책권한 부여
				boardPropertyVO = sumBoardACL(boardACLListJJ, boardPropertyVO);
			} else { // 직위, 직책권한이 없다면 부서권한 부여
				boardPropertyVO = sumBoardACL(boardACLListDept, boardPropertyVO);
			}
		}
		
		// 게시판의 관리자 권한 존재 시 다른 권한값들을 true로 임의 셋팅
		if (boardPropertyVO.getBoardGroupAdmin_FG() != null && boardPropertyVO.getBoardGroupAdmin_FG().equals("OK")) {
			boardPropertyVO.setAccess_("1");
			boardPropertyVO.setAccess_FG("1");
			boardPropertyVO.setBoardAdmin_FG("true");
			boardPropertyVO.setListView_FG("true");
			boardPropertyVO.setRead_FG("true");
			boardPropertyVO.setWrite_FG("true");
			boardPropertyVO.setReply_FG("true");
			boardPropertyVO.setDelete_FG("true");
		}
		
		/* 2019-08-06 홍승비 - 게시판 선택 팝업창으로 게시물 작성/복사/이동 시 게시판그룹의 관리자 권한(boardGroupAdmin)을 체크하지 않는 오류 수정  */
		if ((commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "c") || boardPropertyVO.getBoardAdmin_FG().equals("true")) ||
				(isAllGroupBoard.equals("N") && commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "n;k"))) {
			strACLXML = "<NODES><NODE><ACCESS>1</ACCESS><BOARDADMIN>true</BOARDADMIN><LIST>true</LIST><READ>true</READ><WRITE>true</WRITE><REPLY>true</REPLY><DELETE>true</DELETE><INHERIT>false</INHERIT><POSTNOTICE></POSTNOTICE></NODE></NODES>";
		} else {
			StringBuilder sb = new StringBuilder();
			sb.append("<NODES>");
			
			if (boardPropertyVO != null) {
				sb.append("<NODE>");
				sb.append("<ACCESS>" + boardPropertyVO.getAccess_() + "</ACCESS>");
				sb.append("<BOARDGROUPADMIN>" + boardPropertyVO.getBoardGroupAdmin_FG()+ "</BOARDGROUPADMIN>"); // OK/NO
				sb.append("<BOARDADMIN>" + boardPropertyVO.getBoardAdmin_FG() + "</BOARDADMIN>");
				sb.append("<LIST>" + boardPropertyVO.getListView_FG() + "</LIST>");
				sb.append("<READ>" + boardPropertyVO.getRead_FG() + "</READ>");
				sb.append("<WRITE>" + boardPropertyVO.getWrite_FG() + "</WRITE>");
				sb.append("<REPLY>" + boardPropertyVO.getReply_FG() + "</REPLY>");
				sb.append("<DELETE>" + boardPropertyVO.getDelete_FG() + "</DELETE>");
				sb.append("<INHERIT>" + boardPropertyVO.getInherit_FG() + "</INHERIT>");
				sb.append("<POSTNOTICE>" + boardPropertyVO.getPostNotice() + "</POSTNOTICE>");
				sb.append("</NODE>");			
			}	
			
			sb.append("</NODES>");
			
			strACLXML = sb.toString();
		}
		
		//logger.debug("strACLXML in boardACL   ::  " + strACLXML);
		logger.debug("getACL ended");
		return strACLXML;
	}
	
	/**
	 * 게시판 익명게시판여부 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/checkIfAnonyBoard.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String checkIfAnonyBoard(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("checkIfAnonyBoard started");

		String result = "";
		String boardID = "";
		
		boardID = request.getParameter("boardID");
		userInfo = commonUtil.userInfo(loginCookie);
		
		/* 2019-06-03 홍승비 - 게시판 구분값과 확장컬럼 여부값만을 사용하므로, getBoardProperty로 메서드 변경 */
		BoardPropertyVO boardInfo = ezBoardService.getBoardProperty(boardID, userInfo.getTenantId());
		
		/* 2020-02-13 홍승비 - 익명게시판이면서 확장칼럼을 가지는 경우도 체크하도록 수정 */
		if (boardInfo.getGuBun() != null && (boardInfo.getGuBun().equals("2") || boardInfo.getGuBun().equals("3") || boardInfo.getGuBun().equals("4") || boardInfo.getGuBun().equals("7"))) {
			result += "<RESULT>anonyboard</RESULT>";
		}
		/* 2020-06-23 홍승비 - URL 게시판 체크 분기 분리 */
		if (boardInfo.getUrl() != null && !boardInfo.getUrl().trim().equals("")) {
			result += "<RESULT>URLboard</RESULT>";
		}
		if (boardInfo.getAttributeYN() != null && boardInfo.getAttributeYN().equals("Y")) {
			result += "<RESULT>attributeextension</RESULT>";
		}

		logger.debug("checkIfAnonyBoard ended");
		return result;
	}
	
	/**
	 * 게시판 게시물복사 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/copyItem.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String boardCopyItem(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("boardCopyItem started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String orgItemIDList = "";
		String orgBoardID = "";
		String destBoardID = "";
		String uploadFilePath = commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId());
		String realPath = commonUtil.getRealPath(request);
		String result = "";
		
		orgItemIDList = request.getParameter("orgItemIDList");
		orgBoardID = request.getParameter("orgBoardID");
		destBoardID = request.getParameter("destBoardID");
		result = ezBoardService.copyItem(orgItemIDList, orgBoardID, destBoardID, uploadFilePath, realPath, userInfo);
		
		/* 2019-07-02 홍승비 - 게시물 복사 후 복사한 게시물의 ItemID 리턴하도록 수정 */
		logger.debug("boardCopyItem ended");
		return result;
	}

	/**
	 * 게시판 게시물이동 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/moveBoardItem.do", method = RequestMethod.GET)
	public String moveBoardItem(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("moveBoardItem started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String itemIDList = request.getParameter("itemIDList");
		String boardID = request.getParameter("boardID");
		String guBun = request.getParameter("guBun");
		
		/* 2019-07-16 홍승비 - 나의 게시물에서 이동 시 구분값 전부 합쳐지는 오류 수정 */
		HashSet<String> gubunSet = new HashSet<String>(); 
		if (guBun != null && !guBun.equals("")) {
			String[] guBuns = guBun.split(";");
			for (int i = 0; i < guBuns.length; i++) {
				gubunSet.add(guBuns[i]);
			}
			
			// 타입이 다른 게시판에서 게시물을 이동 시도, 또는 split한 구분값 없음
			if (gubunSet.size() > 1 || gubunSet.isEmpty()) {
				guBun = "error";
			} else {
				guBun = gubunSet.iterator().next();
			}
		} else { // 구분값이 null 또는 공백이라면 에러
			guBun = "error";
		}
		
		model.addAttribute("itemIDList", itemIDList);
		model.addAttribute("boardID", boardID);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("guBun", guBun);

		logger.debug("moveBoardItem ended");
		return "ezBoard/boardMoveItem";
	}
	
	/**
	 * 게시판 게시물이동 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/moveItem.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String boardMoveItem(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("boardMoveItem started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String orgItemIDList = "";
		String orgBoardIDList = "";
		String destBoardID = "";
		String uploadFilePath = commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId());
		String realPath = commonUtil.getRealPath(request);
		String result = "";
		
		orgItemIDList = request.getParameter("orgItemIDList");
		orgBoardIDList = request.getParameter("orgBoardID");
		destBoardID = request.getParameter("destBoardID");
		
		result = ezBoardService.moveItem(orgItemIDList, orgBoardIDList, destBoardID, userInfo, uploadFilePath, realPath);

		/* 2019-07-03 홍승비 - 게시물 이동 후 이동한 게시물의 ItemID 리턴하도록 수정 */
		logger.debug("boardMoveItem ended");
		return result;
	}

	/**
	 * 게시판 나의게시판추가 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/addToMyBoards.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String addToMyBoards(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("addToMyBoards started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String isAllGroupBoard = "";
		
		/* 2018-10-18 홍승비 - 그룹사게시판 즐겨찾기 분기 추가 */
		BoardPropertyVO boardProp = ezBoardService.getBoardProperty(boardID, userInfo.getTenantId());
		if (boardProp.getBoardGroupID() != null) {
			String boardGroupID = boardProp.getBoardGroupID();
			
			BoardPropertyVO boardGroupProp = ezBoardService.getBoardProperty(boardGroupID, userInfo.getTenantId());
			
			if (boardGroupProp.getGuBun() != null && boardGroupProp.getGuBun().equals("99")) {
				isAllGroupBoard = "Y";
			}
		}
		
		/* 2018-06-27 홍승비 - 즐겨찾기에 게시판 추가 시 companyID 삽입 */
		String result = ezBoardAdminService.addMyBoards(userInfo.getId(), boardID, isAllGroupBoard, userInfo.getCompanyID(), userInfo.getTenantId());

		logger.debug("addToMyBoards ended");
		return "<RESULT>" + result + "</RESULT>";
	}
	
	/**
	 * 게시판 나의게시판설정 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/myBoardConfig.do", method = RequestMethod.GET)
	public String myBoardConfig(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("myBoardConfig started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String type = request.getParameter("type");
		String boardID = request.getParameter("boardID");
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		
		model.addAttribute("type", type);
		model.addAttribute("boardID", boardID);
		model.addAttribute("boardInfo", boardInfo);

		logger.debug("myBoardConfig ended");
		return "ezBoard/boardMyBoardConfig";
	}
	
	/**
	 * 게시판 이름적는창 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/inputNameDlg.do", method = RequestMethod.GET)
	public String inputNameDlg() {
		return "ezBoard/boardInputNameDlg";
	}
	
	/**
	 * 게시판 나의게시판설정 실행 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/setMyBoardsConfig.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String setMyBoardsConfig(@RequestBody String xmlPara, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("setMyBoardsConfig started");
		
		String stripXml = commonUtil.stripScriptTags(xmlPara);
		Document doc = commonUtil.convertStringToDocument(stripXml);
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		BoardMyFavoriteVO boardMyFavoriteVO = new BoardMyFavoriteVO();
		boardMyFavoriteVO.setUserId(userInfo.getId());
		boardMyFavoriteVO.setTreeId(doc.getElementsByTagName("PTREEID").item(0).getTextContent());
		boardMyFavoriteVO.setTreeName(doc.getElementsByTagName("PTREENAME").item(0).getTextContent());
		boardMyFavoriteVO.setTreeName2(doc.getElementsByTagName("PTREENAME2").item(0).getTextContent());
		boardMyFavoriteVO.setTreeName3(doc.getElementsByTagName("PTREENAME3").item(0).getTextContent());
		boardMyFavoriteVO.setTreeName4(doc.getElementsByTagName("PTREENAME4").item(0).getTextContent());
		boardMyFavoriteVO.setTreeUpper(doc.getElementsByTagName("PUPPERID").item(0).getTextContent());
		boardMyFavoriteVO.setMode(doc.getElementsByTagName("PMODE").item(0).getTextContent());
		
		// TREEBOARDID에 추가할 게시판ID가 들어간다.
		boardMyFavoriteVO.setBoardId(doc.getElementsByTagName("PBOARDID").item(0).getTextContent());
		boardMyFavoriteVO.setCompanyID(userInfo.getCompanyID());
		boardMyFavoriteVO.setTenantID(userInfo.getTenantId());
		
		// 마이게시판 설정 시 COMPANYid 추가함
		String retValue = ezBoardAdminService.setMyBoardTreeConfig(boardMyFavoriteVO);

		logger.debug("setMyBoardsConfig ended");
		
		return "<RESULT>" + retValue + "</RESULT>";
	}
	
	/**
	 * 게시판 나의게시판 이동 복사 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/myBoardmovecopy.do", method = RequestMethod.GET)
	public String myBoardmovecopy(Model model, HttpServletRequest request) {
		logger.debug("myBoardmovecopy started");

		String selID = request.getParameter("selID");
		String nodeID = "";
		if (request.getParameter("nodeID") != null) {
			nodeID = request.getParameter("nodeID");
		}
		String selectedBoardtype = request.getParameter("selectedBoardtype");
		
		model.addAttribute("selID", selID);
		model.addAttribute("nodeID", nodeID);
		model.addAttribute("selectedBoardtype", selectedBoardtype);

		logger.debug("myBoardmovecopy ended");
		return "ezBoard/boardMyBoardMoveCopy";
	}
	
	/**
	 * 게시판 나의게시판이동복사 실행 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/setMyBoardMoveCopy.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String setMyBoardMoveCopy(@RequestBody String xmlPara, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("setMyBoardMoveCopy started");

		Document doc = commonUtil.convertStringToDocument(xmlPara);
		userInfo = commonUtil.userInfo(loginCookie);
		
		BoardMyFavoriteVO boardMyFavoriteVO = new BoardMyFavoriteVO();
		boardMyFavoriteVO.setUserId(userInfo.getId());
		boardMyFavoriteVO.setSelTreeID(doc.getElementsByTagName("PSELTREEID").item(0).getTextContent());
		boardMyFavoriteVO.setMoveTreeID(doc.getElementsByTagName("PMOVETREEID").item(0).getTextContent());
		boardMyFavoriteVO.setMode(doc.getElementsByTagName("PMODE").item(0).getTextContent());
		boardMyFavoriteVO.setTenantID(userInfo.getTenantId());
		
		String result = ezBoardAdminService.setMyBoardTreeMoveCopy(boardMyFavoriteVO);

		logger.debug("setMyBoardMoveCopy ended");
		return "<RESULT>" + result + "</RESULT>";
	}
	
	/**
	 * 게시판 공지순서 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardNotiOrder.do", method = RequestMethod.GET)
	public String boardNotiOrder(HttpServletRequest request, Model model) {
		logger.debug("boardNotiOrder started");

		String boardID = request.getParameter("boardID");
		
		model.addAttribute("boardID", boardID);

		logger.debug("boardNotiOrder ended");
		return "ezBoard/boardNotiOrder";
	}
	
	/**
	 * 게시판 공지순서리스트 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/getNotiitemList.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getNotiitemList(@RequestBody String boardID, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("getNotiitemList started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String resultXml  = ezBoardService.getNoticePostItemAll(boardID, userInfo.getTenantId());
		Document doc = commonUtil.convertStringToDocument(resultXml);
		NodeList nList = doc.getElementsByTagName("ROW");
		
		StringBuilder resultBld = new StringBuilder();
		resultBld.append("<LISTVIEWDATA><HEADERS><HEADER><NAME>" + egovMessageSource.getMessage("ezBoard.t208", userInfo.getLocale()) + "</NAME><WIDTH>70</WIDTH></HEADER></HEADERS><ROWS>");
		
		// 공지사항의 기본 표출 순서는 작성일 내림차순 (최근 작성한 게시물이 상단에 위치)
		for (int i = 0; i < nList.getLength(); i++) {
			resultBld.append("<ROW><CELL><VALUE>" + commonUtil.cleanValue(doc.getElementsByTagName("TITLE").item(i).getTextContent()) + "</VALUE>");
			resultBld.append("<PUBLICFLAG>" + doc.getElementsByTagName("PUBLICFLAG").item(i).getTextContent() + "</PUBLICFLAG>");
			resultBld.append("<DATA1><![CDATA[" + doc.getElementsByTagName("ITEMID").item(i).getTextContent() + "]]></DATA1></CELL></ROW>");
		}
		
		resultBld.append("</ROWS></LISTVIEWDATA>");
		
		logger.debug("getNotiitemList ended");
		return resultBld.toString();
	}
	
	/**
	 * 게시판 공지순서저장 실행 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/saveNotiOrder.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String saveNotiOrder(@RequestBody String itemID, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("saveNotiOrder started");

		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String rtnValue = ezBoardService.setNotiOrder(itemID, userInfo.getTenantId());

		logger.debug("saveNotiOrder ended");
		return rtnValue;
	}
	
	/**
	 * 게시판 부모게시판아이디 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/getParentBoardID.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String getParentBoardID(@RequestBody String boardID, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("getParentBoardID started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String parentBoardID = ezBoardService.getParentBoardID(boardID, userInfo.getTenantId());

		logger.debug("getParentBoardID ended");
		return parentBoardID;
	}
	
	/**
	 * 게시판 게시물미리보기 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardItemPreView.do", method = RequestMethod.GET)
	public String boardItemPreView(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("boardItemPreView started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String guBun = request.getParameter("guBun");
		String boardID = request.getParameter("boardID");
		String useEditor = ezCommonService.getTenantConfig("MODULEEDITOR", userInfo.getTenantId());
		String extenLang = "1";
		String strNow = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
		String writerNameType = request.getParameter("writerNameType");
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		
		if (boardInfo.getAttributeYN() != null && boardInfo.getAttributeYN().equals("Y")) {
			List<BoardAttributeVO> attributeList = ezBoardAdminService.getBoardAttribute(boardID, userInfo.getTenantId());
			
			if (!commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId()).equals("1")) {
				extenLang = "2";
			}
			model.addAttribute("attributeList", attributeList);
		}
		
		//추가 항목 가져오는 소스 
		List<BoardAttributeVO> boardAttributeListVO = new ArrayList<BoardAttributeVO>();
		
		if (boardInfo.getAttributeYN() != null && boardInfo.getAttributeYN().equals("Y")) {
			boardAttributeListVO = ezBoardAdminService.getBoardAttribute(boardID, userInfo.getTenantId());
			if (!commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId()).equals("1")) {
				extenLang = "2";
			}
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("guBun", guBun);
		model.addAttribute("boardID", boardID);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("extenLang", extenLang);
		model.addAttribute("strNow", strNow);
		model.addAttribute("boardAttributeListVO", boardAttributeListVO);
		model.addAttribute("writerNameType", writerNameType);

		logger.debug("boardItemPreView ended");
		return "ezBoard/boardItemPreView";
	}
	
	/**
	 * 게시판 게시물파일경로 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/getContentInfo.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String getContentInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getContentInfo started");

		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String type = request.getParameter("type");
		String docID = request.getParameter("docID");
		String filePath = "";
		
		filePath = ezBoardService.getContentInfo(type, docID, userInfo.getTenantId());

		logger.debug("getContentInfo ended");
		return filePath;
	}
	
	/**
	 * 게시판 게시판재전송 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardRetransOption.do", method = RequestMethod.GET)
	public String boardRetransOption(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		
		userInfo = commonUtil.userInfo(loginCookie);
		String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", userInfo.getTenantId());
		
		model.addAttribute("useExternalMailServer", useExternalMailServer);
		
		return "ezBoard/boardRetransOption";
	}
	
	/**
	 * 게시판 읽은리스트 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/itemReadList.do", method = RequestMethod.GET)
	public String itemReadList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("itemReadList started");
		
//		userInfo = commonUtil.userInfo(loginCookie);
//		StringBuffer resultXML = ezBoardService.getReaderList(boardID, itemID, userInfo.getId(), commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
//		model.addAttribute("boardReadList", boardReadList);
//		model.addAttribute("offset", userInfo.getOffset());
		
		//2018-02-05 김보미
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		
		model.addAttribute("boardID", boardID);
		model.addAttribute("itemID", itemID);
		
		logger.debug("itemReadList ended");
		return "ezBoard/boardItemReadList";
	}
	
	/**
	 * 게시판 인쇄관련 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardItemViewPrintOption.do", method = RequestMethod.GET)
	public String boardItemViewPrintOption(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("boardItemViewPrintOption started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		String btnStyle1 = "";
		String btnStyle2 = "";
		String btnStyle3 = "";
		
		if (userInfo.getLang().equals("1")) {
			btnStyle1 = "width:80px";
			btnStyle2 = "width:80px";
			btnStyle3 = "width:100px";
		} else if (userInfo.getLang().equals("2")) {
			btnStyle1 = "width:70px";
			btnStyle2 = "width:100px";
			btnStyle3 = "width:150px";
		} else if (userInfo.getLang().equals("3")) {
			btnStyle1 = "width:80px";
			btnStyle2 = "width:80px";
			btnStyle3 = "width:110px";
		} else if (userInfo.getLang().equals("4")) {
			btnStyle1 = "width:80px";
			btnStyle2 = "width:80px";
			btnStyle3 = "width:110px";
		}
		
		BoardPropertyVO boardPropertyVO = ezBoardService.getBoardProperty(boardID, userInfo.getTenantId());
		
		model.addAttribute("boardID", boardID);
		model.addAttribute("itemID", itemID);
		model.addAttribute("btnStyle1", btnStyle1);
		model.addAttribute("btnStyle2", btnStyle2);
		model.addAttribute("btnStyle3", btnStyle3);
		model.addAttribute("oneLineReplyFlag", boardPropertyVO.getOneLineReply());
		model.addAttribute("gubun", boardPropertyVO.getGuBun());
		
		logger.debug("boardItemViewPrintOption ended");
		return "ezBoard/boardItemViewPrintOption";
	}
	
	/**
	 * 게시판 게시물인쇄관련 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardItemViewPrint.do", method = RequestMethod.GET)
	public String boardItemViewPrint(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("boardItemViewPrint started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String extenLang = "1";
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		String reservedItem = request.getParameter("reservedItem");
		String oneLine = request.getParameter("oneLine");
		String attach = request.getParameter("attach");
		String oneLineReplyFlag = ezCommonService.getTenantConfig("ONELINE_REPLY_ENABLE", userInfo.getTenantId());
		int menuCount = 0;
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		BoardListVO boardItem = ezBoardService.getBrdGetItemInfo(boardID, itemID, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
		
		ezBoardService.setAsRead(userInfo, boardID, itemID);
		
		//추가항목 있을 경우 추가항목을 가져온다
		List<BoardAttributeVO> boardAttr = new ArrayList<BoardAttributeVO>();
		
		int boardAttrCount = 0;
		
		if (boardInfo.getAttributeYN() != null && boardInfo.getAttributeYN().equals("Y")) {
			boardAttr = ezBoardAdminService.getBoardAttribute(boardID, userInfo.getTenantId());
			boardAttrCount = boardAttr.size();
			
			if (!commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId()).equals("1")) {
				extenLang = "2";
			}
		}
		
		boardItem.setWriteDate(commonUtil.getDateStringInUTC(boardItem.getWriteDate(), userInfo.getOffset(), false));
		if (!StringUtils.isBlank(boardItem.getUpdateDate())) {
			boardItem.setUpdateDate(commonUtil.getDateStringInUTC(boardItem.getUpdateDate(), userInfo.getOffset(), false));
		}
		
		if (boardItem.getExtensionAttribute3() == null || boardItem.getExtensionAttribute3().equals("")) {
			boardItem.setExtensionAttribute3(" ");
		}
		
		if (boardItem.getExtensionAttribute4() == null || boardItem.getExtensionAttribute4().equals("")) {
			boardItem.setExtensionAttribute4(" ");
		}
		
		if (boardItem.getEndDate() != null && boardItem.getEndDate().substring(0, 4).equals("9999")) {
			boardItem.setEndDate(egovMessageSource.getMessage("ezBoard.t287", userInfo.getLocale()));
		}
		
		if (boardInfo.getBoardName() != null && !boardInfo.getBoardName().equals("")) {
			boardInfo.setBoardName(commonUtil.cleanValue(boardInfo.getBoardName()));
		}
		
		if (boardInfo.getBoardName1() != null && !boardInfo.getBoardName1().equals("")) {
			boardInfo.setBoardName1(commonUtil.cleanValue(boardInfo.getBoardName1()));
		}
		
		if (boardInfo.getBoardName2() != null && !boardInfo.getBoardName2().equals("")) {
			boardInfo.setBoardName2(commonUtil.cleanValue(boardInfo.getBoardName2()));
		}
		
		/* 2019-01-31 홍승비 - 게시물 보기 시 게시자 이름 특문처리 (익명게시판 오류수정) */
		if (boardItem.getWriterName() != null && !boardItem.getWriterName().equals("")) {
			boardItem.setWriterName(commonUtil.htmlUnescape(boardItem.getWriterName()).replace("\\", "&#92;"));
		}
		
		List<BoardKeywordVO> keywordList = new ArrayList<>();
		if (boardInfo.getUseKeyword() != null && boardInfo.getUseKeyword().equals("Y")) {
			keywordList = ezBoardService.selectBoardKeywordByBoardItem(boardItem.getItemID(), boardItem.getBoardID(), userInfo.getTenantId());
		}
		
		String use_Editor = ezCommonService.getTenantConfig("MODULEEDITOR", userInfo.getTenantId());
		
		model.addAttribute("boardItem", boardItem);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("menuCount", menuCount);
		model.addAttribute("attach", attach);
		model.addAttribute("oneLine", oneLine);
		model.addAttribute("reservedItem", reservedItem);
		model.addAttribute("oneLineReplyFlag", oneLineReplyFlag);
		model.addAttribute("itemID", itemID);
		model.addAttribute("boardID", boardID);
		model.addAttribute("extenLang", extenLang);
		model.addAttribute("boardAttr", boardAttr);
		model.addAttribute("boardAttrCount", boardAttrCount);
		model.addAttribute("keywordList", keywordList);
		model.addAttribute("use_Editor", use_Editor);

		logger.debug("boardItemViewPrint ended");
		return "ezBoard/boardItemViewPrint";
	}
	
	/**
	 * 게시판 익명게시판 비번체크 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/checkPassWord.do", method = RequestMethod.GET)
	public String checkPassWord(HttpServletRequest request, Model model) throws Exception {
		logger.debug("checkPassWord started");
		
		String replyID = request.getParameter("replyID");
		String itemID = request.getParameter("itemID");
		String replyFlag = request.getParameter("replyFlag");
		String clickFlag = request.getParameter("clickFlag"); // 삭제버튼 선택 시 delete, 수정버튼 선택 시 modify
		String publicModulus = egovFileScrty.getPbm();
		String publicExponent = "10001";
		
		model.addAttribute("replyID", replyID);
		model.addAttribute("itemID", itemID);
		model.addAttribute("publicModulus", publicModulus);
		model.addAttribute("publicExponent", publicExponent);
		model.addAttribute("clickFlag", clickFlag);

		logger.debug("checkPassWord ended");
		
		if (replyFlag != null && replyFlag.equals("true")) { // 강민수92 한줄댓글 삭제시 or 비번 체크시
			return "ezBoard/deleteCommentPopup";
		} else {
			return "ezBoard/boardCheckPassWord";
		}
	}
	
	/**
	 * 게시판 익명게시판 비번체크 실행 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/confirmPassword.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String confirmPassword(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("confirmPassword started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String prm = egovFileScrty.getPrm();
		String pre = egovFileScrty.getPre();
		String replyID = request.getParameter("replyID");
		String itemID = request.getParameter("itemID");
		String newPassword = request.getParameter("newPassword");
		String oldPassword = "";
		
		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
		String rpwd = EgovFileScrty.decryptRsa(pk, newPassword);
		
		newPassword = EgovFileScrty.encryptPassword(rpwd, "unknown");
		
		if (replyID != null && !replyID.equals(""))	{
			oldPassword = ezBoardService.getOneLinePassWord(replyID, itemID, userInfo.getTenantId()).trim();
		} else {
			oldPassword = ezBoardService.getDocPassWord(itemID, userInfo.getTenantId()).trim();
		}
		
		if (newPassword != null && newPassword.equals(oldPassword)) {
			logger.debug("confirmPassword ended");
			return "OK";
		} else {
			logger.debug("confirmPassword ended");
			return "NO";
		}
	}
	
	/**
	 * 게시판 포토게시물 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardItemViewPhoto.do", method = RequestMethod.GET)
	public String boardItemViewPhoto(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("boardItemViewPhoto started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String mode = "new";
		String adjacentItemsEnableFlag = ezCommonService.getTenantConfig("ADJACENT_ITEMS_ENABLE", userInfo.getTenantId());
		String showAdjacent = request.getParameter("showAdjacent");
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		String location = request.getParameter("location");
		String scrapContID = request.getParameter("scrapContID");
		String useOCS = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId());
		String publicModulus = egovFileScrty.getPbm();
		String publicExponent = "10001";
		
		BoardListVO boardItem = null;
		BoardVO boardAdjacent = null;
		
		mode = request.getParameter("mode");
		
		boolean isExistBoardItem = ezBoardService.confirmBoardItemDeletion(boardID, itemID, userInfo.getTenantId());
		
		if (!isExistBoardItem) {
			model.addAttribute("messageContent", egovMessageSource.getMessage("ezMain.delete.hth01", userInfo.getLocale()));
			return "/common/error";
		}

		String authorization = request.getHeader("Authorization");
		String password = StringUtils.isNotBlank(authorization) ? new String(java.util.Base64.getDecoder().decode(StringUtils.removeStart(authorization, "Basic "))) : "";
		
		if (!accessCheck(boardID, itemID, location, userInfo, password)) {
			return "main/warning";
		}
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		
		if (!boardInfo.getRead_FG().equals("true")) {
			return "main/warning";
		}
		
		if (mode == null || !mode.equals("temp")) {
			boardItem = ezBoardService.getBrdGetItemInfo(boardID, itemID, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
		} else {
			boardItem = ezBoardService.getBrdGetItemInfoTemp(boardID, itemID, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
		}
		
		ezBoardService.setAsRead(userInfo, boardID, itemID);
		
		if (boardItem == null || boardItem.getWriterID() == null || boardItem.getWriterID().equals("")) {
			return "main/error";
		}
		
		if (boardItem.getApprFlag() != null && boardItem.getApprFlag().equals("N")) {
			int checkCnt = ezBoardService.checkApprUserList(userInfo.getId(), itemID, userInfo.getTenantId());
			if (checkCnt == 0) {
				boardItem.setApprFlag("");
			}
		}
		
		BoardPropertyVO boardProperty = ezBoardService.getBoardProperty(boardID, userInfo.getTenantId());
		
		if (boardItem.getEndDate().substring(0, 4).equals("9999")) {
			boardItem.setEndDate(egovMessageSource.getMessage("ezBoard.t287", userInfo.getLocale()));
		}
		
		if (adjacentItemsEnableFlag != null && showAdjacent != null && adjacentItemsEnableFlag.equals("1") && showAdjacent.equals("1")) {
			if (boardItem.getUpperItemIDTree() == null || boardItem.getUpperItemIDTree().equals("")) {
				boardItem.setUpperItemIDTree(itemID);
			}
			
			if (boardInfo.getGuBun().equals("3")) {
				boardAdjacent = getAdjacentItems(itemID, boardID, boardItem.getUpperItemIDTree(), boardItem.getParentWriteDate(), userInfo.getTenantId());
			} else {
				boardAdjacent = getAdjacentItemsPhoto(itemID, boardID, boardItem.getUpperItemIDTree(), boardItem.getParentWriteDate(), userInfo.getTenantId());
			}
			
			if (boardAdjacent.getPreviousTitle().equals("")) {
				boardAdjacent.setPreviousTitle(egovMessageSource.getMessage("ezBoard.t330", userInfo.getLocale()));
			}
			
			if (boardAdjacent.getNextTitle().equals("")) {
				boardAdjacent.setNextTitle(egovMessageSource.getMessage("ezBoard.t331", userInfo.getLocale()));
			}
		}
		
		if (boardInfo.getBoardName() != null && !boardInfo.getBoardName().equals("")) {
			boardInfo.setBoardName(commonUtil.cleanValue(boardInfo.getBoardName()));
		}
		
		if (boardInfo.getBoardName1() != null && !boardInfo.getBoardName1().equals("")) {
			boardInfo.setBoardName1(commonUtil.cleanValue(boardInfo.getBoardName1()));
		}
		
		if (boardInfo.getBoardName2() != null && !boardInfo.getBoardName2().equals("")) {
			boardInfo.setBoardName2(commonUtil.cleanValue(boardInfo.getBoardName2()));
		}
		
		boardItem.setWriteDate(commonUtil.getDateStringInUTC(boardItem.getWriteDate(), userInfo.getOffset(), false));
		boardItem.setEndDate(commonUtil.getDateStringInUTC(boardItem.getEndDate(), userInfo.getOffset(), false));
		boardItem.setParentWriteDate(commonUtil.getDateStringInUTC(boardItem.getParentWriteDate(), userInfo.getOffset(), false));
		if (!StringUtils.isBlank(boardItem.getUpdateDate())) {
			boardItem.setUpdateDate(commonUtil.getDateStringInUTC(boardItem.getUpdateDate(), userInfo.getOffset(), false));
		}
		
		// 2017.12.29 강민수92 댓글 갯수 구하기
		if (boardProperty.getOneLineReply() != null && !boardProperty.getOneLineReply().equals("") && !boardProperty.getOneLineReply().equals("0")) {
			String commentCount = ezBoardService.getOneLineReplyCount(boardID, itemID, userInfo.getTenantId());
			model.addAttribute("commentCount", commentCount);
		}
		
		/* 2019-04-05 홍승비 - 해당 게시물에 대해 사용자가 좋아요를 표시했는지 체크 */
		String isLikeChecked = ezBoardService.likeCheck(userInfo.getId(), itemID, userInfo.getTenantId());
		/* 2023-03-20 기민혁 - 해당 게시물에 대해 사용자가 싫어요를 표시했는지 체크 */
		String isDisLikeChecked = ezBoardService.disLikeCheck(userInfo.getId(), itemID, userInfo.getTenantId());
		//2018.08.08 캐비넷 추가
		String use_cabinet = ezCommonService.getTenantConfig("useCabinet", userInfo.getTenantId());
		if (use_cabinet.equals("YES")) {
			use_cabinet = cabinetAdminService.checkModuleActive("board", userInfo);
		}
		/* 2023-05-03 기민혁 - 해당 게시물에 대해 사용자가 스크랩을 했는지 체크 */ 
		String isScrap = ezBoardService.getScrapItemCount(userInfo.getId(), itemID, boardID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		List<BoardKeywordVO> keywordList = new ArrayList<>();
		if (boardInfo.getUseKeyword() != null && boardInfo.getUseKeyword().equals("Y")) {
			keywordList = ezBoardService.selectBoardKeywordByBoardItem(boardItem.getItemID(), boardItem.getBoardID(), userInfo.getTenantId());
		}

		Map<String, Object> itemStarRating = ezBoardService.getItemStarRating(itemID, userInfo.getId(), userInfo.getTenantId());
		
		/* 2018-06-20 홍승비 - 포토/썸네일 승인게시판 게시물 apprFlag 수정 */
		model.addAttribute("boardAdjacent", boardAdjacent);
		model.addAttribute("itemID", itemID);
		model.addAttribute("apprFlag", boardItem.getApprFlag());
		model.addAttribute("boardID", boardID);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("useOCS", useOCS);
		model.addAttribute("boardItem", boardItem);
		model.addAttribute("adjacentItemsEnableFlag", adjacentItemsEnableFlag);
		model.addAttribute("showAdjacent", showAdjacent);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("oneLineReplyFlag", boardProperty.getOneLineReply());
		model.addAttribute("publicModulus", publicModulus);
		model.addAttribute("publicExponent", publicExponent);
		model.addAttribute("isLikeChecked", isLikeChecked);
		model.addAttribute("useCabinet", use_cabinet);
		model.addAttribute("isDisLikeChecked", isDisLikeChecked);
		model.addAttribute("keywordList", keywordList);
		model.addAttribute("isScrap", isScrap);
		model.addAttribute("MyBoardScrapFlag", ezCommonService.getTenantConfig("MyBoardScrapFlag", userInfo.getTenantId()));
		model.addAttribute("scrapContID", scrapContID);
		model.addAttribute("attachFileNameMaxLength", ezCommonService.getTenantConfig("attachFileNameMaxLength", userInfo.getTenantId()));
		model.addAttribute("itemStarRating", itemStarRating);

		logger.debug("boardItemViewPhoto ended");
		return "ezBoard/boardItemViewPhoto";
	}
	
	/**
	 * 게시판 포토게시물 앞뒤 게시물 표출 Method
	 * @param tenantID 
	 */
	public BoardVO getAdjacentItemsPhoto(String itemID, String boardID, String upperItemIDTree, String parentWriteDate, int tenantID) throws Exception {
		logger.debug("getAdjacentItemsPhoto started");

		BoardVO boardVO = new BoardVO();
		
		if (boardVO.getPreviousItemID().equals("")) {
			List<BoardListVO> adjacentItem = ezBoardService.getAdjacentItems2Photo(boardID, parentWriteDate, tenantID);
			
			for (int k = 0; k < adjacentItem.size(); k++) {
				if (adjacentItem.get(k).getItemID().equals(itemID)) {
					boardVO.setPreviousItemID(adjacentItem.get(k - 1).getItemID());
					boardVO.setPreviousTitle(adjacentItem.get(k - 1).getTitle());
				}
			}
		}
		
		if (boardVO.getNextItemID().equals("")) {
			List<BoardListVO> adjacentItem = ezBoardService.getAdjacentItems3Photo(boardID, parentWriteDate, tenantID);
			
			for (int k = 0; k < adjacentItem.size(); k++) {
				if (adjacentItem.get(k).getItemID().equals(itemID)) {
					boardVO.setNextItemID(adjacentItem.get(k + 1).getItemID());
					boardVO.setNextTitle(adjacentItem.get(k + 1).getTitle());
				}
			}
		}
		
		boardVO.setPreviousTitle(commonUtil.cleanValue(boardVO.getPreviousTitle()));
		boardVO.setNextTitle(commonUtil.cleanValue(boardVO.getNextTitle()));

		logger.debug("getAdjacentItemsPhoto ended");
		return boardVO;
	}

	/**
	 * 게시판 일반게시판 앞뒤게시물 표출 Method
	 * @param tenantID 
	 */
	public BoardVO getAdjacentItems(String itemID, String boardID, String upperItemIDTree, String parentWriteDate, int tenantID) throws Exception {
		logger.debug("getAdjacentItems started");

		BoardVO boardVO = new BoardVO();
		String tempItemID = "";
		String tempTitle = "";
		
		List<BoardListVO> adjacentItem = ezBoardService.getAdjacentItems1(boardID, parentWriteDate, upperItemIDTree.substring(0, 38), tenantID);
		
		for (int i = 0; i < adjacentItem.size(); i++) {
			if (adjacentItem.get(i).getItemID().equals(itemID)) {
				boardVO.setPreviousItemID(tempItemID);
				boardVO.setPreviousTitle(tempTitle);
			}
			
			if (adjacentItem.get(i).getItemID().equals(itemID) && i < (adjacentItem.size() - 1)) {
				boardVO.setNextItemID(adjacentItem.get(i+1).getItemID());
				boardVO.setNextTitle(adjacentItem.get(i+1).getTitle());
			}
			
			tempItemID = adjacentItem.get(i).getItemID();
			tempTitle = adjacentItem.get(i).getTitle();
		}
		
		if (boardVO.getPreviousItemID().equals("")) {
			adjacentItem = ezBoardService.getAdjacentItems2(boardID, parentWriteDate, tenantID);
			
			for (int j = 0; j < adjacentItem.size() - 1; j++) {
				if (adjacentItem.get(j).getItemID().equals(itemID)) {
					boardVO.setPreviousItemID(adjacentItem.get(j+1).getItemID());
					boardVO.setPreviousTitle(adjacentItem.get(j+1).getTitle());
				}
			}
		}
		
		if (boardVO.getNextItemID() != null && boardVO.getNextItemID().equals("")) {
			adjacentItem = ezBoardService.getAdjacentItems3(boardID, parentWriteDate, itemID, upperItemIDTree.substring(0, 38), boardVO.getPreviousItemID(), tenantID);
			
			if (adjacentItem.size() > 0) {
				boardVO.setNextItemID(adjacentItem.get(0).getItemID());
				boardVO.setNextTitle(adjacentItem.get(0).getTitle());
			}
		}
		boardVO.setPreviousTitle(commonUtil.cleanValue(boardVO.getPreviousTitle()));
		boardVO.setNextTitle(commonUtil.cleanValue(boardVO.getNextTitle()));

		logger.debug("getAdjacentItems ended");
		return boardVO;
	}

	/**
	 * 게시판 섬네일리스트 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardItemListThumbnail.do", method = RequestMethod.GET)
	public String boardItemListThumbnail(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("boardItemListThumbnail started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String mode = "new";
		String apprFlag = "Y";
		String useOCS = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId());
		String useRunTime = ezCommonService.getTenantConfig("USERUNTIME", userInfo.getTenantId());
		String boardID = request.getParameter("boardID");
		String boardType = request.getParameter("boardType");
		String adminType = request.getParameter("adminType");
		String buttonHidden = "N";
		String boardName = request.getParameter("boardName");
		String boardViewForm = request.getParameter("boardViewForm");
		String useOneLineCount = "NO";
		String sortBy = "";
		int page = 0;
		
		if (request.getParameter("buttonHidden") != null) {
			buttonHidden = request.getParameter("buttonHidden");
		}
		/* 2020-05-04 홍승비 - 썸네일, 앨범형식보기 분기 파라미터 추가 (디폴트는 thumbnail) */
		if (request.getParameter("boardViewForm") == null) {
			boardViewForm = "thumbnail";
		}
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		BoardPropertyVO boardProperty = ezBoardService.getBoardProperty(boardID, userInfo.getTenantId());
		
		if (boardInfo.getListView_FG().equals("true")) {
			// 2024-08-22 조소정 - 게시판 리스트 호출 시 게시판 이름 사용자 설정 언어로 표출
			String userLang = userInfo.getLang();
			boardName = boardInfo.getBoardName(); // 기본값은 한국어로 설정

			if (userLang.equals("2") && boardInfo.getBoardName2() != null && !boardInfo.getBoardName2().isEmpty()) {
				boardName = boardInfo.getBoardName2();
			} else if (userLang.equals("3") && boardInfo.getBoardName3() != null && !boardInfo.getBoardName3().isEmpty()) {
				boardName = boardInfo.getBoardName3();
			} else if (userLang.equals("4") && boardInfo.getBoardName4() != null && !boardInfo.getBoardName4().isEmpty()) {
				boardName = boardInfo.getBoardName4();
			}
			
			if (request.getParameter("sortBy") != null) {
				sortBy = request.getParameter("sortBy");
			}
			
			if (request.getParameter("page") == null) {
				page = 1;
			} else {
				page = Integer.parseInt(request.getParameter("page"));
			}
		}
		
		// 현재 자신의 회사에서 즐겨찾기한 게시판 + 그룹사 게시판의 즐겨찾기 여부를 체크
		String isMyBoard = "";
		int isMyBoardExist = ezBoardService.getIsMyBoardExist(boardID, userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
		if (isMyBoardExist > 0) {
			isMyBoard = "YES";
		}
		String endDateOption = checkEndDateConfig(boardInfo, userInfo);

		model.addAttribute("mode", mode);
		model.addAttribute("apprFlag", apprFlag);
		model.addAttribute("useOCS", useOCS);
		model.addAttribute("useRunTime", useRunTime);
		model.addAttribute("boardID", boardID);
		model.addAttribute("boardType", boardType);
		model.addAttribute("adminType", adminType);
		model.addAttribute("buttonHidden", buttonHidden);
		model.addAttribute("boardName", commonUtil.cleanValue(boardName).replace("\\", "&#92;"));
		model.addAttribute("useOneLineCount", useOneLineCount);
		model.addAttribute("sortBy", sortBy);
		model.addAttribute("page", page);
		model.addAttribute("boardProperty", boardProperty);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("boardViewForm", boardViewForm);
		model.addAttribute("isMyBoard", isMyBoard);
		model.addAttribute("endDateOption", endDateOption);
		model.addAttribute("useKeyword", boardInfo.getUseKeyword());
		model.addAttribute("MyBoardScrapFlag", ezCommonService.getTenantConfig("MyBoardScrapFlag", userInfo.getTenantId()));

		logger.debug("boardItemListThumbnail ended");
		return "ezBoard/boardItemListThumbnail";
	}
	
	/**
	 * 게시판 포토게시물 게시하기 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/newBoardItemPhoto.do", method = RequestMethod.GET)
	public String newBoardItemPhoto(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("newBoardItemPhoto started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String userID = "";
		String userEditor = ezCommonService.getTenantConfig("MODULEEDITOR", userInfo.getTenantId());
		String boardID = request.getParameter("boardID");
		String url = request.getParameter("url");
		String boardType = request.getParameter("bType");
		String browser = ClientUtil.getClientInfo(request, "browser");
		boolean isCrossBrowser = browser.equals("IE9") ? false : true;
		String uploadFilePath = "";
		String strNow = "";
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		
		if (boardInfo.getWrite_FG().equals("false")) {
			return "main/warning"; 
		}
		
		String guBun = boardInfo.getGuBun();
		String paramGuBun = request.getParameter("gubun");
		
		if (!Arrays.asList("3", "4").contains(guBun) || (StringUtils.isNotEmpty(paramGuBun) && !guBun.equals(paramGuBun))) {
			model.addAttribute("gubunExchanged", "Y");
			return "main/warning_board";
		}
		
		uploadFilePath = commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId());
		strNow = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
		
		/* 2019-08-06 홍승비 - 포토/썸네일 게시물 작성 시 작성자 이름 다국어 처리 */
		if (userInfo.getPrimary().equals("1")) {
			userID = userInfo.getDisplayName1();
		} else {
			userID = userInfo.getDisplayName2();
		}
		
		// 2024-08-22 조소정 - 게시판 리스트 호출 시 게시판 이름 사용자 설정 언어로 표출
		String userLang = userInfo.getLang();		
		String boardName = boardInfo.getBoardName(); // 기본값은 한국어로 설정

		if (userLang.equals("2") && boardInfo.getBoardName2() != null && !boardInfo.getBoardName2().isEmpty()) {
			boardName = boardInfo.getBoardName2();
		} else if (userLang.equals("3") && boardInfo.getBoardName3() != null && !boardInfo.getBoardName3().isEmpty()) {
			boardName = boardInfo.getBoardName3();
		} else if (userLang.equals("4") && boardInfo.getBoardName4() != null && !boardInfo.getBoardName4().isEmpty()) {
			boardName = boardInfo.getBoardName4();
		}
		
		String displayName = "";
		if (userInfo.getPrimary().equals("1")) {
			displayName = userInfo.getDisplayName1();
		} else {
			displayName = userInfo.getDisplayName2();
		}
		
		String deptName = "";
		if (userInfo.getPrimary().equals("1")) {
			deptName = userInfo.getDeptName1();
		} else {
			deptName = userInfo.getDeptName2();
		}

		model.addAttribute("userID", userID);
		model.addAttribute("userEditor", userEditor);
		model.addAttribute("boardID", boardID);
		model.addAttribute("url", url);
		model.addAttribute("boardType", boardType);
		model.addAttribute("uploadFilePath", uploadFilePath);
		model.addAttribute("strNow", strNow);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("isCrossBrowser", isCrossBrowser);
		model.addAttribute("boardName", boardName);
		model.addAttribute("useKeyword", boardInfo.getUseKeyword());
		model.addAttribute("displayName", displayName);
		model.addAttribute("deptName", deptName);
		if ("Y".equals(boardInfo.getWriterFlag())) {
			model.addAttribute("writerOption", ezBoardService.getWriterOption(userInfo));
		}

		logger.debug("newBoardItemPhoto ended");
		return "ezBoard/boardNewItemPhoto";
	}
	
	/**
	 * 게시판 게시물이미지업로드 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardImageUpload.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String imageUpload(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("imageUpload started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String mode = commonUtil.stripScriptTags(request.getParameter("mode"));
		String pFileLimit = request.getParameter("fileLimit");
		String uniqueIDs = request.getParameter("uniqueIDs");
		String realPath = commonUtil.getRealPath(request);
		String dirPath = "";
		String serverPath = "";
		String resultUpload = "";
		String fileName = "";
		String fileLocation = "";
		String thumbnailName = "";
		long fileSize = 0;
		boolean isImage = false;
		List<MultipartFile> multiFile = null;
		String fileExt = "";
		
		if (mode.equals("PICTURE")) {
			multiFile = request.getFiles("file1");
			dirPath = realPath + commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", userInfo.getTenantId());
			serverPath = dirPath + commonUtil.separator;
		} else if (mode.equals("DEL")) {
			String delServerPath = realPath + commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", userInfo.getTenantId());
			String imagePath = "";
			String s_imagePath = "";
			String unique_ID = "";
			
			for (int i = 0; i < uniqueIDs.split(";").length; i++) {
				unique_ID = uniqueIDs.split(";")[i];
				imagePath = delServerPath + commonUtil.separator + unique_ID;
				s_imagePath = delServerPath + commonUtil.separator + "s_" + unique_ID;
				File file = new File(commonUtil.detectPathTraversal(imagePath));
				File file1 = new File(commonUtil.detectPathTraversal(s_imagePath));
				
				if (file.exists()) {
					deleteFile(imagePath);
				}
				
				if (file1.exists()) {
					deleteFile(s_imagePath);
				}
			}
			
			return "DEL";
		} else if (mode.equals("THUMBNAIL")) { 
			multiFile = request.getFiles("file2");
			dirPath = realPath + commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", userInfo.getTenantId());
			serverPath = dirPath + commonUtil.separator;
		} else {
			multiFile = request.getFiles("file1");
			dirPath = realPath + commonUtil.getUploadPath("upload_personal.PHOTOTEMP", userInfo.getTenantId());
			serverPath = dirPath + commonUtil.separator;
		}
		
		StringBuffer strXML = new StringBuffer();

		if (multiFile != null) {
			/* 2021-12-08 홍승비 - 포토, 썸네일 게시물 이미지 업로드 시 서버단에서도 이미지 확장자 체크 진행 */
			String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", userInfo.getTenantId());
			boolean isExtOK = true;
			for (int i = 0; i < multiFile.size(); i++) {
				String orgName = multiFile.get(i).getOriginalFilename();
				fileExt = orgName.substring(orgName.lastIndexOf(".") + 1, orgName.length());
				logger.debug("imageUpload file extension is : " + fileExt);
				
				if (commonUtil.checkImgExtension(fileExt.toLowerCase()) == false || (!useExtension.equals("*") && useExtension.toLowerCase().indexOf(fileExt.toLowerCase()) < 0)) {
					isExtOK = false;
					break;
				}
			}
			if (isExtOK == false) {
				logger.debug("imageUpload failed, checkImgExtension return false");
				
				return "UPLOAD_EXT_ERROR;" + multiFile.size();	
			}
			
			String uniqueName = "";
			File file = new File(commonUtil.detectPathTraversal(serverPath));
			
			if (!file.exists()) {
				file.mkdirs();
			}
						
			strXML.append("<ROOT><NODES>");
			
			if (pFileLimit == null || pFileLimit.equals("0") || pFileLimit.equals("")) {
				pFileLimit = "2";
			}
			
			long fileLimit = Long.parseLong(pFileLimit) * 1024 * 1024;
			
			for (int i = 0; i < multiFile.size(); i++) {
				fileSize = multiFile.get(i).getSize();
				if (fileSize > fileLimit) {
					resultUpload = "overflow";
					strXML.append("<NODE><PUPLOADSN><![CDATA[" + uniqueName + "]]></PUPLOADSN>");
					strXML.append("<RESULTUPLOADA><![CDATA[" + resultUpload + "]]></RESULTUPLOADA>");
					strXML.append("<PFILENAME><![CDATA[" + fileName + "]]></PFILENAME>");
					strXML.append("<FILESIZE>" + fileSize + "</FILESIZE>");
					strXML.append("<FILELOCATION><![CDATA[" + fileLocation + "]]></FILELOCATION>");
					strXML.append("<MODE><![CDATA[" + mode + "]]></MODE>");
					strXML.append("</NODE>");
				} else {
					if (multiFile.get(i).getOriginalFilename() != null && !multiFile.get(i).getOriginalFilename().equals("")) {
						String pFileName = multiFile.get(i).getOriginalFilename();
						
						if (pFileName.indexOf(commonUtil.separator.toString()) > 0) {
							pFileName = pFileName.split("/")[pFileName.split("/").length - 1];
						}
						
						fileName = commonUtil.cleanValue(pFileName);
					}
	//				fileName = fileName.replace("+", "%2b");
	//				fileName = fileName.replace(";", "%3b");
					
					/* 2018-09-20 홍승비 - 이미지 등록 시 3자리 이상 확장자 잘리는 문제 수정 */
					String extension = fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length());
					String guid = "{" + UUID.randomUUID().toString() + "}";
					
					uniqueName = guid + "." + extension;
					thumbnailName = "s_" + guid + "." + extension;
					
					writeUploadedFile(multiFile.get(i), uniqueName, serverPath); // 원본 파일을 업로드한 뒤, 아래 코드에서 이미지 형식으로 변환함
					fileLocation = uniqueName;
					File imageFile = new File(commonUtil.detectPathTraversal(serverPath + uniqueName));	
					
					int nImgWidth = 0;
					int nImgHeight = 0;
					
					if (imageFile.exists()) {
						BufferedImage bi = ImageIO.read(imageFile);		
						
						nImgWidth = bi.getWidth();
						nImgHeight = bi.getHeight();
						int nWidth = 0, nHeight = 0;
						
						if (nImgWidth > nImgHeight) {
							nWidth = 200;
							nHeight = (bi.getHeight() * nWidth) / bi.getWidth();
						} else {
							nHeight = 200;
							nWidth = (bi.getWidth() * nHeight) / bi.getHeight();
						}
						
						BufferedImage bufferedImage = null;
						BufferedImage bufferedImageS = null;
						
						if (extension.toUpperCase().equals("TIF") || extension.toUpperCase().equals("TIFF")) {
							extension = "png";
						}
						
						// 기존 이미지가 파일 형태로 업로드되었으므로, 다시 이미지 형태로 저장
						if (bi.getType() == 0 || extension.equals("png")) { // 일부 png 파일의 경우, type값이 0으로 넘어오거나 검은색으로 저장된다.
							bufferedImage = new BufferedImage(bi.getWidth(), bi.getHeight(), BufferedImage.TYPE_4BYTE_ABGR);
						} else {
							bufferedImage = new BufferedImage(bi.getWidth(), bi.getHeight(), bi.getType());
						}
						bufferedImage.createGraphics().drawImage(bi, 0, 0, bi.getWidth(), bi.getHeight(), null);
						isImage = ImageIO.write(bufferedImage, extension, new File(commonUtil.detectPathTraversal(serverPath + uniqueName)));
						
						// 썸네일 저장
						/* 2019-10-21 홍승비 - png파일의 경우, 썸네일 이미지 저장 시 타입을 TYPE_4BYTE_ABGR로 고정 */
						if (bi.getType() == 0 || extension.equals("png")) { // 일부 png 파일의 경우, type값이 0으로 넘어오거나 검은색으로 저장된다.
							bufferedImageS = new BufferedImage(nWidth, nHeight, BufferedImage.TYPE_4BYTE_ABGR);
						} else {
							bufferedImageS = new BufferedImage(nWidth, nHeight, bi.getType());
						}
						bufferedImageS.createGraphics().drawImage(bi, 0, 0, nWidth, nHeight, null);
						isImage = ImageIO.write(bufferedImageS, extension, new File(commonUtil.detectPathTraversal(serverPath + thumbnailName)));
						
						bi.flush();
						bi = null;
						bufferedImage.flush();
						bufferedImage = null;
						bufferedImageS.flush();
						bufferedImageS = null;
					}
					
					if(isImage) {
						resultUpload = "true";
					} else {
						resultUpload = "Not Image file";
					}
					
					strXML.append("<NODE><THUMBNAILNAME><![CDATA[" + thumbnailName + "]]></THUMBNAILNAME>");
					strXML.append("<RESULTUPLOADA><![CDATA[" + resultUpload + "]]></RESULTUPLOADA>");
					strXML.append("<PFILENAME><![CDATA[" + fileName + "]]></PFILENAME>");
					strXML.append("<FILESIZE>" + fileSize + "</FILESIZE>");
					strXML.append("<FILELOCATION><![CDATA[" + serverPath + thumbnailName + "]]></FILELOCATION>");
					strXML.append("<MODE><![CDATA[" + mode + "]]></MODE>");
					strXML.append("<UNIQUEID><![CDATA[" + uniqueName + "]]></UNIQUEID>");
					strXML.append("<OFILENAME><![CDATA[" + multiFile.get(i).getOriginalFilename() + "]]></OFILENAME>");
					strXML.append("</NODE>");
				}
			}
			
			strXML.append("</NODES></ROOT>");
		}

		logger.debug("imageUpload ended");
		return strXML.toString();
	}
	
	/**
	 * 게시판 섬네일정보 실행 Method
	 */
	@RequestMapping(value = "/ezBoard/getBoardThumbnailInfo.do", method = RequestMethod.GET)
	@ResponseBody
	public void getBoardThumbnailInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("getBoardThumbnailInfo started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String type = request.getParameter("type");
		String boardID = commonUtil.detectPathTraversal(request.getParameter("boardID"));
		String fileName = commonUtil.detectPathTraversal(request.getParameter("fileName"));
	//	String realPath = commonUtil.getRealPath(request);
		String pSignatureDir = commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId());
		String filePath = "";
		
		if (type.equals("BOARDTHUM")) {
			pSignatureDir = pSignatureDir + commonUtil.separator + boardID + commonUtil.separator + "uploadFile";
		} else {
			pSignatureDir = commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", userInfo.getTenantId());
		}
		
		filePath = pSignatureDir + commonUtil.separator + fileName;
		
		if (filePath != null && !filePath.equals("")) {
			//logger.debug("filePath : " + filePath + "|| fileName : " + fileName);
			/* 2018-08-13 홍승비 - IE에서 이미지 파일 content-type 수정 */
			//downFile(request, response, realPath + filePath, fileName);
			downImage(filePath, request, response);
		}

		logger.debug("getBoardThumbnailInfo ended");
	}
	
	/**
	 * 게시판 포토게시물저장 실행 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/saveItemPhoto.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String saveItemPhoto(HttpServletRequest request, @RequestBody String resultXML, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("saveItemPhoto started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String result = "";
		String mode = request.getParameter("mode");
		String guBun = request.getParameter("guBun");
		String itemIDs = "";
		String[] itemID = null;
		String realPath = commonUtil.getRealPath(request);
		Document doc = commonUtil.convertStringToDocument(resultXML);
		String mainImageID = doc.getElementsByTagName("MAINIMAGEID").item(0).getTextContent();
		
		BoardPropertyVO boardInfo = getBoardInfo(doc.getElementsByTagName("BOARDID").item(0).getTextContent(), userInfo);
		
		if (!boardInfo.getGuBun().equals(guBun)) {
			return "<RESULT>GUBUNCHANGED</RESULT>";
		}
		
		if (boardInfo.getWrite_FG().equals("false")) {
			return "<RESULT>INACCESSIBLE</RESULT>";
		}
		
		if (guBun.equals("3") || guBun.equals("4") || guBun.equals("7")) {
			itemIDs = doc.getElementsByTagName("ITEMID").item(0).getTextContent();
			itemID = itemIDs.split(";");
			doc.getElementsByTagName("ITEMID").item(0).setTextContent(itemID[0]);
			doc.getElementsByTagName("UPPERITEMIDTREE").item(0).setTextContent(itemID[0]);
		}
		else {
			doc.getElementsByTagName("ITEMID").item(0).setTextContent("");
			doc.getElementsByTagName("UPPERITEMIDTREE").item(0).setTextContent("");
		}
		
		doc.getElementsByTagName("ENDDATE").item(0).setTextContent(doc.getElementsByTagName("ENDDATE").item(0).getTextContent().substring(0, 10) + " 23:59:59");
		doc.getElementsByTagName("CONTENT").item(0).setTextContent(doc.getElementsByTagName("CONTENT").item(0).getTextContent());
		
		if (!mode.equals("temp")) {
			mode = "New";
		}
		
/*		doc.getElementsByTagName("ITEMID").item(0).setTextContent(itemID[0]);
		doc.getElementsByTagName("UPPERITEMIDTREE").item(0).setTextContent(itemID[0]);*/
		
		result = ezBoardService.newItemPhoto(doc, mode, realPath, userInfo, mainImageID);

		logger.debug("saveItemPhoto ended");
		return "<RESULT>" + result + "</RESULT>";
	}

	/**
	 * 게시판 승인유저리스트 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/get_apprUserList.do", method = RequestMethod.POST, produces="text/xml;charset=utf-8")
	@ResponseBody
	public String get_apprUserList(HttpServletRequest request, HttpServletResponse response, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("get_apprUserList started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("pBoardID");
		
		List<BoardVO> list = ezBoardService.get_apprUserList(boardID, userInfo.getTenantId());
		
		StringBuilder result = new StringBuilder("<NODES>");
		
		for (int i=0; i < list.size(); i++) {
			BoardVO vo = list.get(i);
			
			result.append("<NODE>");
			result.append("<BOARDID>" + vo.getBoardId() + "</BOARDID>");
			result.append("<APPRUSERID>" + vo.getApprUserId() + "</APPRUSERID>");
			result.append("<DISPLAYNAME>" + commonUtil.cleanValue(vo.getBoardName()) + "</DISPLAYNAME>");
			result.append("<DISPLAYNAME2>" + commonUtil.cleanValue(vo.getBoardType()) + "</DISPLAYNAME2>");
			result.append("<DESCRIPTION>" + commonUtil.cleanValue(vo.getOrderCell()) + "</DESCRIPTION>");
			result.append("<DESCRIPTION2>" + commonUtil.cleanValue(vo.getOrderOption()) + "</DESCRIPTION2>");
			result.append("</NODE>");
		}
		
		result.append("</NODES>");

		logger.debug("get_apprUserList ended");
		return result.toString();
	}
	
	/**
	 * 게시판 이미지리스트 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/imageViewList.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String imageViewList(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("imageViewList started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String itemID = request.getParameter("itemID");
		String boardID = request.getParameter("boardID");
		String realPath = commonUtil.getRealPath(request);
		String g_ImageUrl = "";
		int imageCnt = 10;
		int page = Integer.parseInt(request.getParameter("page")); // page = 0인 경우, photoViewDB에서 분기 체크하여 모든 이미지를 가져오도록 함
		int pStartRow = Math.addExact(Math.multiplyExact(Math.subtractExact(page, 1), imageCnt), 1);
		int pEndRow = Math.multiplyExact(page, imageCnt);
		
		int imageCount = ezBoardService.photoViewDBCount(itemID, boardID, userInfo.getTenantId());
		
		List<BoardAttachVO> photoViewList = ezBoardService.photoViewDB(itemID, boardID, pStartRow, pEndRow, userInfo.getTenantId());
		
		StringBuffer sb = new StringBuffer();
		
		sb.append("<DATA>");
		
		for (int k = 0; k < photoViewList.size(); k++) {
			int idx = photoViewList.get(k).getFilePath().lastIndexOf(commonUtil.separator);
			g_ImageUrl = photoViewList.get(k).getFilePath().substring(0, idx + 1) + photoViewList.get(k).getFilePath().substring(idx + 1);
			
			sb.append("<ROW>");
			sb.append("<IMAGECOUNT>" + imageCount + "</IMAGECOUNT>");
			sb.append("<IMAGEID>" + photoViewList.get(k).getImageID() + "</IMAGEID>");
			sb.append("<FILEPATH>" + commonUtil.cleanValue(g_ImageUrl) + "</FILEPATH>");
			sb.append("<FILECONTENT>" + commonUtil.cleanValue(photoViewList.get(k).getFileContent()) + "</FILECONTENT>");
			sb.append("<FLAG>" + photoViewList.get(k).getFlag() + "</FLAG>");
			sb.append("<IMAGENAME>" + commonUtil.cleanValue(photoViewList.get(k).getImageName()) + "</IMAGENAME>");
			
			String filePath = commonUtil.detectPathTraversal(photoViewList.get(k).getFilePath());
			String orgpDirPath = realPath + filePath;
			String despPath = orgpDirPath.replace("/files/upload_board", "/files/upload_board/tempUploadFile");
			
			File file = new File(orgpDirPath);
			File file2 = new File(despPath);
			File file3 = new File(despPath.replace("s_", ""));
			
			if (file.exists() && !file2.exists()) {
				FileUtils.copyFile(file, file2);
				FileUtils.copyFile(file, file3);
			}
			
			sb.append("</ROW>");
		}
		
		sb.append("</DATA>");

		logger.debug("imageViewList ended");
		return sb.toString();
	}
	
	/**
	 * 게시판 포토게시판이미지추가 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/addImageItem.do", method = RequestMethod.GET)
	public String addImageItem(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("addImageItem started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String itemID = request.getParameter("itemID");
		String boardID = request.getParameter("boardID");
		String browser = ClientUtil.getClientInfo(request, "browser");
		boolean isCrossBrowser = browser.equals("IE9") ? false : true;
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		
		/* 2018-06-11 홍승비 - 사진 추가 시 마지막 imageID 비교를 위해 추가 */
		String lastItemID = ezBoardService.getLastImageID(boardID, itemID, userInfo.getTenantId());
		
		model.addAttribute("itemID", itemID);
		model.addAttribute("boardID", boardID);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("isCrossBrowser", isCrossBrowser);
		model.addAttribute("lastItemID", lastItemID);

		logger.debug("addImageItem ended");
		return "ezBoard/boardAddImageItem";
	}
	
	/**
	 * 게시판 포토게시판 이미지저장 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/saveImageItem.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String saveImageItem(@RequestBody String requestXML, HttpServletRequest request, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("saveImageItem started");

		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String realPath = commonUtil.getRealPath(request);
		String result = ezBoardService.saveImageItem(requestXML, realPath, userInfo);

		logger.debug("saveImageItem ended");
		return result;
	}
	
	/**
	 * 게시판 포토게시물 수정 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/modifyImageItem.do", method = RequestMethod.GET)
	public String modifyImageItem(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("modifyImageItem started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String imageID = request.getParameter("imageID");
		int page = Integer.parseInt(request.getParameter("page"));
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		String guBun = request.getParameter("guBun");
		String imageContent = "";
		String g_ImageUrl = "";
		String listImages = "";
		String mainFg = "";
		int imageCnt = 10;
		int pStartRow = Math.addExact(Math.multiplyExact(Math.subtractExact(page, 1), imageCnt), 1);
		int pEndRow = Math.multiplyExact(page, imageCnt);
		String browser = ClientUtil.getClientInfo(request, "browser");
		boolean isCrossBrowser = browser.equals("IE9") ? false : true;
		
		List<BoardAttachVO> photoViewList = ezBoardService.photoViewDB(itemID, boardID, pStartRow, pEndRow, userInfo.getTenantId());
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		
		for (int k = 0; k < photoViewList.size(); k++) {
			String listImage = photoViewList.get(k).getImageID();
			
			if (imageID.equals(listImage)) {
				imageContent = commonUtil.cleanValue(photoViewList.get(k).getFileContent());
				String filePath = photoViewList.get(k).getFilePath();
				int idx = filePath.lastIndexOf(commonUtil.separator);
				
				g_ImageUrl = filePath.substring(0, idx + 1) + filePath.substring(idx + 1);
				listImages = "/ezBoard/getBoardThumbnailInfo.do?type=BOARDTHUM&boardID=" + boardID + "&fileName=" + g_ImageUrl.split("/")[7].replace("s_", "");
				mainFg = photoViewList.get(k).getFlag();
			}
		}
		
		model.addAttribute("listCount", photoViewList.size());
		model.addAttribute("listImage", imageID);
		model.addAttribute("listImages", listImages);
		model.addAttribute("imageContent", imageContent);
		model.addAttribute("boardID", boardID);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("isCrossBrowser", isCrossBrowser);
		model.addAttribute("mainFg", mainFg);
		model.addAttribute("itemID", itemID);
		model.addAttribute("guBun", guBun);
		model.addAttribute("orgImagePath", listImages);

		logger.debug("modifyImageItem ended");
		return "ezBoard/boardModifyImageItem";
	}
	
	/**
	 * 게시판 포토게시물 삭제 실행 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/deleteImageItem.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String deleteImageItem(HttpServletRequest request, @RequestBody String resultXML, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("deleteImageItem started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String imageID = "";
		String boardID = "";
		String filePath = "";
		String mod = "";
		String content = "";
		String oFileName = "";
		String rtnValue = "";
		String gubun = "";
		String modifyThumb = request.getParameter("modifyThumb") != null ? request.getParameter("modifyThumb") : "";
		String modifyMovie = request.getParameter("modifyMovie") != null ? request.getParameter("modifyMovie") : "";
		
		Document doc = commonUtil.convertStringToDocument(resultXML);
		
		mod = request.getParameter("mod");
		gubun = request.getParameter("gubun");
		
		if (mod.equals("Del")) {
			boardID = request.getParameter("boardID");
			imageID = request.getParameter("imageIDs");
			
			String[] tempImageID = imageID.split(";");
			
			try {
				for (int k = 0; k < tempImageID.length; k++) {
					ezBoardService.photoListDel(boardID, tempImageID[k], userInfo.getTenantId());
				}
				
				rtnValue = "OK";
			} catch (Exception e) {
				logger.error("EzBoard :: deleteImageItem");
				logger.error(e.getMessage(), e);
				rtnValue = "ERROR";
			}
		} else if (mod.equals("Mod")) {
			String uploadFilePath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId());
			String mainFg = doc.getElementsByTagName("MAINFG").item(0).getTextContent();
			
			boardID = commonUtil.detectPathTraversal(doc.getElementsByTagName("BOARDID").item(0).getTextContent());
			imageID = doc.getElementsByTagName("IMAGEID").item(0).getTextContent();
			filePath = commonUtil.detectPathTraversal(doc.getElementsByTagName("FILEPATH").item(0).getTextContent());
			content = doc.getElementsByTagName("CONTENT").item(0).getTextContent();
			oFileName = doc.getElementsByTagName("OFILENAME").item(0).getTextContent();
			String addThumbnail = "";
			
			if (doc.getElementsByTagName("ADDTHUMBNAIL").item(0) != null && !doc.getElementsByTagName("ADDTHUMBNAIL").item(0).getTextContent().equals("")) {
				addThumbnail = doc.getElementsByTagName("ADDTHUMBNAIL").item(0).getTextContent();
			}
			
			String thumbnailExt = "png";
			
			if (doc.getElementsByTagName("EXT").item(0) != null && !doc.getElementsByTagName("EXT").item(0).getTextContent().equals("")) {
				thumbnailExt = doc.getElementsByTagName("EXT").item(0).getTextContent();
			}
			
			String file_Path = "";
			
			if (!filePath.equals("")) {
				String tempFilePath = uploadFilePath + commonUtil.separator + filePath;
				File file = new File(tempFilePath);
				
				if (file.exists()) {
					file_Path = uploadFilePath + commonUtil.separator + boardID + commonUtil.separator + "uploadFile" + filePath.replace("tempUploadFile", "");
				}
				
				FileUtils.copyFile(file, new File(file_Path));
				deleteFile(tempFilePath);
				
				if (filePath.indexOf("s_") > -1) {
					tempFilePath = uploadFilePath + commonUtil.separator + filePath.replace("s_", "");
					File file2 = new File(tempFilePath);
					
					if (file2.exists()) {
						filePath = uploadFilePath + commonUtil.separator + boardID + commonUtil.separator + "uploadFile" + filePath.replace("s_", "").replace("tempUploadFile", "");
					}
					
					FileUtils.copyFile(file2, new File(filePath));
					deleteFile(tempFilePath);
				}
				
				/* 2018-11-07 홍승비 - 동영상 게시물의 경우, 동영상 수정 시 동일한 s_{GUID}로 생성된 썸네일 복사 */
				if (!(modifyMovie.equals("Y") && addThumbnail.equals("Y"))) {
					if (gubun != null && gubun.equals("7")) {
						String s_file_Path = "";
						String s_tempFilePath = uploadFilePath + commonUtil.separator + filePath.replace("/{", "/s_{");
						s_tempFilePath = s_tempFilePath.substring(0, s_tempFilePath.lastIndexOf(".")) + "." + thumbnailExt;
						File s_file = new File(s_tempFilePath);
						
						if (s_file.exists()) {
							s_file_Path = uploadFilePath + commonUtil.separator + boardID + commonUtil.separator + "uploadFile" + filePath.replace("tempUploadFile", "").replace("/{", "/s_{");
							s_file_Path = s_file_Path.substring(0, s_file_Path.lastIndexOf(".")) + "." + thumbnailExt;
						}
						
						FileUtils.copyFile(s_file, new File(s_file_Path));
						deleteFile(s_tempFilePath);	
					}
				} else {
					String orgThumb = doc.getElementsByTagName("ORGTHUMB").item(0).getTextContent();
					String orgThumbPath = "s_" + orgThumb.substring(0, orgThumb.lastIndexOf(".")) + "." + thumbnailExt;
					String thumbPath = filePath.replace("tempUploadFile", "");
					String moveThumbPath = thumbPath.substring(0, thumbPath.lastIndexOf(".")).replace("/{", "/s_{") + "." + thumbnailExt;
					File orgThumbFile = new File(uploadFilePath + commonUtil.separator + boardID + commonUtil.separator + "uploadFile" + commonUtil.separator + orgThumbPath);
					File moveThumbFile = new File(uploadFilePath + commonUtil.separator + boardID + commonUtil.separator + "uploadFile" + moveThumbPath);
					
					FileUtils.copyFile(orgThumbFile, moveThumbFile);
				}
			}
			
			if (!filePath.equals("")) {
				file_Path = file_Path.replace(commonUtil.getRealPath(request), "");
			} else {
				file_Path = "";
			}
			
			if (!modifyThumb.equals("Y")) {
				ezBoardService.photoListUpdate(imageID, boardID, content, file_Path, doc.getElementsByTagName("ITEMID").item(0).getTextContent(), mainFg, oFileName, userInfo.getTenantId());
			} else {
				ezBoardService.thumbnailUpdate(imageID, boardID, userInfo.getTenantId(), thumbnailExt, oFileName, addThumbnail);
			}
			
			String itemID = request.getParameter("itemID");
			ezBoardService.modUpdateDate(commonUtil.getTodayUTCTime(""), itemID, userInfo.getId(), userInfo.getTenantId());
			
			return "OK";
			
		} else if (mod.equals("add")) {
			String itemID = doc.getElementsByTagName("ITEMID").item(0).getTextContent();
			String title = doc.getElementsByTagName("TITLE").item(0).getTextContent();
			boardID = doc.getElementsByTagName("BOARDID").item(0).getTextContent();
			content = doc.getElementsByTagName("CONTENT").item(0).getTextContent();
			
			ezBoardService.photoListAlbumEdit(boardID, itemID, title, content, userInfo.getTenantId());
			ezBoardService.modUpdateDate(commonUtil.getTodayUTCTime(""), itemID, userInfo.getId(), userInfo.getTenantId());
			
			// 키워드 저장
			List<String> keywords = new ArrayList<>();
			NodeList keywordNodeList = doc.getElementsByTagName("KEYWORD");
			if (keywordNodeList != null && keywordNodeList.getLength() > 0) {
				for (int i = 0; i < keywordNodeList.getLength(); i++) {
					keywords.add(keywordNodeList.item(i).getTextContent());
				}

				ezBoardService.saveKeyword(keywords, boardID, itemID, userInfo.getTenantId());
			}
			
			return "OK";
		} else if (mod.equals("temp")) {
			String itemID = doc.getElementsByTagName("ITEMID").item(0).getTextContent();
			String title = doc.getElementsByTagName("TITLE").item(0).getTextContent();
			boardID = doc.getElementsByTagName("BOARDID").item(0).getTextContent();
			content = doc.getElementsByTagName("CONTENT").item(0).getTextContent();
			
			ezBoardService.photoListAlbumEditTemp(boardID, itemID, title, content, userInfo.getTenantId());
			
			return "OK";
		} else {
			/* 2021-01-26 홍승비 - 메인 이미지 플래그와 사진설명 수정을 함께 적용하도록 수정 */
			boardID = doc.getElementsByTagName("BOARDID").item(0).getTextContent();
			content = doc.getElementsByTagName("CONTENT").item(0).getTextContent();
			
			ezBoardService.setMainImageID(doc.getElementsByTagName("IMAGEID").item(0).getTextContent(), doc.getElementsByTagName("ITEMID").item(0).getTextContent(), userInfo.getTenantId());
			ezBoardService.photoListUpdate(doc.getElementsByTagName("IMAGEID").item(0).getTextContent(), boardID, content, "", doc.getElementsByTagName("ITEMID").item(0).getTextContent(), "", "", userInfo.getTenantId());
			
			// 동영상게시판 > 동영상수정의 경우에도 수정시 업데이트
			String itemID = request.getParameter("itemID");
			ezBoardService.modUpdateDate(commonUtil.getTodayUTCTime(""), itemID, userInfo.getId(), userInfo.getTenantId());
			
			return "OK";
		}

		logger.debug("deleteImageItem ended");
        return rtnValue;
	}
	
	/**
	 * 게시판 포토게시물삭제 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardItemDelete.do", method = RequestMethod.GET)
	public String boardItemDelete(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("boardItemDelete started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String itemID = request.getParameter("itemID");
		String boardID = request.getParameter("boardID");
		String isAllGroupBoard = request.getParameter("isAllGroupBoard");
		String boardIDEncode = URLEncoder.encode(boardID, "UTF-8");
		String g_ImageUrl = "";
		StringBuilder listImages = new StringBuilder();
		StringBuilder imageID = new StringBuilder();
		StringBuilder imageContent = new StringBuilder();
		StringBuilder mainFg = new StringBuilder();
		
		List<BoardAttachVO> photoViewList = ezBoardService.photoViewDBAll(itemID, boardID, userInfo.getTenantId());
		
		int imageCount = photoViewList.size();
		
		for (int k = 0; k < imageCount; k++) {
			String filePath = photoViewList.get(k).getFilePath();
			int idx = filePath.lastIndexOf(commonUtil.separator);
			
			g_ImageUrl = filePath.substring(0, idx + 1) + filePath.substring(idx + 1).replace("+", "%20");
			listImages.append("/ezBoard/getBoardThumbnailInfo.do?type=BOARDTHUM&boardID=" + boardIDEncode + "&fileName=" + URLEncoder.encode(g_ImageUrl.split("/")[7], "UTF-8") + "|");
			imageID.append(photoViewList.get(k).getImageID() + ";");
			imageContent.append(photoViewList.get(k).getFileContent() + ";");
			mainFg.append(photoViewList.get(k).getFlag().trim() + ";");
		}
		
		model.addAttribute("imageCount", imageCount);
		model.addAttribute("itemID", itemID);
		model.addAttribute("boardID", boardID);
		model.addAttribute("isAllGroupBoard", isAllGroupBoard);
		model.addAttribute("g_ImageUrl", g_ImageUrl);
		model.addAttribute("listImages", listImages.toString());
		model.addAttribute("imageID", imageID.toString());
		model.addAttribute("imageContent", imageContent.toString());
		model.addAttribute("mainFg", mainFg.toString());

		logger.debug("boardItemDelete ended");
		return "ezBoard/boardItemDelete";
	}
	
	/**
	 * 게시판 포토앨범 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/photoAlbumEdit.do", method = RequestMethod.GET)
	public String photoAlbumEdit() {
		return "ezBoard/boardPhotoAlbumEdit";
	}
	
	/**
	 * 게시판 포토게시판이미지다운 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/imageDownload.do", method = RequestMethod.GET)
	public String imageDownload(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("imageDownload started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String itemID = request.getParameter("itemID");
		String boardID = request.getParameter("boardID");
		String g_ImageUrl = "";
		String listImages = "";
		String imageID = "";
		String imageContent = "";
		String fileName = "";
		String encodeFileHref = "";
		
		List<BoardAttachVO> photoViewList = ezBoardService.photoViewDBAll(itemID, boardID, userInfo.getTenantId());
		
		int imageCount = photoViewList.size();
		
		for (int k = 0; k < imageCount; k++) {
			String filePath = photoViewList.get(k).getFilePath();
			int idx = filePath.lastIndexOf(commonUtil.separator);
			
			g_ImageUrl = filePath.substring(0, idx + 1) + filePath.substring(idx + 1).replace("+", "%20");
			listImages += "/ezBoard/getBoardThumbnailInfo.do?type=BOARDTHUM&boardID=" + URLEncoder.encode(boardID, "UTF-8") + "&fileName=" + URLEncoder.encode(g_ImageUrl.split("/")[7], "UTF-8") + "|";
			imageID += photoViewList.get(k).getImageID() + ";";
			imageContent += photoViewList.get(k).getFileContent() + ";";
			
			/* 2019-07-02 홍승비 - 사진 다운로드 시 원본 사진 저장(s_{...}는 썸네일용 이미지) */
			filePath = filePath.replace("s_", "");
			
			if (photoViewList.get(k).getImageName().split("/").length > 1) {
				fileName += photoViewList.get(k).getImageName().split("/")[3] + "|";
				encodeFileHref += "/ezBoard/boardAttachDown.do?filePath=" + URLEncoder.encode(filePath, "UTF-8") + "&fileName=" + URLEncoder.encode((g_ImageUrl.split("/")[7]).replace("s_", ""), "UTF-8") +
						"&attID=" + URLEncoder.encode(photoViewList.get(k).getImageName().split("/")[3], "UTF-8") + "|";
			} else {
				fileName += photoViewList.get(k).getImageName() + "|";
				encodeFileHref += "/ezBoard/boardAttachDown.do?filePath=" + URLEncoder.encode(filePath, "UTF-8") + "&fileName=" + URLEncoder.encode((g_ImageUrl.split("/")[7]).replace("s_", ""), "UTF-8") +
						"&attID=" + URLEncoder.encode(photoViewList.get(k).getImageName(), "UTF-8") + "|";
			}
		}
		
		model.addAttribute("itemID", itemID);
		model.addAttribute("boardID", boardID);
		model.addAttribute("listImages", listImages);
		model.addAttribute("imageID", imageID);
		model.addAttribute("imageContent", imageContent);
		model.addAttribute("imageCount", imageCount);
		model.addAttribute("fileName", fileName);
		model.addAttribute("encodeFileHref", encodeFileHref);
		
		logger.debug("imageDownload ended");
		return "ezBoard/boardImagedownload";
	}
	
	/**
	 * 게시판 나의게시물 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardItemListMyList.do", method = RequestMethod.GET)
	public String boardItemListMyList(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("boardItemListMyList started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		int page = 1;
		String useOcs = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId()); 
		String useEditor = ezCommonService.getTenantConfig("MODULEEDITOR", userInfo.getTenantId());
		String useRunTime = ezCommonService.getTenantConfig("USERUNTIME", userInfo.getTenantId());
		
		if (request.getParameter("page") != null && !request.getParameter("page").equals("")) {
			page = Integer.parseInt(request.getParameter("page"));
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("page", page);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("useRunTime", useRunTime);
		model.addAttribute("useEditor", useEditor);
		/* 2019-04-12 홍승비 - 마이게시판 댓글갯수 누락 수정 */
		model.addAttribute("use_oneLineCount", "YES");

		logger.debug("boardItemListMyList ended");
		return "ezBoard/boardItemListMyList";
	}
	
	/**
	 * 게시판 게시판트리모달 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/writeBoardSelectModal.do", method = RequestMethod.GET)
	public String writeBoardSelectModal(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("writeBoardSelectModal started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String useEditor = ezCommonService.getTenantConfig("MODULEEDITOR", userInfo.getTenantId());
		
		model.addAttribute("useEditor", useEditor);

		logger.debug("writeBoardSelectModal ended");
		return "ezBoard/boardWriteSelectModal";
	}

	/**
	 * 게시판 게시판트리모달 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/writeBoardSelectModalDotNet.do", method = RequestMethod.GET)
	public String writeBoardSelectModalDotNet(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		String useEditor = ezCommonService.getTenantConfig("MODULEEDITOR", userInfo.getTenantId());
		String dotNetUrl = ezCommonService.getTenantConfig("dotNetUrl", userInfo.getTenantId());
		
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("dotNetUrl", dotNetUrl);
		
		return "ezBoard/boardWriteSelectModalDotNet";
	}
	
	/**
	 * 게시판 게시판트리 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/writeBoardSelect.do", method = RequestMethod.GET)
	public String writeBoardSelect(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("writeBoardSelect started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String useEditor = ezCommonService.getTenantConfig("MODULEEDITOR", userInfo.getTenantId());
		
		model.addAttribute("useEditor", useEditor);

		logger.debug("writeBoardSelect ended");
		return "ezBoard/boardWriteSelect";
	}
	
	/**
	 * 게시판 게시판정보 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/getBoardInfo.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getBoardInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("getBoardInfo started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		String userLang = userInfo.getLang();
		String strXML = "<DATA>";
				
		String boardName = boardInfo.getBoardName();
		if (userLang.equals("1")) {
			boardName = commonUtil.cleanValue(boardName);
		} else if (userLang.equals("2")) {
			boardName = commonUtil.cleanValue(boardInfo.getBoardName2());
		} else if (userLang.equals("3")) {
			boardName = commonUtil.cleanValue(boardInfo.getBoardName3());
		} else if (userLang.equals("4")) {
			boardName = commonUtil.cleanValue(boardInfo.getBoardName4());
		}
		
		strXML += "<BOARDNAME>" + boardName + "</BOARDNAME>";
		strXML += "<ATTACHLIMIT>" + boardInfo.getAttachSizeLimit() + "</ATTACHLIMIT>";
		strXML += "<EXPIREDAYS>" + boardInfo.getExpireDays() + "</EXPIREDAYS>";
		strXML += "<GUBUN>" + boardInfo.getGuBun() + "</GUBUN>";
		strXML += "<FORM>" + ezBoardService.checkForm(boardID, "Y", userInfo.getTenantId()) + "</FORM>";
		strXML += "<BACKIMAGE>" + ezBoardService.checkBackGroundImage(boardID, userInfo.getTenantId()) + "</BACKIMAGE>";
		strXML += "</DATA>";

		logger.debug("getBoardInfo ended");
		return strXML;
	}
	
	/**
	 * 게시판 예약게시물리스트 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardReservedItemList.do", method = RequestMethod.GET)
	public String boardReservedItemList(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("boardReservedItemList started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String useEditor = ezCommonService.getTenantConfig("MODULEEDITOR", userInfo.getTenantId());
		String useRunTime = ezCommonService.getTenantConfig("USERUNTIME", userInfo.getTenantId());
		String orgBoardParameters = "";
		String sortBy = "";
		String boardType = "";
		String adminType = "";
		String boardName = egovMessageSource.getMessage("ezBoard.t229", userInfo.getLocale());
		String isVpn = "";
		int page = 1;
		int totalCount = 0;
		int totalPage = 0;
		
		if (request.getParameter("page") != null) {
			page = Integer.parseInt(request.getParameter("page"));
		}
		
		if (request.getParameter("orgBoardParameters") != null) {
			orgBoardParameters = request.getParameter("orgBoardParameters");
		}
		
		if (request.getParameter("boardType") != null) {
			boardType = request.getParameter("boardType");
		}
		
		if (request.getParameter("adminType") != null) {
			adminType = request.getParameter("adminType");
		}
		
		if (request.getParameter("sortBy") != null) {
			sortBy = request.getParameter("sortBy");
		}
		
		BoardPropertyVO boardInfo = getBoardInfo("", userInfo);
		
		int startRow = Math.addExact(Math.multiplyExact(Math.subtractExact(page, 1), boardInfo.getSs_board_maxRows()), 1);
		int endRow = Math.multiplyExact(page, boardInfo.getSs_board_maxRows());
		
		List<BoardListVO> reservedList = ezBoardService.getReservedItemList(userInfo.getId(), startRow, endRow, sortBy, userInfo.getLang(), userInfo.getOffset(), userInfo.getCompanyID(), userInfo.getTenantId());
		totalCount = ezBoardService.getReservedItemListCount(userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (reservedList == null && page > 1) {
			page -= 1;
			startRow = Math.addExact(Math.multiplyExact(Math.subtractExact(page, 1), boardInfo.getSs_board_maxRows()), 1);
			endRow = Math.multiplyExact(page, boardInfo.getSs_board_maxRows());
			reservedList = ezBoardService.getReservedItemList(userInfo.getId(), startRow, endRow, sortBy, userInfo.getLang(), userInfo.getOffset(), userInfo.getCompanyID(), userInfo.getTenantId());
		}
		
		/* 2019-01-07 홍승비 - split의 정규식 표현 및 페이징 연산 수정 */
		if (totalCount > 0) {
			if (totalCount > boardInfo.getSs_board_maxRows()) {
				String temp = String.valueOf(totalCount / boardInfo.getSs_board_maxRows());
				if (temp.indexOf(".") != 0) {
					totalPage = Integer.parseInt(temp.split("\\.")[0]) + 1;
				} else {
					totalPage = Integer.parseInt(temp);
				}
			} else {
				totalPage = 1;
			}
		} else {
			totalPage = 0;
		}
		
		//strListInfo += pBoardID + "@" + pItemID + "," + SSUserID + ";";
		StringBuilder listInfo = new StringBuilder();
		
		if (reservedList != null) {
			for(int i=0;i<reservedList.size();i++){
				listInfo.append(reservedList.get(i).getBoardID() + "@" + reservedList.get(i).getItemID() + "," + userInfo.getId() + ";");
			}
		}
		
		model.addAttribute("listInfo", listInfo.toString());
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("useRunTime", useRunTime);
		model.addAttribute("orgBoardParameters", orgBoardParameters);
		model.addAttribute("sortBy", sortBy);
		model.addAttribute("boardType", boardType);
		model.addAttribute("adminType", adminType);
		model.addAttribute("boardName", commonUtil.cleanValue(boardName));
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("page", page);
		model.addAttribute("reservedList", reservedList);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("isVpn", isVpn);
		
		logger.debug("boardReservedItemList ended");
		return "ezBoard/boardReservedItemList";
	}
	
	/**
	 * 게시판 임시게시물리스트 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardItemListTemp.do", method = RequestMethod.GET)
	public String boardItemListTemp(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("boardItemListTemp started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String useEditor = ezCommonService.getTenantConfig("MODULEEDITOR", userInfo.getTenantId());
		String useOcs = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId());
		String useRunTime = ezCommonService.getTenantConfig("USERUNTIME", userInfo.getTenantId());
		int page = 1;
		
		if (request.getParameter("page") != null) {
			page = Integer.parseInt(request.getParameter("page"));
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("page", page);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("useRunTime", useRunTime);

		logger.debug("boardItemListTemp ended");
		return "ezBoard/boardItemListTemp";
	}
	
	/**
	 * 게시판 임시게시물 삭제 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/deleteTempItem.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String deleteTempItem(@RequestBody String strItemID, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) throws Exception {
		logger.debug("deleteTempItem started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String mode = "";
		
		if (request.getParameter("mode") != null) {
			mode = request.getParameter("mode");
		}
		
		String resultVal = ezBoardService.deleteTempItem1(mode, strItemID, userInfo.getTenantId());

		logger.debug("deleteTempItem ended");
		return resultVal;
	}
	
	/**
	 * 게시판 게시물설정 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/setBoardConfig.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String setBoardConfig(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("setBoardConfig started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String userID = request.getParameter("pUserID");
		String listCount = request.getParameter("pListCount");
		String preView = request.getParameter("pPreView");
		int tempCount;
		
		/* 2019-02-28 홍승비 - listCount 파라미터가 null인 경우 기존 리스트카운트를 가져오도록 수정 (디폴트 20)*/
		if (listCount != null) {
			tempCount = Integer.parseInt(listCount);
		} else {
			BoardConfigVO tempVO = ezBoardService.getPersonalCount(userInfo);
			tempCount = tempVO.getListCount();
		}
		
		String result = ezBoardService.setBoardConfig(userID, tempCount, preView, userInfo.getTenantId());

		logger.debug("setBoardConfig ended");
		return result;
	}
	
	/**
	 * 게시판 게시물미리보기 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/getPreviewItem.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getPreviewItem(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("getPreviewItem started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String location = "";
		String itemID = "";
		String mode = "";
		String boardID = "";
		
		location = request.getParameter("location"); 		
		itemID = request.getParameter("itemID"); 		
		boardID = request.getParameter("boardID"); 		
		mode = request.getParameter("mode");
		
		if(!mode.equals("storage")){
			String authorization = request.getHeader("Authorization");
			String password = StringUtils.isNotBlank(authorization) ? new String(java.util.Base64.getDecoder().decode(StringUtils.removeStart(authorization, "Basic").trim())) : "";

			if (!accessCheck(boardID, itemID, location, userInfo, password)) {
				return "<DATA>NO</DATA>";
			}
		}
		
		String retXML = "";
		
		 /* 2018-06-29 홍승비 - 게시물 미리보기 > 게시자 사원정보 확인 시 겸직부서인 상태로 정보 보여주도록 수정 */
		if (!mode.equals("temp")) {
			retXML = ezBoardService.getItemXML(boardID, itemID, userInfo.getLang(), userInfo.getOffset(), userInfo.getTenantId());
		} else {
			retXML = ezBoardService.getItemTempXML(boardID, itemID, userInfo.getLang(), userInfo.getOffset(), userInfo.getTenantId());
		}
		
		ezBoardService.setAsRead(userInfo, boardID, itemID);

		logger.debug("getPreviewItem ended");
		return retXML;
	}
	
	/**
	 * 게시판 미리보기게시물 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardItemPreviewContent.do", method = RequestMethod.GET)
	public String boardItemPreviewContent(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("boardItemPreviewContent started");
		
		/* 2019-11-06 홍승비 - 미리보기 시 댓글옵션에 따라 댓글정보 표출해주기 위한 파라미터 추가 */
		userInfo = commonUtil.userInfo(loginCookie);
		String publicModulus = egovFileScrty.getPbm();
        String publicExponent = "10001";
		
		String OneLineReplyFlag = request.getParameter("OneLineReplyFlag");
		String itemID = request.getParameter("itemID");
		String boardID = request.getParameter("boardID");
		String likeCount = request.getParameter("likeCount");
		String disLikeCount = request.getParameter("disLikeCount");
		String tempLocation = request.getParameter("tempLocation");

		if (OneLineReplyFlag == null) {
			OneLineReplyFlag = "";
		}
		
		if(tempLocation == null){
			tempLocation = "N";
		}
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		
		if (!tempLocation.equals("Y") && (boardID == null || boardID.equals("") || !boardInfo.getRead_FG().equals("true"))) {
			model.addAttribute("pPreviewShow_HOW", "W");
        	return "main/warning";
        }
		/* 2019-04-05 홍승비 - 해당 게시물에 대해 사용자가 좋아요를 표시했는지 체크 */
		String isLikeChecked = ezBoardService.likeCheck(userInfo.getId(), itemID, userInfo.getTenantId());
		
		// 2023-05-26 조수빈 - 게시판 첨부파일 미리보기 기능 사용 여부
		String useBoardFilePrvw = ezCommonService.getTenantConfig("useBoardFilePrvw", userInfo.getTenantId());
		// 2023-10-26 조수빈 - 문서변환 솔루션 사용 여부
		String useImageConvertServer = ezCommonService.getTenantConfig("useImageConvertServer", userInfo.getTenantId());
				
		if (useBoardFilePrvw.equals("1") && useImageConvertServer.equals("1")) {
			useBoardFilePrvw = "1";
		} else {
			useBoardFilePrvw = "0";
		}
		
		String itemLocation = "";
		String useEditor = ezCommonService.getTenantConfig("MODULEEDITOR", userInfo.getTenantId());
		if (useEditor.equals("HWP")) {
			itemLocation = ezBoardService.getContentlocation(boardID, itemID, userInfo.getTenantId());
		}
				 
		/* 2022-04-06 기민혁 - 해당 게시물에 대해 사용자가 싫어요를 표시했는지 체크 */
		String isDisLikeChecked = ezBoardService.disLikeCheck(userInfo.getId(), itemID, userInfo.getTenantId());
		
		// 2025-01-23 게시판 > 게시물 미리보기 > 게시물 평가하기 기능 추가
		Map<String, Object> itemStarRating = ezBoardService.getItemStarRating(itemID, userInfo.getId(), userInfo.getTenantId());
		
		List<BoardAttributeVO> boardAttr = new ArrayList<>();
		String extenLang = "1";
		// 2025-05-09 게시판 내용 받기
		BoardListVO boardItem = ezBoardService.getBrdGetItemInfo(boardID, itemID, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
		if (boardInfo.getAttributeYN() != null && boardInfo.getAttributeYN().equals("Y")) {
			boardAttr = ezBoardAdminService.getBoardAttribute(boardID, userInfo.getTenantId());
			if (!commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId()).equals("1")) {
				extenLang = "2";
			}
		}
		
		JsonSerializer<String> stringSerializer = new JsonSerializer<String>() {
			@Override
			public JsonElement serialize(String src, Type typeOfSrc, JsonSerializationContext context) {
				String escapedString = src.replace("\\", "\\\\")
											.replace("\"", "\\\"")
											.replace("/", "\\/");
				return new JsonPrimitive(escapedString);
			}
		};
		Gson gson = new GsonBuilder().registerTypeAdapter(String.class, stringSerializer).create();
		
		// ai 관련 컨피그 추가
		// AI 첨부파일 이름 최대 길이 - 기존 첨부파일과 동일한 값 사용
		String attachFileNameMaxLength = ezCommonService.getTenantConfig("attachFileNameMaxLength", userInfo.getTenantId());
		// AI 사용여부 확인
		boolean useAI = aICommonUtil.checkUseAI(userInfo.getTenantId());
		// AI 챗봇 첨부파일 최대용량
		String aiAttachMBSize = ezCommonService.getTenantConfig("aiAttachMBSize", userInfo.getTenantId());

		/* 게시판 환경설정 > 본문크기설정값 적용 */
		BoardConfigVO boardConfig = ezBoardService.getBoardList_Config(userInfo.getId(), userInfo.getTenantId());
		int contentSize = 100; // 기본값
		double mozContentSize = 1; // 기본값

		if (boardConfig != null) { // 사용자 설정값
			for (int i = 1; i <= 10; i++) {
				if (boardConfig.getContentSize() == i) {
					contentSize = 100 + (i * 10);
					mozContentSize = 1 + (i * 0.1);
					break;
				}
			}
		}
		
		model.addAttribute("OneLineReplyFlag", OneLineReplyFlag);
		model.addAttribute("gubun", boardInfo.getGuBun());
		model.addAttribute("itemID", itemID);
		model.addAttribute("boardID", boardID);
		model.addAttribute("userInfoID", userInfo.getId());
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("likeCount", likeCount);
		model.addAttribute("isLikeChecked", isLikeChecked);
		model.addAttribute("publicModulus", publicModulus);
		model.addAttribute("publicExponent", publicExponent);
		model.addAttribute("useBoardFilePrvw", useBoardFilePrvw);
		model.addAttribute("displayName", userInfo.getDisplayName1());
		model.addAttribute("disLikeCount", disLikeCount);
		model.addAttribute("isDisLikeChecked", isDisLikeChecked);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("itemLocation", itemLocation);
		model.addAttribute("attachFileNameMaxLength", ezCommonService.getTenantConfig("attachFileNameMaxLength", userInfo.getTenantId()));
		model.addAttribute("itemStarRating", itemStarRating);
		model.addAttribute("boardItem", gson.toJson(boardItem));
		model.addAttribute("boardAttr", gson.toJson(boardAttr));
		model.addAttribute("extenLang", extenLang);
		model.addAttribute("boardAttr", gson.toJson(boardAttr));
		model.addAttribute("moduleType", "board");
		model.addAttribute("moduleSubType", "preview");
		model.addAttribute("useAI", useAI);
		model.addAttribute("attachFileNameMaxLength", attachFileNameMaxLength);
		model.addAttribute("aiAttachMBSize", aiAttachMBSize);
		model.addAttribute("contentSize", contentSize);
		model.addAttribute("mozContentSize", mozContentSize);
		
		logger.debug("boardItemPreviewContent ended");
		return "ezBoard/boardItemPreviewContent";
	}
	
	/**
	 * 게시판 첨부관련정보 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/getBoardAttachInfo.do", method = RequestMethod.GET)
	@ResponseBody
	public void getBoardAttachInfo(HttpServletRequest request, HttpServletResponse response, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("getBoardAttachInfo started");

		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String attID = request.getParameter("attID");
		String itemID = request.getParameter("itemID");
		String fileName = "";
		String filePath = "";
		String realPath = commonUtil.getRealPath(request);
		
		BoardAttachVO result = ezBoardService.getAttachInfo(itemID, attID, userInfo.getTenantId());
		
		filePath = result.getFilePath();
		fileName = result.getFileName();
		
		if (filePath != null && !filePath.equals("")) {
			downFile(request, response, realPath + filePath, fileName);
		}

		logger.debug("getBoardAttachInfo ended");
	}
	
	/**
	 * 게시판 리스트설정셋팅 실행 Method
	 */
	@RequestMapping(value = "/ezBoard/boardGeneralListSave2.do", method = RequestMethod.POST)
	public String boardGeneralListSave2(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("boardGeneralListSave2 started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String userID = request.getParameter("userID");
		String listCount = request.getParameter("listCount");
		String previewMode = request.getParameter("previewMode");
		String list = request.getParameter("list");
		String content = request.getParameter("content");
		
		ezBoardService.setBoardList_Config2(userID, listCount, previewMode, list, content, userInfo.getTenantId());

		logger.debug("boardGeneralListSave2 ended");
		return "json";
	}

	/**
	 * 게시판 게시판승인 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardItemListAppr.do", method = RequestMethod.GET)
	public String boardItemListAppr(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("boardItemListAppr started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String useEditor = ezCommonService.getTenantConfig("MODULEEDITOR", userInfo.getTenantId());
		String useOcs = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId());
		int page = 1;
		
		if (request.getParameter("page") != null) {
			page = Integer.parseInt(request.getParameter("page"));
		}
		
		model.addAttribute("page", page);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("useEditor", useEditor);

		logger.debug("boardItemListAppr ended");
		return "ezBoard/boardItemListAppr";
	}
	
	/**
	 * 게시판 게시판승인리스트 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/apprBoardItem.do", method = RequestMethod.POST, produces="text/plain; charset=utf-8")
	@ResponseBody
	public String apprBoardItem(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("apprBoardItem started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String pMod = request.getParameter("mode");
		String itemList = request.getParameter("itemList");
		String result = "";
		
		String[] tempItem = itemList.split(";");
		
		for (int k = 0; k < tempItem.length; k++) {
			result = ezBoardService.apprItem(userInfo.getId(), tempItem[k], pMod, userInfo.getCompanyID(), userInfo.getTenantId());
		}

		logger.debug("apprBoardItem ended");
		return result;
	}
	
	/**
	 * 게시판 게시판반려사유 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardApprOpinion.do", method = RequestMethod.GET)
	public String boardApprOpinion(HttpServletRequest request, Model model) throws Exception {
		logger.debug("boardApprOpinion started");

		String itemList = request.getParameter("itemList");
		String mode = request.getParameter("mode");
		
		model.addAttribute("mode", mode);
		model.addAttribute("itemList", itemList);

		logger.debug("boardApprOpinion ended");
		return "ezBoard/boardApprOpinion";
	}
	
	/**
	 * 게시판 한줄댓글저장 실행 Method
	 */
	@RequestMapping(value = "/ezBoard/saveOneLineReply.do", method = RequestMethod.POST)
	@ResponseBody
	public void saveOneLineReply(HttpServletRequest request, HttpServletResponse response, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("saveOneLineReply started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String prm = egovFileScrty.getPrm();
		String pre = egovFileScrty.getPre();
		String itemID = commonUtil.stripScriptTags(request.getParameter("itemID"));
		String replyID = commonUtil.stripScriptTags(request.getParameter("replyID"));
		String boardID = commonUtil.stripScriptTags(request.getParameter("boardID"));
		String content = commonUtil.stripScriptTags(request.getParameter("content"));
		String password = commonUtil.stripScriptTags(request.getParameter("password"));
		int replyLevel = Integer.parseInt(request.getParameter("replyLevel"));
		String parentReplyID = "";
		String parentWriterName = "";
		String emoticonContent = commonUtil.stripScriptTags(request.getParameter("emoticonContent"));
		String commentAttach = commonUtil.stripScriptTags(request.getParameter("commentAttach"));
		String realPath = commonUtil.getRealPath(request);
		
		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
		
		String rpwd = EgovFileScrty.decryptRsa(pk, password);
		password = EgovFileScrty.encryptPassword(rpwd, "unknown");
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		
		if (boardInfo.getGuBun().equals("2")) {
			userInfo.setDisplayName1(egovMessageSource.getMessage("ezBoard.t249", userInfo.getLocale()).split(";")[0]);
			userInfo.setDisplayName2(egovMessageSource.getMessage("ezBoard.t249", userInfo.getLocale()).split(";")[1]);
			userInfo.setId("");
		}
		
		content = content.replace("'", "''");
		
		if (replyLevel == 1) {	// 부모댓글 저장
			ezBoardService.saveOneLineReply(itemID, replyID, boardID, userInfo, content, password, replyLevel, emoticonContent);
		} else { // 자식댓글 저장
			parentReplyID = commonUtil.stripScriptTags(request.getParameter("parentReplyId"));
			parentWriterName = request.getParameter("parentWriterName");

			ezBoardService.saveOneLineChildReply(itemID, replyID, boardID, userInfo, content, password, parentReplyID, replyLevel, parentWriterName, emoticonContent);
		}
		
		ezBoardService.saveCommentAttachment(commentAttach, replyID, itemID, boardID, realPath, userInfo.getTenantId());
		
		logger.debug("saveOneLineReply ended");
	}
	
	/**
	 * 게시판 한줄댓글삭제 표출 실행 Method
	 */
	@RequestMapping(value = "/ezBoard/deleteOneLineReply.do", method = RequestMethod.POST, produces="text/plain; charset=utf-8")
	@ResponseBody
	public String deleteOneLineReply(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("deleteOneLineReply started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String guBun = request.getParameter("guBun");
		String replyID = request.getParameter("replyID");
		String itemID = request.getParameter("itemID");

		// 2023-03-30 이가은 - 게시물 댓글의 답글 작성/수정기능 추가 > null로 update했던 부모 댓글을 delete하는 경우 flag가 true (부모댓글이 삭제된 뒤 자식댓글이 모두 삭제되는 경우)
		String flag = request.getParameter("flag");

		if ("true".equals(flag)) {
			userInfo.setId("");
		}
		
		if (commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "c;n;k")) {
			guBun = "2";
		}
		
		String result = ezBoardService.deleteOneLineReply(userInfo.getId(), replyID, itemID, guBun, userInfo.getTenantId());

		logger.debug("deleteOneLineReply ended");
		return result;
	}
	
	/**
	 * 게시판 한줄댓글 오너체크 표출 실행 Method
	 */
	@RequestMapping(value = "/ezBoard/checkOneLineOwner.do", method = RequestMethod.POST)
	@ResponseBody
	public String checkOneLineOwner(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("checkOneLineOwner started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String replyID = request.getParameter("replyID");
		String result = ezBoardService.checkOneLineOwner(replyID, userInfo.getId(), userInfo.getTenantId());

		logger.debug("checkOneLineOwner ended");
		return result;
	}
	
	/**
	 * 게시판 한줄댓글리스트 표출(XML) Method
	 * 2024-10-18 기준으로 해당 컨트롤러 사용하지 않음 (구 로직 중 일부에서만 사용하였으며 해당 일에 사용부 전부 제거함)
	 */
	@RequestMapping(value = "/ezBoard/readOneLineReply.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String readOneLineReply(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("readOneLineReply started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		String gubun = request.getParameter("gubun");
		String lang = commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId());
		String sort = request.getParameter("sort");
		sort = StringUtils.isBlank(sort) ? "earliest" : sort;
		
		/* 2018-10-19 홍승비 - 익명게시물의 댓글 표출조건 gubun값 추가 */
		/* 2018-06-29 홍승비 -댓글쓴 사원정보 확인 시 겸직부서 대응하여 정보 보여주도록 수정 */
		List<BoardLineReplyVO> boardLineReplyVOList = ezBoardService.readOneLineReply(boardID, itemID, lang, gubun, userInfo.getCompanyID(), userInfo.getTenantId(), sort);
		
		StringBuffer sb = new StringBuffer();
		
		sb.append("<DATA>");
		
		for (int i = 0; i < boardLineReplyVOList.size(); i++) {
			StringBuilder stb = new StringBuilder();		
			
			if (boardLineReplyVOList.get(i) != null) {
				stb.append("<ROW>");
				
				for (Field field : boardLineReplyVOList.get(i).getClass().getDeclaredFields()) {
					field.setAccessible(true);
					String data = String.valueOf(field.get(boardLineReplyVOList.get(i)));
					
					if (data == null || data.equals("null")) {
						data = "";
					}		
					
					stb.append("<" + field.getName().toUpperCase() + ">");
					
					if (field.getName().toUpperCase().equals("WRITEDATE")) {
						stb.append(commonUtil.getDateStringInUTC(data, userInfo.getOffset(), false));
					} else {
						stb.append(commonUtil.cleanValue(data));
					}
					
					stb.append("</" + field.getName().toUpperCase() + ">");		        
				}
				
				stb.append("</ROW>");
			} else {
				stb.append("");
			}
			
			sb.append(stb.toString());
		}
		
		sb.append("</DATA>");

		logger.debug("readOneLineReply ended");
		return sb.toString();
	}

	/**
	 * 게시판 게시판게시하기 첨부파일업로드 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/uploadApprovFile.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String uploadApprovFile(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, @RequestBody String xmlPara) throws Exception {
		logger.debug("uploadApprovFile started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String strXML = "<ROOT><NODES>";
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		
		String boardID = commonUtil.detectPathTraversal(xmlDom.getElementsByTagName("BOARDID").item(0).getTextContent());
		String realPath = commonUtil.getRealPath(request);
		int cnt = xmlDom.getElementsByTagName("ROW").getLength();
		String useHwpDownSecurity = ezCommonService.getTenantConfig("useHwpDownSecurity", userInfo.getTenantId());
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		
		String[] fileNames = new String[cnt];
		//String[] orgFileNames = new String[cnt];
		String[] fileSizes = new String[cnt];
		String[] fileLocations = new String[cnt];
		String[] types = new String[cnt];
		String[] uploadSN = new String[cnt];
		String[] downUrl = new String[cnt];
		
		for (int k = 0; k < cnt; k++) {
			fileNames[k] = xmlDom.getElementsByTagName("FILENAME").item(k).getTextContent();
			fileLocations[k] = xmlDom.getElementsByTagName("FILEPATH").item(k).getTextContent();
			fileSizes[k] = xmlDom.getElementsByTagName("FILESIZE").item(k).getTextContent();
			//orgFileNames[k] = xmlDom.getElementsByTagName("ORGFILEPATH").item(k).getTextContent();
			types[k] = xmlDom.getElementsByTagName("TYPE").item(k).getTextContent();
			uploadSN[k] = "{" + UUID.randomUUID().toString() + "}";
			
			if (useHwpDownSecurity.equals("Y") && approvalFlag.equals("G")) {
				downUrl[k] = xmlDom.getElementsByTagName("DOWNURL").item(k).getTextContent();
			}
		}
		
		String dirPath = realPath + commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String dirPath2 = "";
		
		if (types[0].equals("APPROVAL")) {
			dirPath2 = realPath + commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId());
		} else {
			dirPath2 = realPath + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId());
		}
		
		File file = new File(dirPath + boardID);
		
		if (!file.exists()) {
			file.mkdirs();
			new File(dirPath + boardID + commonUtil.separator + "uploadFile").mkdirs();
			new File(dirPath + boardID + commonUtil.separator + "doc").mkdirs();
		} else if (!new File(dirPath + boardID + commonUtil.separator + "uploadFile").exists()) {
			new File(dirPath + boardID + commonUtil.separator + "uploadFile").mkdirs();
		}
		
		Map<String, Integer> fileNameMap = new HashMap<String, Integer>();
		
		for (int k = 0; k < cnt; k++) {
			String fileName = fileNames[k];
			String fileLocation = fileLocations[k];
			String fileSize = fileSizes[k];
			String puploadSN;
			
			String uploadLocation;
			
			// 2018.07.04 - KLIB 암호화된 .ezd 확장자 파일일때 처리
			fileLocation = commonUtil.detectPathTraversal(fileLocations[k]);
			
			int extIndex = fileLocation.lastIndexOf(".");
			String fileExt = fileLocation.substring(extIndex);
			boolean isEncryptedForKlib = fileExt.endsWith(EzApprovalGKlibService.ENCRYPTED_FILE_EXT);
			
			// ezd 확장자라면 그 뒤의 확장자로 설정
			if (isEncryptedForKlib) {
				fileExt = fileLocation.substring(fileLocation.lastIndexOf(".", extIndex - 1), extIndex);
			}
						
			// 결재 본문 처리
			if (fileExt.equalsIgnoreCase(".mht") || fileExt.equalsIgnoreCase(".hwp") || fileExt.equalsIgnoreCase(".doc")) {
				// fileName 에 확장자가 포함되지 않으면 확장자 붙여줌
				if (!fileName.endsWith(fileExt)) {
					fileName += fileExt;
					fileNames[k] = fileName;
					file = new File(dirPath2 + commonUtil.separator + fileLocation);
					fileSize = String.valueOf(file.length());
				}
			}
			fileName = commonUtil.getUniqueFileName(fileNames[k], fileNameMap);
			file = new File(dirPath2 + commonUtil.separator + fileLocation);
			uploadLocation = dirPath + commonUtil.separator + "tempUploadFile" + commonUtil.separator + uploadSN[k] + "_" + fileName;
			puploadSN = uploadSN[k] + "_" + fileName;
			
			if (isEncryptedForKlib) {
				uploadLocation += "." + EzApprovalGKlibService.ENCRYPTED_FILE_EXT;
				puploadSN += "." + EzApprovalGKlibService.ENCRYPTED_FILE_EXT;
			}
			
			// useHwpDownSecurity의 값이 Y일 때, 배포용 문서로 변환된 파일은 URL을 통해 웹한글기안기 서버에서 해당 파일을 다운로드
			if (useHwpDownSecurity.equals("Y") && approvalFlag.equals("G") && fileExt.equalsIgnoreCase(".hwp") && !downUrl[k].equals("noUrl")) {
				Path pathUploadLocation = Paths.get(commonUtil.detectPathTraversal(uploadLocation));
				URL downloadUrl = new URL(downUrl[k]);
				InputStream inpStream = null;
				
				try {
					inpStream = downloadUrl.openStream();
					Files.copy(inpStream, pathUploadLocation);
					
					inpStream.close();
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
				} finally {
					if (inpStream != null) {
						try {
							inpStream.close();
						} catch (Exception ignore) {
							logger.error(ignore.getMessage(), ignore);
						}
				    }
				}
			} else {
				if (file.exists()) {
					FileUtils.copyFile(file, new File(commonUtil.detectPathTraversal(uploadLocation)));
				}
			}
			
			strXML += "<NODE><PUPLOADSN><![CDATA[" + puploadSN + "]]></PUPLOADSN>";
			strXML += "<RESULTUPLOADA><![CDATA[true]]></RESULTUPLOADA>";
			strXML += "<PFILENAME><![CDATA[" + fileName + "]]></PFILENAME>";
			strXML += "<FILESIZE>" + fileSize + "</FILESIZE>";
			strXML += "<FILELOCATION><![CDATA[" + uploadLocation + "]]></FILELOCATION>";
			strXML += "</NODE>";
		}
		
		strXML += "</NODES></ROOT>";

		logger.debug("uploadApprovFile ended");
		return strXML;
	}

	/**
	 * 게시판 게시판게시하기 일정 첨부파일업로드 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/uploadScheduleFile.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String uploadScheduleFile(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, @RequestBody String xmlPara) throws Exception {
		logger.debug("uploadScheduleFile started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String strXML = "<ROOT><NODES>";
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);

		String boardID = commonUtil.detectPathTraversal(xmlDom.getElementsByTagName("BOARDID").item(0).getTextContent());
		String realPath = commonUtil.getRealPath(request);
		int cnt = xmlDom.getElementsByTagName("ROW").getLength();

		String[] fileNames = new String[cnt];
		String[] fileSizes = new String[cnt];
		String[] fileLocations = new String[cnt];
		String[] uploadSN = new String[cnt];
		String[] downUrl = new String[cnt];

		for (int k = 0; k < cnt; k++) {
			fileNames[k] = xmlDom.getElementsByTagName("FILENAME").item(k).getTextContent();
			fileLocations[k] = xmlDom.getElementsByTagName("FILEPATH").item(k).getTextContent();
			fileSizes[k] = xmlDom.getElementsByTagName("FILESIZE").item(k).getTextContent();
			uploadSN[k] = "{" + UUID.randomUUID().toString() + "}";
		}

		String dirPath = realPath + commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId()) + commonUtil.separator;
		String dirPath2 = realPath + commonUtil.getUploadPath("upload_schedule.ROOT", userInfo.getTenantId());

		File file = new File(dirPath + boardID);

		if (!file.exists()) {
			file.mkdirs();
			new File(dirPath + boardID + commonUtil.separator + "uploadFile").mkdirs();
			new File(dirPath + boardID + commonUtil.separator + "doc").mkdirs();
		} else if (!new File(dirPath + boardID + commonUtil.separator + "uploadFile").exists()) {
			new File(dirPath + boardID + commonUtil.separator + "uploadFile").mkdirs();
		}

		Map<String, Integer> fileNameMap = new HashMap<String, Integer>();

		for (int k = 0; k < cnt; k++) {
			String fileName = fileNames[k];
			String fileLocation = fileLocations[k];
			String fileSize = fileSizes[k];
			String puploadSN;
			String uploadLocation;

			fileLocation = commonUtil.detectPathTraversal(fileLocations[k]);

			int extIndex = fileLocation.lastIndexOf(".");
			String fileExt = fileLocation.substring(extIndex);
			fileName = commonUtil.getUniqueFileName(fileNames[k], fileNameMap);
			file = new File(dirPath2 + commonUtil.separator + fileLocation);
			uploadLocation = dirPath + commonUtil.separator + "tempUploadFile" + commonUtil.separator + uploadSN[k] + "_" + fileName;
			puploadSN = uploadSN[k] + "_" + fileName;

			if (file.exists()) {
				FileUtils.copyFile(file, new File(commonUtil.detectPathTraversal(uploadLocation)));
			}

			strXML += "<NODE><PUPLOADSN><![CDATA[" + puploadSN + "]]></PUPLOADSN>";
			strXML += "<RESULTUPLOADA><![CDATA[true]]></RESULTUPLOADA>";
			strXML += "<PFILENAME><![CDATA[" + fileName + "]]></PFILENAME>";
			strXML += "<FILESIZE>" + fileSize + "</FILESIZE>";
			strXML += "<FILELOCATION><![CDATA[" + uploadLocation + "]]></FILELOCATION>";
			strXML += "</NODE>";
		}

		strXML += "</NODES></ROOT>";

		logger.debug("uploadScheduleFile ended");
		return strXML;
	}
	/**
	 * 포탈 포토갤러리 포틀릿 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/getImagePortletList.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getImagePortletList(HttpServletRequest request, @RequestBody String xmlPara, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("getImagePortletList started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String pBoardType = xmlDom.getElementsByTagName("pBoardType").item(0).getTextContent();
		String pBoardID = xmlDom.getElementsByTagName("pBoardID").item(0).getTextContent();
		int pPageNum = Integer.parseInt(xmlDom.getElementsByTagName("pPageNum").item(0).getTextContent());
		String pOrderCell = xmlDom.getElementsByTagName("orderCell").item(0).getTextContent();
		String pOrderOption = xmlDom.getElementsByTagName("orderOption").item(0).getTextContent();
		
		String boardXML = ezBoardService.getThumbListXML(userInfo, pBoardType, pBoardID, pPageNum, pOrderCell, pOrderOption);

		logger.debug("getImagePortletList ended");
		return boardXML;
	}
	
	/**
	 * 게시판 게시판트리(boardPortlet) 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardSelect.do", method = RequestMethod.GET)
	public String boardSelect(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		logger.debug("boardSelect started");

		userInfo = commonUtil.userInfo(loginCookie);
		String useEditor = ezCommonService.getTenantConfig("MODULEEDITOR", userInfo.getTenantId());
		
		/* 2019-06-03 홍승비 - 결과가 항상 NO인 게시판그룹 관리자권한 체크 동작 제거 (boardGroupID 또는 boardID가 'top'인 게시판은 존재하지 않음) */
		String pRootBoardID = "top";
		String pSubFlag = "0";
		int pSelectBy = 0;
		String pExcludeBoardID = " ";
		String isAdminLeft = "";
		/* 2018-10-16 홍승비 - 전체관리자 플래그 추가 */
		boolean isCompanyAdmin = commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "c");
		
		/* 2018-10-16 홍승비 - 관리자단에서 접근했는지 판단하는 플래그 추가 */
		if (req.getParameter("isAdminLeft") != null && !req.getParameter("isAdminLeft").equals("")) {
			isAdminLeft = req.getParameter("isAdminLeft");
		}
		
		int pMode = commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "c;n;k") ? 0 : 1;
		String boardGroupAdmin_FG = checkIfBoardGroupAdmin(pRootBoardID, userInfo);
		String retXML = ezBoardService.getBoardTree(pRootBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), pMode, Integer.parseInt(pSubFlag), pSelectBy, pExcludeBoardID,
				commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), isAdminLeft, isCompanyAdmin, boardGroupAdmin_FG, userInfo.getRollInfo(), userInfo.getTenantId());
		
		if (retXML.substring(0, 5).toUpperCase().equals("ERROR")) {
			retXML = "<RESULT>ERROR</RESULT>";
		}
		
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("isAdminLeft", isAdminLeft);

		logger.debug("boardSelect ended");
		return "ezBoard/boardBoardSelect";
	}
	
	/**
	 * 게시판 메일보내기 컨텐츠 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/getItemInfo.do", method = RequestMethod.GET, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getItemInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getItemInfo started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");

		String result = ezBoardService.getItemXML(boardID, itemID, userInfo.getLang(), userInfo.getOffset(), userInfo.getTenantId());

		logger.debug("getItemInfo ended");
		
		return result;
	}
	
	/**
	 * 게시판 메일보내기 첨부파일 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/getItemAttachmentsMail.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getItemAttachments(@CookieValue("loginCookie") String loginCookie, BoardItemVO boardItemVO, HttpServletRequest request) throws Exception {
		logger.debug("getItemAttachments started");

		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String realPath = commonUtil.getRealPath(request);
		
		boardItemVO.setTenantID(userInfo.getTenantId());
		boardItemVO.setFilePath(realPath);
		
		String result = "";
		
		if (boardItemVO.getMode() != null && (boardItemVO.getMode().equals("boardContent") || boardItemVO.getMode().equals("boardAttach"))) {
			boardItemVO.setTitle(boardItemVO.getTitle());
			result = ezBoardService.getItemAttachmentXMLRetrans(boardItemVO);
		} else {
			result = ezBoardService.getItemAttachmentXML(boardItemVO);
		}
		
		logger.debug("getItemAttachments ended");
		
		return result;
	}
	
	/**
	 * 게시판 게시알림 전송 실행 Method (관리자 권한자에게 발송하는 게시알림)
	 */
	@RequestMapping(value = "/ezBoard/sendPostNotiForAdmin.do", method = RequestMethod.POST)
	@ResponseBody
	public void sendPostNotiForAdmin(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("sendPostNotiForAdmin started.");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		logger.debug("boardID=" + boardID + ", itemID=" + itemID);
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		BoardListVO boardItem = ezBoardService.getBrdGetItemInfo(boardID, itemID, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
		String boardName = ezBoardService.getBoardNameLocalizing(userInfo.getLang(), boardInfo);
		
		String strURL = "Item_View_New('" + boardID + "','" + itemID + "','" + boardInfo.getGuBun() + "');";
        strURL = "<span id='board_a' style=\"color:blue;cursor:pointer;text-decoration:underline;\" onClick=\"" + strURL + "\">";
		
        String strDate = commonUtil.getDateStringInUTC(boardItem.getWriteDate(), userInfo.getOffset(), false); 
        strDate += "( " + userInfo.getOffset().split("\\|")[1] + " )";
        
        StringBuilder bodyContent = new StringBuilder();

        /* 2018-10-26 홍승비 - 게시판 게시알림 메일 전송 시 폰트 다국어 설정, 특문처리 추가 */
        bodyContent.append("<br>" + egovMessageSource.getMessage("ezBoard.t250", userInfo.getLocale()) + "<br><br>");
        bodyContent.append("<br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t251", userInfo.getLocale()) + commonUtil.cleanValue(boardName));
        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t252", userInfo.getLocale()) + strDate);
        
        if (boardInfo.getGuBun().equals("2")) {
        	bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t253", userInfo.getLocale()) + boardItem.getWriterName());
        }
        /* 2024-02-02 홍승비 - 승인게시판의 경우, 승인자가 아닌 게시물 작성자의 정보가 메일에 표출되도록 수정 (익명게시판은 승인여부 사용불가, getBrdGetItemInfo로 가져온 데이터는 작성자/작성자 부서명/작성자 회사명 전부 다국어 대응됨) */
        else if (boardInfo.getApprFlag() != null && boardInfo.getApprFlag().equalsIgnoreCase("Y")) { // 승인게시판
        	bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t253", userInfo.getLocale()) + boardItem.getWriterName() + "(" + (boardItem.getExtensionAttribute3() == null || "null".equals(boardItem.getExtensionAttribute3()) ? "" : boardItem.getExtensionAttribute3()) + ", " + boardItem.getWriterDeptName() + ", " + boardItem.getWriterCompanyName() + ")");
        } else {
        	bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t253", userInfo.getLocale()) + userInfo.getDisplayName() + "(" + (userInfo.getTitle() == null || "null".equals(userInfo.getTitle()) ? "" : userInfo.getTitle()) + ", " + userInfo.getDeptName() + ", " + userInfo.getCompanyName() + ")");
        }
        
        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t254", userInfo.getLocale()) + strURL + commonUtil.cleanValue(boardItem.getTitle()) + "</a>");
        
        String content = commonUtil.createNotiMailContent(bodyContent.toString(), userInfo.getTenantId(), userInfo.getLocale());
        String subject = "[" + egovMessageSource.getMessage("ezBoard.t255", userInfo.getLocale()) + boardName + "] " + boardItem.getTitle();
        String notiContent = "[" + egovMessageSource.getMessage("ezNotification.hth35", userInfo.getLocale()) + "]"+ boardName + " - " + boardItem.getTitle();

        List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();
        List<BoardAccessVO> list = ezBoardService.getPostNotiMailUserList(boardID, userInfo.getPrimary(), userInfo.getTenantId());
        
        logger.debug("Sending board mail starts.");
        for (BoardAccessVO vo : list) {
        	try {
				Map<String, Object> recipientMap = new HashMap<String, Object>();
				recipientMap.put("userType", "PERSON");
				recipientMap.put("companyId", userInfo.getCompanyID());
				recipientMap.put("cn", vo.getAccessID());
				notiRecipientList.add(recipientMap);

	        	InternetAddress from = new InternetAddress();

	        	/* 2021-06-29 홍승비 - 익명게시판의 경우, 관리자에게 게시알림 메일발송 시 게시자 표출명과 임의의 이메일을 사용하도록 수정 */
	        	if (boardInfo.getGuBun().equals("2")) {
	        		from.setPersonal(boardItem.getWriterName(), "UTF-8");
	        		from.setAddress("AnonyBoardMail@boardmail");
	        	} else {
	        		from.setPersonal(userInfo.getDisplayName(), "UTF-8");
	        		from.setAddress(userInfo.getEmail());
	        	}

	        	String mail = "";
	        	String toName = vo.getAccessName();

	        	/* 2021-10-12 홍승비 - 게시판 관리자 권한자에게 게시알림메일 발송 시 현재의 이름을 사용 (괄호 안의 부서명 제거 > 일반 사용자에 대한 게시알림메일의 받는사람 형식과 통일) */
	        	try {
	        		OrganUserVO AccessUserInfo = ezOrganAdminService.getUserInfo(vo.getAccessID(), userInfo.getPrimary(), userInfo.getTenantId());

	        		mail = AccessUserInfo.getMail();
	        		toName = AccessUserInfo.getDisplayName();
					logger.debug("user sendMail");
				} catch (Exception e) {
					OrganDeptVO accessDeptInfo = ezOrganService.getDeptInfo(vo.getAccessID(), userInfo.getPrimary(), userInfo.getTenantId());

					mail = accessDeptInfo.getMail();
					toName = accessDeptInfo.getDisplayName(); // 관리자 권한자가 부서인 경우에도 현재 부서명을 가져옴
					logger.debug("dept sendMail");
				}

	        	InternetAddress to = new InternetAddress();
	        	to.setPersonal(toName, "UTF-8");
	        	to.setAddress(mail);

	        	ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject, content, false);

        	} catch (Exception e) {
        		logger.debug(e.getMessage());
        		logger.debug("Sending board Mail is failed : "  + vo.getAccessID());
        		continue;
        	}
        }

        logger.debug("Sending board mail ends.");
        // 2024-03-28 한태훈 > 게시판 관리자 게시알림 통합알림 추가
        String boardType = boardInfo.getGuBun();
		String linkUrl = "";
		String linkUrlMobile = "";
		String boardStatus = "";

		String tempItemID = encodeURIComponent(itemID);
		String tempBoardID = encodeURIComponent(boardID);

		if (boardType != null && (boardType.equals("4") || boardType.equals("3"))) {
			boardStatus = "photoBoardItem";
		}

		if (boardID.equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")) {
			boardStatus = "newBoardItemList";
		} else {
			boardStatus = "boardItemList";
		}

		if (boardType != null && (boardType.equals("4") || boardType.equals("3"))) {
			boardStatus = "photoBoardItem";
		}

		if (boardID.equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")) {
			boardStatus = "newBoardItemList";
		} else {
			boardStatus = "boardItemList";
		}

		String tempBoardStatus = encodeURIComponent(boardStatus);

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

		String senderName = boardType.equals("2") ? "익명" : userInfo.getDisplayName();

        if (notiRecipientList != null && notiRecipientList.size() > 0) {
			String notiStatus = ezNotificationService.sendNoti(request, userInfo.getId(), senderName, notiRecipientList, "board", "new", notiContent, "popup", "780", "800", linkUrl, linkUrlMobile, "notChkSetting");
			logger.debug("board " +  "new" + " noti status : " + notiStatus);
        }

		logger.debug("sendPostNotiForAdmin ended.");
	}
	
	/**
	 * 게시글 존재여부 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/getItemViewNew.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getItemViewNew(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getItemViewNew started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		
		String dotNetIntegration = ezCommonService.getTenantConfig("dotNetIntegration", userInfo.getTenantId());
		String dotNetUrl = ezCommonService.getTenantConfig("dotNetUrl", userInfo.getTenantId());
		
		String isAllGroupBoardItem = "";
		
		logger.debug("dotNetIntegration=" + dotNetIntegration);
		
		// 닷넷 게시판으로 연동하는 경우에는 닷넷 URL을 반환한다.
		if (dotNetIntegration.equals("YES")) {			
			return dotNetUrl;
		}
		
		int result = ezBoardService.getItemViewNew(boardID, itemID, userInfo.getTenantId());
		
		/* 2018-10-19 홍승비 - 그룹사게시판의 게시물은 모든 회사에서 읽기 허용 */
		BoardPropertyVO boardProp = ezBoardService.getBoardProperty(boardID, userInfo.getTenantId());
		
		if (boardProp.getBoardGroupID() != null) {
			BoardPropertyVO boardGroupProp = ezBoardService.getBoardProperty(boardProp.getBoardGroupID(), userInfo.getTenantId());
			
			if (boardGroupProp.getGuBun() != null && boardGroupProp.getGuBun().equals("99")) {
				isAllGroupBoardItem = "Y";
			}
		}
		
		// 그룹사게시판이 아니고, 게시판이 소속된 회사가 현재 접근하려는 사용자의 회사와 다르면 result를 FAIL로 반환한다. 사용자의 lang에 따라 회사이름을 다국어로 보낸다.
		if ((!isAllGroupBoardItem.equals("Y")) && (!boardProp.getCompanyID().equals(userInfo.getCompanyID()))) {
			OrganDeptVO organDeptVO = ezOrganService.getDeptInfo(boardProp.getCompanyID(), userInfo.getPrimary(), userInfo.getTenantId());
			
			return "<DATA><DATA1>FAIL</DATA1><DATA2>" + organDeptVO.getDisplayName() + "</DATA2></DATA>";
		}
		
		logger.debug("getItemViewNew ended.");
		
		return "<DATA>" + result + "</DATA>";
	}
	
	/**
	 * 게시판 답변알림 메일전송 실행 Method
	 */
	@RequestMapping(value = "/ezBoard/sendReplyNotice.do", method = RequestMethod.POST)
	@ResponseBody
	public void sendReplyNotice(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("sendReplyNotice started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		String itemTreeID = request.getParameter("itemTreeID");
		//logger.debug("boardID=" + boardID + ",itemID=" + itemID + ",itemTreeID=" + itemTreeID);
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		String boardName = ezBoardService.getBoardNameLocalizing(userInfo.getLang(), boardInfo);
		
		// 2023-05-10 전인하 - 답변알림에서 누락된 파라미터인 boardGubun(게시판의 타입을 규정)을 가져와 메소드에 삽입
		String boardGubun = boardInfo.getGuBun();
		
		if (!boardInfo.getReplyNotify().equals("1")) {
			return ;
		}
		
		String strXML = ezBoardService.getItemXML(boardID, itemID, userInfo.getLang(), userInfo.getOffset(), userInfo.getTenantId());
		Document doc = commonUtil.convertStringToDocument(strXML);
		String title = doc.getElementsByTagName("Title").item(0).getTextContent();
		String strURL =  "javascript:Item_View_New('" + boardID + "', '" + itemID + "', '" + boardGubun + "');";
        strURL = "<span id='board_a' style=\"color:blue;cursor:pointer;text-decoration:underline;\" onClick=\"" + strURL + "\">";
        String strDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false); 
        strDate += "( " + userInfo.getOffset().split("\\|")[1] + " )";
        
        StringBuilder bodyContent = new StringBuilder();
        
        /* 2018-10-26 홍승비 - 게시판 답변알림 메일 전송 시 폰트 다국어 설정, 특문처리 추가 */
        bodyContent.append("<br>" + egovMessageSource.getMessage("ezBoard.t259", userInfo.getLocale()) + "<br><br>");
        bodyContent.append("<br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t251", userInfo.getLocale()) + commonUtil.cleanValue(boardName));
        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t252", userInfo.getLocale()) + strDate);
        
        /* 2024-02-02 홍승비 - 승인게시판의 경우, 승인자가 아닌 게시물 작성자의 정보가 메일에 표출되도록 수정 (익명게시판은 승인여부 사용불가, getBrdGetItemInfo로 가져온 데이터는 작성자/작성자 부서명/작성자 회사명 전부 다국어 대응됨) */
        if (boardInfo.getApprFlag() != null && boardInfo.getApprFlag().equalsIgnoreCase("Y")) { // 승인게시판
        	bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t253", userInfo.getLocale()) + doc.getElementsByTagName("WriterName").item(0).getTextContent() + "(" + ("null".equals(doc.getElementsByTagName("ExtensionAttribute3").item(0).getTextContent()) ? "" : doc.getElementsByTagName("ExtensionAttribute3").item(0).getTextContent()) + ", " + doc.getElementsByTagName("WriterDeptName").item(0).getTextContent() + ", " + doc.getElementsByTagName("WriterCompanyName").item(0).getTextContent() + ")");
        } else {
        	bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t253", userInfo.getLocale()) + userInfo.getDisplayName() + "(" + (userInfo.getTitle() == null || "null".equals(userInfo.getTitle()) ? "" : userInfo.getTitle()) + ", " + userInfo.getDeptName() + ", " + userInfo.getCompanyName() + ")");
        }
		
        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t254", userInfo.getLocale()) + strURL + commonUtil.cleanValue(title) + "</span>");
        
        String content = commonUtil.createNotiMailContent(bodyContent.toString(), userInfo.getTenantId(), userInfo.getLocale());
        
        String subject = "[" + egovMessageSource.getMessage("ezBoard.t260", userInfo.getLocale()) + boardName  + "]" + title;
        
        String notiContent = boardInfo.getBoardName() + " - " + title;
        List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();

        List<BoardListVO> boardListVOs = ezBoardService.getReplyNoticeMail(boardID, itemTreeID, userInfo.getLang(), userInfo.getTenantId());
        
        logger.debug("Sending board mail starts.");
        for (BoardListVO vo : boardListVOs) {
        	try {
        		Map<String, Object> recipientMap = new HashMap<String, Object>();
        		recipientMap.put("userType", "PERSON");
        		recipientMap.put("companyId", userInfo.getCompanyID());
        		recipientMap.put("cn", vo.getWriterID());
        		notiRecipientList.add(recipientMap);

	        	InternetAddress from = new InternetAddress();
	        	from.setPersonal(userInfo.getDisplayName(), "UTF-8");
	        	from.setAddress(userInfo.getEmail());

	        	InternetAddress to = new InternetAddress();
	        	to.setPersonal(vo.getWriterName(), "UTF-8");
	        	to.setAddress(vo.getMail());

	        	if (!ezPersonalService.hasNotiDiableItem(vo.getWriterID(), NotiType.BOARD_REPLY, NotiPlatform.MAIL, userInfo.getTenantId())) {
	        		ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject, content, false);
	        	}
        	} catch (Exception e) {
        		logger.debug(e.getMessage());
        		logger.debug("Sending board mail is failed : " + vo.getWriterID());
        		continue;
        	}
        	
        }
        logger.debug("Sending board mail ends.");

        // 2024-03-28 한태훈 > 게시판 답변알림 통합알림 추가
        String linkUrl = "";
		String linkUrlMobile = "";
		String boardStatus = "";

		if (boardGubun != null && (boardGubun.equals("4") || boardGubun.equals("3"))) {
			boardStatus = "photoBoardItem";
		}

		if (boardID.equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")) {
			boardStatus = "newBoardItemList";
		} else {
			boardStatus = "boardItemList";
		}

		itemID = encodeURIComponent(itemID);
		boardID = encodeURIComponent(boardID);
		boardStatus = encodeURIComponent(boardStatus);

		switch (boardGubun) {
		case "3":
		case "4":
			linkUrl += "/ezBoard/boardItemViewPhoto.do?itemID=" + (itemID) + "&boardID=" + (boardID);
			linkUrlMobile += "/mobile/ezBoard/photoBoardItem.do?boardID=" + (boardID) + "&itemID=" + (itemID) + "&type=photoBoardItem&boardItemListType=" + (boardStatus);
			break;
		case "7":
			linkUrl += "/ezBoard/boardItemViewMovie.do?itemID=" + (itemID) + "&boardID=" + (boardID);
			linkUrlMobile += "/mobile/ezBoard/movieBoardItem.do?boardID=" + (boardID) + "&itemID=" + (itemID) + "&type=movieBoardItem&boardItemListType=" + (boardStatus);
			break;
		default:
			linkUrl += "/ezBoard/boardItemView.do?itemID=" + (itemID) + "&boardID=" + (boardID);
			linkUrlMobile += "/mobile/ezBoard/boardItem.do?boardID=" + (boardID) + "&itemID=" + (itemID) + "&type=boardItem&boardItemListType=" + (boardStatus);
			break;
		}

		if (notiRecipientList != null && notiRecipientList.size() > 0) {
			String notiStatus = ezNotificationService.sendNoti(request, userInfo.getId(), userInfo.getDisplayName(), notiRecipientList, "board", "reply", notiContent, "popup", "780", "800", linkUrl, linkUrlMobile, "");
			logger.debug("board " +  "reply" + "noti status : " + notiStatus);
        }

		logger.debug("sendReplyNotice ended");
	}
	
	/**
	 * 게시판 게시물승인관련 알림전송 실행 Method
	 */
	@RequestMapping(value = "/ezBoard/sendApprNotice.do", method = RequestMethod.POST)
	@ResponseBody
	public void sendApprnotice(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("sendApprnotice started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		logger.debug("boardID=" + boardID + ",itemID=" + itemID);
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		
		String strXML = ezBoardService.getItemXML(boardID, itemID, userInfo.getLang(), userInfo.getOffset(), userInfo.getTenantId());
		Document doc = commonUtil.convertStringToDocument(strXML);
		String title = doc.getElementsByTagName("Title").item(0).getTextContent();
		String gubun = doc.getElementsByTagName("GUBUN").item(0).getTextContent();
		
		// 게시판ID, 게시물ID로 어느 회사에서 쓴것인지 확인 -> 현재 자신의 companyID와 다르다면 alert 후 창 닫음
		String strURL = "javascript:Item_View_APPR('" + boardID + "','" + itemID + "','" + gubun + "');";
        strURL = "<a id='board_a' style='color:blue;text-decoration:underline;cursor:pointer;' onClick=" + strURL + ">";
        
        String strDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false); 
        strDate += "( " + userInfo.getOffset().split("\\|")[1] + " )";
        
        StringBuilder bodyContent = new StringBuilder();
		
		String boardName = ezBoardService.getBoardNameLocalizing(userInfo.getLang(), boardInfo);
        
        /* 2018-10-26 홍승비 - 게시판 게시물 승인대기 알림 메일 전송 시 폰트 다국어 설정, 특문처리 추가 */
        bodyContent.append("<br>" + egovMessageSource.getMessage("ezBoard.t999006", userInfo.getLocale()) + "<br><br>");
        bodyContent.append("<br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t251", userInfo.getLocale()) + commonUtil.cleanValue(boardName));
        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t252", userInfo.getLocale()) + strDate);
        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t253", userInfo.getLocale()) + userInfo.getDisplayName() + "(" + (userInfo.getTitle() == null || "null".equals(userInfo.getTitle()) ? "" : userInfo.getTitle()) + ", " + userInfo.getDeptName() + ", " + userInfo.getCompanyName() + ")");
        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t254", userInfo.getLocale()) + strURL + commonUtil.cleanValue(title) + "</a>");

        String content = commonUtil.createNotiMailContent(bodyContent.toString(), userInfo.getTenantId(), userInfo.getLocale());

        String subject;
        if (userInfo.getLang().equals("1") ) {
        	subject = "[" + egovMessageSource.getMessage("ezBoard.t999006", userInfo.getLocale()) + boardName + "]" + title;
        } else {
        	subject = "[" + egovMessageSource.getMessage("ezBoard.t999006", userInfo.getLocale()) + "]" + title;
        }

        List<LoginVO> loginVOs = ezBoardService.getSendApprMailList(boardID, userInfo.getLang(), userInfo.getTenantId());
        List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();
        
        logger.debug("Sending board mail starts.");
        for (LoginVO vo : loginVOs) {
        	try {
        		Map<String, Object> recipientMap = new HashMap<String, Object>();
        		recipientMap.put("userType", "PERSON");
        		recipientMap.put("companyId", userInfo.getCompanyID());
        		recipientMap.put("cn", vo.getId());
        		notiRecipientList.add(recipientMap);
        		
	        	InternetAddress from = new InternetAddress();
	        	from.setPersonal(userInfo.getDisplayName(), "UTF-8");
	        	from.setAddress(userInfo.getEmail());

	        	InternetAddress to = new InternetAddress();
	        	to.setPersonal(vo.getDisplayName(), "UTF-8");
	        	to.setAddress(vo.getEmail());

	        	ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject, content, false);
        	} catch (Exception e) {
        		logger.debug(e.getMessage());
        		logger.debug("Sending board mail is failed : " + vo.getId());
        		continue;
        	}
        }

        logger.debug("Sending board mail ends.");

        // 2024-03-28 한태훈 > 게시판 게시물 승인 통합알림 추가
        String notiContent = boardInfo.getBoardName() + " - " + title;
        String boardType = boardInfo.getGuBun();
		String linkUrl = "";
		String linkUrlMobile = "";
		String boardStatus = "";

		if (boardID.equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")) {
			boardStatus = "newBoardItemList";
		} else {
			boardStatus = "boardItemList";
		}

		if (boardType != null && (boardType.equals("4") || boardType.equals("3"))) {
			boardStatus = "photoBoardItem";
		}

		String tempItemID = encodeURIComponent(itemID);
		String tempBoardID = encodeURIComponent(boardID);
		String tempBoardStatus = encodeURIComponent(boardStatus);

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

		if (notiRecipientList != null && notiRecipientList.size() > 0) {
			String notiStatus = ezNotificationService.sendNoti(request, userInfo.getId(), userInfo.getDisplayName(), notiRecipientList, "board", "apprv_waiting", notiContent, "popup", "780", "800", linkUrl, linkUrlMobile, "notChkSetting");
			logger.debug("board " +  "apprv" + " noti status : " + notiStatus);
		}

		logger.debug("sendApprnotice ended");
	}
	
	/**
	 * 게시판 게시물반려관련 메일전송 실행 Method
	 */
	@RequestMapping(value = "/ezBoard/sendReturnNotice.do", method = RequestMethod.POST)
	@ResponseBody
	public void sendReturnNotice(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("sendReturnNotice started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String itemID = request.getParameter("itemID");
		String content = request.getParameter("content");
		
		//logger.debug("content=" + content + ",itemID=" + itemID);
		
		String[] itemIDs = itemID.split(";");
		
		for (int k = 0; k < itemIDs.length; k++) {
			String tempItemID = itemIDs[k].split(",")[0];
			
			BoardListVO boardListVO = ezBoardService.getItemInfo("", tempItemID, userInfo.getLang(), userInfo.getTenantId());
			
			if(!ezPersonalService.hasNotiDiableItem(boardListVO.getWriterID(), NotiType.fromString("BOARD_RETURN"), NotiPlatform.MAIL, userInfo.getTenantId())) {
				// 게시판ID, 게시물ID로 어느 회사에서 쓴것인지 확인 -> 현재 자신의 companyID와 다르다면 alert 후 창 닫음
				String strURL = "javascript:Item_View_APPR('" + boardListVO.getBoardID() + "','" + tempItemID + "','" + boardListVO.getGuBun() + "');";
		        strURL = "<a id='board_a' style='color:blue;text-decoration:underline;cursor:pointer;' onClick=" + strURL + ">";

		        StringBuilder bodyContent = new StringBuilder();

		        /* 2018-10-26 홍승비 - 게시판 게시물 반려 메일 전송 시 폰트 다국어 설정, 특문처리 추가 */
		        bodyContent.append("<br>" + egovMessageSource.getMessage("ezBoard.t999015", userInfo.getLocale()) + "<br><br>");
		        bodyContent.append("<br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t251", userInfo.getLocale()) + boardListVO.getBoardName());
		        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t254", userInfo.getLocale()) + strURL + commonUtil.cleanValue(boardListVO.getTitle()) + "</a>");
		        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t999016", userInfo.getLocale()) + " : " + commonUtil.cleanValue(content) + "</a>");

		        /* 2019-05-06 홍승비 - 루프 바깥의 content 변수 반복 사용으로 메세지 깨지는 오류 수정 */
		        String subject = "[" + egovMessageSource.getMessage("ezBoard.t999017", userInfo.getLocale()) + "]" + boardListVO.getTitle();
		        String contentTemp = commonUtil.createNotiMailContent(bodyContent.toString(), userInfo.getTenantId(), userInfo.getLocale());


	        	InternetAddress from = new InternetAddress();
	        	from.setPersonal(userInfo.getDisplayName(), "UTF-8");
	        	from.setAddress(userInfo.getEmail());

	        	InternetAddress to = new InternetAddress();
	        	to.setPersonal(boardListVO.getWriterName(), "UTF-8");
	        	to.setAddress(boardListVO.getMail());

	        	ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject, contentTemp, false);
			}

        	// 2024-03-28 한태훈 > 게시판 게시물 반려 통합알림 추가
        	String boardType = boardListVO.getGuBun();
    		String linkUrl = "";
    		String linkUrlMobile = "";
    		String boardStatus = "";

    		if (boardType != null && (boardType.equals("4") || boardType.equals("3"))) {
    			boardStatus = "photoBoardItem";
    		}

    		if (tempItemID.equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")) {
    			boardStatus = "newBoardItemList";
    		} else {
    			boardStatus = "boardItemList";
    		}

    		tempItemID = encodeURIComponent(tempItemID);
    		String boardID = encodeURIComponent(boardListVO.getBoardID());
    		boardStatus = encodeURIComponent(boardStatus);

    		switch (boardType) {
    		case "3":
    		case "4":
    			linkUrl += "/ezBoard/boardItemViewPhoto.do?itemID=" + (tempItemID) + "&boardID=" + (boardID);
    			linkUrlMobile += "/mobile/ezBoard/photoBoardItem.do?boardID=" + (boardID) + "&itemID=" + (tempItemID) + "&type=photoBoardItem&boardItemListType=" + (boardStatus);
    			break;
    		case "7":
    			linkUrl += "/ezBoard/boardItemViewMovie.do?itemID=" + (tempItemID) + "&boardID=" + (boardID);
    			linkUrlMobile += "/mobile/ezBoard/movieBoardItem.do?boardID=" + (boardID) + "&itemID=" + (tempItemID) + "&type=movieBoardItem&boardItemListType=" + (boardStatus);
    			break;
    		default:
    			linkUrl += "/ezBoard/boardItemView.do?itemID=" + (tempItemID) + "&boardID=" + (boardID);
    			linkUrlMobile += "/mobile/ezBoard/boardItem.do?boardID=" + (boardID) + "&itemID=" + (tempItemID) + "&type=boardItem&boardItemListType=" + (boardStatus);
    			break;
    		}

    		String notiContent = boardListVO.getBoardName() + " - " + boardListVO.getTitle();
    		
    		List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();

    		Map<String, Object> recipientMap = new HashMap<String, Object>();
    		recipientMap.put("userType", "PERSON");
    		recipientMap.put("companyId", userInfo.getCompanyID());
    		recipientMap.put("cn", boardListVO.getWriterID());
    		notiRecipientList.add(recipientMap);
    		
   			String notiStatus = ezNotificationService.sendNoti(request, userInfo.getId(), userInfo.getDisplayName(), notiRecipientList, "BOARD", "RETURN", notiContent, "popup", "780", "800", linkUrl, linkUrlMobile, "");
   			logger.debug("board " +  "return" + " noti status : " + notiStatus);
		}
		
		logger.debug("sendReturnNotice ended");
	}
	
	/**
	 * 게시판 boardListPortal 화면 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardListPortal.do", method = RequestMethod.GET)
	public String boardListPortal(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		logger.debug("boardListPortal started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String boardID = request.getParameter("boardID");
		String itemCount = request.getParameter("itemCount");
		String itemFields = request.getParameter("itemFields");
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		
		List<BoardListVO> list = ezBoardService.getUnreadItems(userInfo.getId(), boardID, Integer.parseInt(itemCount), userInfo.getTenantId());
		
		int totalCount = ezBoardService.getUnreadItemsCount(userInfo.getId(), boardID, userInfo.getTenantId());
		
		if (totalCount != 0) {
			
		} else {
			
		}
		
		model.addAttribute("boardID", boardID);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("itemFields", itemFields);
		model.addAttribute("list", list);
		
		logger.debug("boardListPortal ended");
		
		return "ezBoard/boardListPortal";
	}
	
	@RequestMapping(value = "/ezBoard/boardItemPreViewPhotoContent.do", method = RequestMethod.GET)
	public String boardItemPreViewPhotoContent(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("boardItemPreViewPhotoContent started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String showAdjacent = request.getParameter("showAdjacent");
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		String mode = request.getParameter("mode");
		String likeCount = request.getParameter("likeCount");
		String disLikeCount = request.getParameter("disLikeCount");
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		
		if (!boardInfo.getRead_FG().equals("true")) {
        	return "main/warning";
        }
		
//		String retVal = "";
//		
//		if (!mode.equals("temp")) {
//			retVal = ezBoardService.getItemXML(boardID, itemID, userInfo.getLang(), userInfo.getOffset(), userInfo.getTenantId());
//		} else {
//			retVal = ezBoardService.getItemTempXML(boardID, itemID, userInfo.getLang(), userInfo.getOffset(), userInfo.getTenantId());
//		}
		
		ezBoardService.setAsRead(userInfo, boardID, itemID);

		/* 2019-04-05 홍승비 - 해당 게시물에 대해 사용자가 좋아요를 표시했는지 체크 */
		String isLikeChecked = ezBoardService.likeCheck(userInfo.getId(), itemID, userInfo.getTenantId());
		/* 2023-04-06 기민혁 - 해당 게시물에 대해 사용자가 싫어요를 표시했는지 체크 */
		String isDisLikeChecked = ezBoardService.disLikeCheck(userInfo.getId(), itemID, userInfo.getTenantId());
		
		// 2025-01-23 전인하 - 게시판 > 게시물 미리보기 > 게시물 평가하기 기능 추가
		Map<String, Object> itemStarRating = ezBoardService.getItemStarRating(itemID, userInfo.getId(), userInfo.getTenantId());
		
		model.addAttribute("itemID", itemID);
		model.addAttribute("boardID", boardID);
		model.addAttribute("mode", mode);
		model.addAttribute("showAdjacent", showAdjacent);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("likeCount", likeCount);
		model.addAttribute("isLikeChecked", isLikeChecked);
		model.addAttribute("disLikeCount", disLikeCount);
		model.addAttribute("isDisLikeChecked", isDisLikeChecked);
		model.addAttribute("attachFileNameMaxLength", ezCommonService.getTenantConfig("attachFileNameMaxLength", userInfo.getTenantId()));
		model.addAttribute("itemStarRating", itemStarRating);
				
		logger.debug("boardItemPreViewPhotoContent ended");
		
		return "ezBoard/boardItemPreViewPhotoContent";
	}
	
	@RequestMapping(value = "/ezBoard/imageUpload.do", method = RequestMethod.GET)
	public String imageUpload() throws Exception {
		logger.debug("imageUpload started");


		logger.debug("imageUpload ended");
		
		return "ezBoard/boardImageUpload";
	}
	
	@RequestMapping(value = "/ezBoard/uploadBackImage.do", method = RequestMethod.POST)
	@ResponseBody
	public void uploadBackImage(MultipartHttpServletRequest request, HttpServletResponse response, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("uploadBackImage started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		MultipartFile file = request.getFile("file1");

		String realPath = commonUtil.getRealPath(request);
		String serverPath = realPath + commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", userInfo.getTenantId());
		String savePath = realPath + commonUtil.getUploadPath("upload_board.BOARDBACKGROUND", userInfo.getTenantId());

		if (file == null) {
			if (!new File(savePath).exists()) {
				new File(savePath).mkdirs();
			}
			
			String filePath = request.getParameter("FILEPATH");
			String fileName = filePath.substring(filePath.lastIndexOf("/") + 1);
			int width = Integer.parseInt(request.getParameter("WIDTH"));
			int height = Integer.parseInt(request.getParameter("HEIGHT"));
			

			File imageFile = new File(serverPath + commonUtil.separator + fileName);
			String extension = fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length());
			
			if (imageFile.exists()) {			
				BufferedImage bi = ImageIO.read(imageFile);
				BufferedImage bufferedImage = null;
				/* 2019-10-21 홍승비 - png파일의 경우, 썸네일 이미지 저장 시 타입을 TYPE_4BYTE_ABGR로 고정 */
				if (bi.getType() == 0 || extension.equals("png")) { // 일부 png 파일의 경우, type값이 0으로 넘어오거나 검은색으로 저장된다.
					bufferedImage = new BufferedImage(width, height, BufferedImage.TYPE_4BYTE_ABGR);
				} else {
					bufferedImage = new BufferedImage(width, height, bi.getType());
				}

                bufferedImage.createGraphics().drawImage(bi, 0, 0, width, height, null);
                ImageIO.write(bufferedImage, "png", new File(savePath + commonUtil.separator + "S_" + commonUtil.detectPathTraversal(fileName)));
			}
			
			String respOutput = commonUtil.getUploadPath("upload_board.BOARDBACKGROUND", userInfo.getTenantId()) + commonUtil.separator + "S_" + commonUtil.detectPathTraversal(fileName);
			response.getWriter().write(commonUtil.stripScriptTags(respOutput));
		} else {
			String fileType = file.getContentType().split("/")[1];
			String newFileName = "{" + UUID.randomUUID().toString() + "}." + commonUtil.detectPathTraversal(fileType);
			
			if (!new File(serverPath).exists()) {
				new File(serverPath).mkdirs();
			}
			
			int width = 0;
			int height = 0;
			
			writeUploadedFile(file, newFileName, serverPath);
			
			try {
				File imageFile = new File(serverPath + commonUtil.separator + newFileName);
				
				if (imageFile.exists()) {
					BufferedImage bi = ImageIO.read(new File(serverPath + commonUtil.separator + newFileName));
					width = bi.getWidth();
					height = bi.getHeight();
					
					String respOutput = commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", userInfo.getTenantId()) + commonUtil.separator + newFileName + "|!|" + width + "|!|" + height;
					response.getWriter().write(commonUtil.stripScriptTags(respOutput));
				}
			} catch (Exception e) {
				logger.debug("uploadBackImage error");
				logger.error(e.getMessage(), e);
			}
		}
		
		logger.debug("uploadBackImage ended");
	}
	
	@RequestMapping(value="/ezBoard/boardAlertDialog.do", method = RequestMethod.GET)
	public String boardAlertDialog(
					@CookieValue("loginCookie") String loginCookie,
					@RequestParam("CAPTION") String caption,
					@RequestParam("MESSAGE") String message,
					@RequestParam("BUTTONNAMES") String buttonNames,
					HttpServletRequest request,
					LoginVO userInfo,
					Model model) throws Exception {
		logger.debug("boardAlertDialog started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		caption = caption != null ? caption : "";
		message = message != null ? message : "";
		buttonNames = buttonNames != null ? buttonNames : "";
		
		String buttonName0 = "";
		String buttonName1 = "";
		String buttonName2 = "";
		String[] buttonNamesArray = buttonNames.split(",");
		
		if (userInfo.getLang().equals("3")) {
			buttonNamesArray = buttonNames.split("、");
		}
		
		for (int i = 0; i < buttonNamesArray.length; i++) {
			switch (i) {
				case 0: buttonName0 = buttonNamesArray[i]; break;
				case 1: buttonName1 = buttonNamesArray[i]; break;
				case 2: buttonName2 = buttonNamesArray[i]; break;
				default: break;
			}
		}
		
		//logger.debug("caption : " + caption);
		model.addAttribute("caption", caption);
		model.addAttribute("message", message);
		model.addAttribute("buttonNamesArray", buttonNamesArray);
		model.addAttribute("buttonName0", buttonName0);
		model.addAttribute("buttonName1", buttonName1);
		model.addAttribute("buttonName2", buttonName2);
		
		return "ezBoard/boardAlertDialog";
	}
	
    /**
     * 댓글 팝업화면 조회
     * 강민수92
     */
    @RequestMapping(value = "/ezBoard/boardCommentPopup.do", method = RequestMethod.GET)
    public String boardCommentPopup(@CookieValue("loginCookie") String loginCookie, BoardItemVO boardItemVO, String gubun, String Reply_FG,String OneLineReplyFlag, Model model) throws Exception {
    	logger.debug("boardCommentPopup started.");
    	
    	LoginVO userInfo = commonUtil.userInfo(loginCookie);
    		
		String boardID = boardItemVO.getBoardID();
		String itemID = boardItemVO.getItemID();
		String lang = commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId());
		String publicModulus = egovFileScrty.getPbm();
        String publicExponent = "10001";
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		
    	model.addAttribute("boardInfo", boardInfo);
    	model.addAttribute("publicModulus", publicModulus);
    	model.addAttribute("publicExponent", publicExponent);
    	model.addAttribute("OneLineReplyFlag", OneLineReplyFlag);
    	model.addAttribute("Reply_FG", Reply_FG);
    	model.addAttribute("gubun", gubun);
    	model.addAttribute("boardItemVo", boardItemVO);
    	model.addAttribute("userInfo", userInfo);
		model.addAttribute("attachFileNameMaxLength", ezCommonService.getTenantConfig("attachFileNameMaxLength", userInfo.getTenantId()));
    	
    	logger.debug("boardCommentPopup ended.");
    	
    	return "/ezBoard/boardCommentPopup";
    }
    
    /**
     * ajax 댓글 목록 조회
     * 강민수92
     */
    @RequestMapping(value = "/ezBoard/getBoardComment.do", method = RequestMethod.POST)
    public String getBoardComment(@CookieValue("loginCookie") String loginCookie, BoardItemVO boardItemVO, HttpServletRequest request, Model model) throws Exception {
    	logger.debug("getBoardComment started.");
    	
    	LoginVO userInfo = commonUtil.userInfo(loginCookie);
    	String boardID = commonUtil.stripScriptTags(boardItemVO.getBoardID());
		String itemID = commonUtil.stripScriptTags(boardItemVO.getItemID());
		String lang = commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId());
		String gubun = commonUtil.stripScriptTags(request.getParameter("gubun"));
		String sort = request.getParameter("sort");
		sort = StringUtils.isBlank(sort) ? "earliest" : sort;
		
    	List<BoardLineReplyVO> boardLineReplyVOList = ezBoardService.readOneLineReply(boardID, itemID, lang, gubun, userInfo.getCompanyID(), userInfo.getTenantId(), sort);
    	
    	for (BoardLineReplyVO reply : boardLineReplyVOList) {
    		reply.setWriteDate(commonUtil.getDateStringInUTC(reply.getWriteDate(), userInfo.getOffset(), false));
    		reply.setUpdateDate(commonUtil.getDateStringInUTC(reply.getUpdateDate(), userInfo.getOffset(), false));
    	}
    	
    	String totalCommentCount = String.valueOf(boardLineReplyVOList.size());
    	
    	model.addAttribute("totalCommentCount", totalCommentCount);
    	model.addAttribute("boardLineReplyVOList", boardLineReplyVOList);
    	model.addAttribute("userInfo", userInfo);
    	logger.debug("getBoardComment ended.");
    	
    	return "json";
    }

    /**
     * 2018-02-06 김보미 - 리스트 페이징 처리
     */
	@RequestMapping(value = "/ezBoard/itemReadPagingList.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String itemReadPagingList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model, String boardID, String itemID, int pageNum, int perCount) throws Exception {
		logger.debug("itemReadPagingList started");

		userInfo = commonUtil.userInfo(loginCookie);

		/* 2018-07-02 홍승비 - companyID 조건 추가, 게시물 조회자 정보 가져올때  deptID 함께 가져오기 */
		StringBuffer resultXML = ezBoardService.getReaderList(boardID,itemID,userInfo.getId(),commonUtil.getMultiData(userInfo.getLang(),userInfo.getTenantId()), userInfo.getCompanyID(), userInfo.getTenantId(), pageNum, perCount, userInfo.getOffset());

		logger.debug("itemReadPagingList ended");
		return resultXML.toString();
	}
	
	/**
	 * 2018-04-16 홍승비 게시판 환경설정 탭 표출 수정
	 */
	@RequestMapping(value="/ezBoard/set_TabUse2.do", method = RequestMethod.POST)
	@ResponseBody
	public void set_TabUse2(@CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("set_TabUse2 started");

		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		
		String pUserID = loginVO.getId();
		String pBoardList = request.getParameter("pBoardList");
		String tabUsed = request.getParameter("tabUsed");
		int tenantID = loginVO.getTenantId();
		
		String[] pBoardLists = pBoardList.split(";");
		String tabUseds[] = tabUsed.split(";");
		
		for (int k = 0; k < pBoardLists.length; k++) {
			ezBoardService.setTabUsed(pUserID, pBoardLists[k], tabUseds[k], loginVO.getCompanyID(), tenantID);
		}

		logger.debug("set_TabUse2 ended");
	}
	
	/**
	 * 2018-04-27 김혜정 게시판 검색
	 */
	@RequestMapping(value="/ezBoard/boardSearchView.do", method = RequestMethod.GET)
	public String boardSearchView(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, BoardVO boardVO, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("boardSearchView started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		boardVO.setBoardType("N");
		boardVO.setLang(userInfo.getLang());
		boardVO.setTenantID(userInfo.getTenantId());
		
		List<BoardListHeaderVO> headerList = ezBoardService.getListHeaderBoardID(userInfo, boardVO);
		
		StringBuffer resultXML = new StringBuffer();

		resultXML.append("<DOCLIST>");
        resultXML.append("<LISTVIEWDATA>");
        resultXML.append("<HEADERS>");
        
        /* 2018-07-16 홍승비 - 체크박스를 사용하지 않는 게시판검색 기능 */
        for (BoardListHeaderVO vo : headerList) {
        	if(vo.getName().toUpperCase().equals("CHECK")){
        		resultXML.append("<HEADER>");
        		resultXML.append("<NAME>" + vo.getName() + "</NAME>");
            	resultXML.append("<WIDTH>0</WIDTH>");
            	resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
            	resultXML.append("</HEADER>");
        	}
        	else{
	        	resultXML.append("<HEADER>");
	    		resultXML.append("<NAME>" + vo.getName() + "</NAME>");
	        	resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
	        	resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
	        	resultXML.append("</HEADER>");
        	}
        }
        
        resultXML.append("</HEADERS>");
        resultXML.append("<ROWS>");
        resultXML.append("</ROWS>");
        resultXML.append("</LISTVIEWDATA>");
        resultXML.append("</DOCLIST>");
		
		String type = request.getParameter("type") != null ? request.getParameter("type") : "";
		String data = request.getParameter("data") != null ? request.getParameter("data") : "";
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("listHeader", resultXML);
		model.addAttribute("keyType", type);
		model.addAttribute("keyData", data);
		
		logger.debug("boardSearchView ended");
		return "/ezBoard/boardSearchView";
	}
	
	/**
	 * 2018-04-27 김혜정 게시판 선택
	 */
	@RequestMapping(value="/ezBoard/selectBoardItem.do", method = RequestMethod.GET)
	public String selectBoardItem(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) {
		logger.debug("selectBoardItem started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("selectBoardItem ended");
		return "/ezBoard/boardSelectItem2";
	}

	/**
	 * 2018-05-09 강민수92 게시물승인 카운트 호출
	 */
	@RequestMapping(value="/ezBoard/getApplyCount.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getApplyCount(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		int applyCount = ezBoardService.getApprBoardTotalItemCount(userInfo);
		
		return Integer.toString(applyCount);
	}
	
	/**
	 * 검색 가능한 게시판 Method
	 */
	public Map<String, ArrayList<String>> searchBoardList(LoginVO userInfo) throws Exception {
		logger.debug("searchBoardList started");
		
		String pRootBoardID = "top";
		String pSubFlag = "1";
		int pSelectBy = 0;
		String pExcludeBoardID = " ";
		String isAdminLeft = "";
		/* 2018-10-16 홍승비 - 전체관리자 플래그 추가 */
		boolean isCompanyAdmin = commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "c");
		
		String boardGroupAdmin_FG = "NO";
		int pMode = commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "c;n;k") ? 0 : 1;
		String strXML = ezBoardService.getBoardTree(pRootBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), pMode, Integer.parseInt(pSubFlag), pSelectBy, pExcludeBoardID,
				commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), isAdminLeft, isCompanyAdmin, boardGroupAdmin_FG, userInfo.getRollInfo(), userInfo.getTenantId());
		Document doc = commonUtil.convertStringToDocument(strXML);
		NodeList nList = doc.getElementsByTagName("NODE");
		
		ArrayList<String> accessBoardList = new ArrayList<String>();
		ArrayList<String> tempBoardList = new ArrayList<String>();
		ArrayList<String> accessAllBoardList = new ArrayList<String>();
		
		for (int i = 0; i < nList.getLength(); i++) {
			accessBoardList.add(nList.item(i).getChildNodes().item(2).getTextContent());
		}
		
		/* 2019-06-03  홍승비 - 게시판그룹 관리자권한 체크 시 사내겸직 및 하위부서 허용여부 체크하도록 수정 */
		//접근가능한 게시판
		while (accessBoardList.size() != 0) {
			for (int i = 0; i < accessBoardList.size(); i++) {
				boardGroupAdmin_FG = checkIfBoardGroupAdmin(accessBoardList.get(i), userInfo);
				pMode = boardGroupAdmin_FG.equals("OK") || commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "c;n;k") ? 0 : 1;
				strXML = ezBoardService.getBoardTree(accessBoardList.get(i), userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), pMode, Integer.parseInt(pSubFlag), pSelectBy, pExcludeBoardID,
						commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), isAdminLeft, isCompanyAdmin, boardGroupAdmin_FG, userInfo.getRollInfo(), userInfo.getTenantId());
				doc = commonUtil.convertStringToDocument(strXML);
				nList = doc.getElementsByTagName("NODE");
				
				for (int j = 0; j < nList.getLength(); j++) {
					tempBoardList.add(nList.item(j).getChildNodes().item(2).getTextContent()); 
					accessAllBoardList.add(nList.item(j).getChildNodes().item(2).getTextContent());  
				}
			}
			
			accessBoardList.clear();
			accessBoardList.addAll(tempBoardList);
			tempBoardList.clear();
		}
		
		//리스트뷰 true게시판 & qna게시판
		Map<String, ArrayList<String>> map = new HashMap<String, ArrayList<String>>();
		
		ArrayList<String> listviewTrueList = new ArrayList<String>();
		ArrayList<String> qnaItemList = new ArrayList<String>();
		BoardPropertyVO boardInfo;
		
		for (int i = 0; i < accessAllBoardList.size(); i++) {
			boardInfo = getBoardInfo(accessAllBoardList.get(i), userInfo);
			if (boardInfo.getListView_FG().equals("true")) {
				if (boardInfo.getGuBun().equals("5") && boardInfo.getBoardAdmin_FG().equals("false")) {
					qnaItemList.add(accessAllBoardList.get(i));
				} else {
					listviewTrueList.add(accessAllBoardList.get(i));
				}
			}
			boardInfo = null;
		}
		
		map.put("listviewTrueList", listviewTrueList);
		map.put("qnaItemList", qnaItemList);
		
		logger.debug("searchBoardList ended");
		return map;
	}
	
	/**
	 * 게시판 검색 리스트 Method
	 */
	public String getSearchAllBoardListItemXML(LoginVO userInfo, BoardVO boardVO, Map<String, String> searchMap, String keywordClick) throws Exception {
		logger.debug("getSearchAllBoardListItemXML started");

		String orderOption1 = "";
		String orderOption2 = "";
		String strMultiData = commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId());
		boardVO.setLang(userInfo.getLang());
		boardVO.setTenantID(userInfo.getTenantId());
		
		List<BoardListHeaderVO> headerList = ezBoardService.getListHeaderBoardID(userInfo, boardVO);
		
		// 헤더 정보를 세팅한다.
		int i = 0;
		int hlength = headerList.size();
		Map<String, String> orderByMap = new HashMap<String, String>();
		
		for (i = 0; i < hlength; i++) {
			if (boardVO.getOrderCell() != null && !boardVO.getOrderCell().equals("") && boardVO.getOrderCell().equals(headerList.get(i).getName())) {
				orderByMap.put("orderByCol", headerList.get(i).getColName());
				if ("".equals(boardVO.getOrderOption())) {
					orderByMap.put("orderByColDesc", "N");
					orderOption1 = headerList.get(i).getColName() + " ";
					orderOption2 = headerList.get(i).getColName() + " DESC ";
				} else {
					orderByMap.put("orderByColDesc", "Y");
					orderOption1 = headerList.get(i).getColName() + " DESC ";
					orderOption2 = headerList.get(i).getColName() + " ";
				}
			}
		}
		
		boardVO.setNowDate(commonUtil.getTodayUTCTime(""));
		
		Map<String, ArrayList<String>> resultmap = null;
		ArrayList<String> listviewTrueList = null;
		ArrayList<String> qnaItemList = null;
		
		/* 2019-06-10 홍승비 - 게시판 전체검색 시 전체관리자가 아니라면 그룹사게시판에도 권한 적용하도록 수정 */
		int pMode = 1;
		if (commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "c")) {
			pMode = 0; // 전체관리자일때
			listviewTrueList = new ArrayList<String>();
			qnaItemList = new ArrayList<String>();
		} else if (commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "n;k")) {
			pMode = 1; // 게시관리자, 회사관리자일때
			resultmap = searchBoardList(userInfo);
			listviewTrueList = resultmap.get("listviewTrueList");
			qnaItemList = resultmap.get("qnaItemList");
		} else {
			pMode = 1; // 관리자가 아닐때
			resultmap = searchBoardList(userInfo);
			listviewTrueList = resultmap.get("listviewTrueList");
			qnaItemList = resultmap.get("qnaItemList");
		}
		
		int boardCount;
		if (pMode == 1 && listviewTrueList.size() == 0 && qnaItemList.size() == 0) {
			boardCount = 0;
		} else {
			boardCount = ezBoardService.getSearchAllBoardItemCount(userInfo, boardVO, listviewTrueList, qnaItemList, pMode, searchMap, keywordClick);
		}
		
		BoardListVO boardListVO = new BoardListVO();
		boardListVO.setPageCount(boardCount);
		boardListVO.setTotalCount(boardCount);
		boardListVO.setStartRow(1);
		boardListVO.setEndRow(0);
		boardListVO.setOrderBySub(orderOption1);
		boardListVO.setOrderByMain(orderOption2);
		boardListVO.setUserID(userInfo.getId());
		
		BoardConfigVO boardConfigVO = ezBoardService.getPersonalCount(userInfo);
		
		boardListVO.setStartRow(boardConfigVO.getListCount() * (boardVO.getPageNum()-1) + 1);
		boardListVO.setEndRow(boardConfigVO.getListCount() * boardVO.getPageNum());
		
		if (boardVO.getTitle() == null) {
			boardVO.setTitle("");
		}
		
		if (boardVO.getABSTRACT() == null) {
			boardVO.setABSTRACT("");
		}
		
		if (boardVO.getWriterName() == null) {
			boardVO.setWriterName("");
		}
		
		if (boardVO.getKeyword() == null) {
			boardVO.setKeyword("");
		}
		
		List<HashMap<String, Object>> boardSearchList;
		int dlength;
		
		if (pMode == 1 && listviewTrueList.size() == 0 && qnaItemList.size() == 0) {
			boardSearchList = null;
			dlength = 0;
		} else {
			boardSearchList = ezBoardService.getSearchAllBoardItemList(userInfo, boardListVO, boardVO, listviewTrueList, qnaItemList, pMode, searchMap, orderByMap, keywordClick);
			dlength = boardSearchList.size();
		}
		
		StringBuffer resultXML = new StringBuffer();
		
		resultXML.append("<DOCLIST>");
		resultXML.append("<TOTALCNT>" + boardCount + "</TOTALCNT>");
		resultXML.append("<PAGECNT>" + boardCount + "</PAGECNT>");
		resultXML.append("<PERSONALCNT>" + boardConfigVO.getListCount() + "</PERSONALCNT>");
		resultXML.append("<PREVIEWTYPE>" + boardConfigVO.getPreview() + "</PREVIEWTYPE>");
		resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
		resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
		resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
		resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		/* 2018-07-16 홍승비 - 체크박스를 사용하지 않는 게시판검색 기능 */
		for (BoardListHeaderVO vo:headerList) {
			if(vo.getName().toUpperCase().equals("CHECK")){
        		resultXML.append("<HEADER>");
        		resultXML.append("<NAME>" + vo.getName() + "</NAME>");
            	resultXML.append("<WIDTH>0</WIDTH>");
            	resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
            	resultXML.append("</HEADER>");
        	}
        	else{
	        	resultXML.append("<HEADER>");
	    		resultXML.append("<NAME>" + vo.getName() + "</NAME>");
	        	resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
	        	resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
	        	resultXML.append("</HEADER>");
        	}
		}
		
		resultXML.append("</HEADERS>");
		resultXML.append("<ROWS>");
		
		String fieldName = "";
		String fieldValue = "";
		BoardPropertyVO boardInfo;
		
		for (int j = 0; j < dlength; j++) {
			resultXML.append("<ROW>");
			for (i = 0; i < hlength; i++) {
				resultXML.append("<CELL>");
				fieldName = headerList.get(i).getColName().toUpperCase();
				
				if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME")) {
					fieldName = fieldName + strMultiData;
				}
				if (fieldName.equals("WRITEDATE")) {
					fieldValue = commonUtil.getDateStringInUTC((String)boardSearchList.get(j).get(fieldName), userInfo.getOffset(), false);
					fieldValue = fieldValue.substring(0, fieldValue.length()-3);
				} else {
					fieldValue = commonUtil.cleanValue(String.valueOf(boardSearchList.get(j).get(fieldName)));
				}
				
				if (fieldValue == null || fieldValue.equals("null")) {
					fieldValue = "";
				}
				
				resultXML.append("<VALUE>"+fieldValue+"</VALUE>");
				
				if (i == 0) {
					resultXML.append("<DATA1>" + boardSearchList.get(j).get("BOARDID") + "</DATA1>"); 
					resultXML.append("<DATA2>" + boardSearchList.get(j).get("ITEMID") + "</DATA2>");
					resultXML.append("<DATA3>" + boardSearchList.get(j).get("WRITERID") + "</DATA3>");
					resultXML.append("<DATA4>" + boardSearchList.get(j).get("IMPORTANCE") + "</DATA4>");
					resultXML.append("<DATA5>" + boardSearchList.get(j).get("READFLAG") + "</DATA5>");
					resultXML.append("<DATA6>" + commonUtil.cleanValue(String.valueOf(boardSearchList.get(j).get("ABSTRACT"))) + "</DATA6>");
					String nowDate = commonUtil.getTodayUTCTime("");
					nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
					
					if (boardSearchList.get(j).get("WRITEDATE").toString().compareTo(nowDate) > 0) {
						resultXML.append("<DATA7>Y</DATA7>");
					} else {
						resultXML.append("<DATA7>N</DATA7>");
					}
					
					resultXML.append("<DATA8>" + boardSearchList.get(j).get("ITEMLEVEL") + "</DATA8>");
					resultXML.append("<DATA9>" + boardSearchList.get(j).get("NOTICE") + "</DATA9>");
					resultXML.append("<DATA10>" + boardSearchList.get(j).get("GUBUN") + "</DATA10>");
					resultXML.append("<DATA11>" + boardSearchList.get(j).get("ONELINECNT") + "</DATA11>");
					
					if (globals.getProperty("Globals.DbType").equals("oracle")) {
						resultXML.append("<DATA12>" + commonUtil.cleanValue((String)boardSearchList.get(j).get("TO_CHAR(MAINCONTENT)")) + "</DATA12>");
					} else if (globals.getProperty("Globals.DbType").equals("tibero")) {
						resultXML.append("<DATA12>" + commonUtil.cleanValue((String)boardSearchList.get(j).get("TO_CHAR(MAINCONTENT)")) + "</DATA12>");
					} else {
						resultXML.append("<DATA12>" + commonUtil.cleanValue((String)boardSearchList.get(j).get("MAINCONTENT")) + "</DATA12>");
					}
					
					resultXML.append("<PUBLICFLAG>" + boardSearchList.get(j).get("PUBLICFLAG") + "</PUBLICFLAG>");
					
					boardInfo = getBoardInfo(boardSearchList.get(j).get("BOARDID").toString(), userInfo);
					resultXML.append("<DATA13>" + boardInfo.getRead_FG() +"</DATA13>");

					resultXML.append("<EXT>" + commonUtil.cleanValue(String.valueOf(boardSearchList.get(j).get("EXT"))) + "</EXT>");
					resultXML.append("<FILEPATH>" + commonUtil.cleanValue(String.valueOf(boardSearchList.get(j).get("FILEPATH"))) + "</FILEPATH>");
					
					boardInfo = null;
					
				}
				resultXML.append("</CELL>");
			}
			resultXML.append("</ROW>");
		}
		
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		resultXML.append("</DOCLIST>");

		logger.debug("getSearchAllBoardListItemXML ended");
		return resultXML.toString();
	}
	
	/** 2018-06-28 홍승비 - 승인게시판 검색기능 추가 */
	public String getSearchApprListItemXML(LoginVO userInfo, BoardVO boardVO, Map<String, String> searchMap) throws Exception {
		logger.debug("getSearchApprListItemXML started");

		String orderOption1 = "";
		String orderOption2 = "";
		String strMultiData = commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId());
		
		boardVO.setLang(userInfo.getLang());
		boardVO.setTenantID(userInfo.getTenantId());
		
		List<BoardListHeaderVO> headerList = ezBoardService.getListHeader(userInfo, boardVO);
		
		// 헤더 정보를 세팅한다.
		int i = 0;
		int hlength = headerList.size();

		// 20240215 : 김진홍 : CSAP 인증 처리
		Map<String, String> orderByMap = new HashMap<String, String>();
		
		for (i = 0; i < hlength; i++) {
			if (boardVO.getOrderCell() != null && !boardVO.getOrderCell().equals("") && boardVO.getOrderCell().equals(headerList.get(i).getName())) {
				orderByMap.put("orderByCol", headerList.get(i).getColName().toUpperCase());
				if ("".equals(boardVO.getOrderOption())) {
					orderByMap.put("orderByColDesc", "N");
					orderOption1 = headerList.get(i).getColName() + " ";
					orderOption2 = headerList.get(i).getColName() + " DESC ";
				} else {
					orderByMap.put("orderByColDesc", "Y");
					orderOption1 = headerList.get(i).getColName() + " DESC ";
					orderOption2 = headerList.get(i).getColName() + " ";
				}
			}
		}
		
		// 승인게시물 검색 결과 카운트에 companyID 조건 추가
		int boardCount = 0;
		boardCount = ezBoardService.getSearchApprBoardItemCount(userInfo, boardVO, searchMap);
		
		BoardListVO boardListVO = new BoardListVO();	
		boardListVO.setPageCount(boardCount);
		boardListVO.setTotalCount(boardCount);
		boardListVO.setStartRow(1);
		boardListVO.setEndRow(0);
		boardListVO.setOrderBySub(orderOption1);
		boardListVO.setOrderByMain(orderOption2);
		boardListVO.setUserID(userInfo.getId());
		boardListVO.setWriterCompanyID(userInfo.getCompanyID());
		
		BoardConfigVO boardConfigVO = ezBoardService.getPersonalCount(userInfo);
		
		boardListVO.setStartRow(boardConfigVO.getListCount() * (boardVO.getPageNum()-1) + 1);
		boardListVO.setEndRow(boardConfigVO.getListCount() * boardVO.getPageNum());
		
		if (boardVO.getTitle() == null) {
			boardVO.setTitle("");
		}
		
		if (boardVO.getABSTRACT() == null) {
			boardVO.setABSTRACT("");
		}
		
		if (boardVO.getWriterName() == null) {
			boardVO.setWriterName("");
		}

		if (boardVO.getKeyword() == null) {
			boardVO.setKeyword("");
		}
		
		// 승인게시물 검색 결과 리스트에 companyID 조건 추가
		List<HashMap<String, Object>> boardSearchList = null;
		boardSearchList = ezBoardService.getSearchApprBoardItemList(boardListVO, boardVO, searchMap, orderByMap);

		int dlength = boardSearchList.size();
		
		StringBuffer resultXML = new StringBuffer();
		
		resultXML.append("<DOCLIST>");
		resultXML.append("<TOTALCNT>" + boardCount + "</TOTALCNT>");
		resultXML.append("<PAGECNT>" + boardCount + "</PAGECNT>");
		resultXML.append("<PERSONALCNT>" + boardConfigVO.getListCount() + "</PERSONALCNT>");
		resultXML.append("<PREVIEWTYPE>" + boardConfigVO.getPreview() + "</PREVIEWTYPE>");
		resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
		resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
		resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
		resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (BoardListHeaderVO vo:headerList) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + vo.getName() + "</NAME>");
			resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
			resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
			resultXML.append("</HEADER>");
		}
		
		resultXML.append("</HEADERS>");
		resultXML.append("<ROWS>");
		
		String fieldName = "";
		String fieldValue = "";
		
		for (int j = 0; j < dlength; j++) {
			resultXML.append("<ROW>");
			for (i = 0; i < hlength; i++) {
				resultXML.append("<CELL>");
				fieldName = headerList.get(i).getColName().toUpperCase();
				
				if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME")) {
					fieldName = fieldName + strMultiData;
				}
				
				if (fieldName.equals("WRITEDATE")) {
					fieldValue = commonUtil.getDateStringInUTC((String)boardSearchList.get(j).get(fieldName), userInfo.getOffset(), false);
					fieldValue = fieldValue.substring(0, fieldValue.length() - 3);
				} else {
					fieldValue = commonUtil.cleanValue(String.valueOf(boardSearchList.get(j).get(fieldName)));
				}
				
				resultXML.append("<VALUE>" + fieldValue + "</VALUE>");
				
				if (i == 0) {
					resultXML.append("<DATA1>" + boardSearchList.get(j).get("BOARDID") + "</DATA1>");
					resultXML.append("<DATA2>" + boardSearchList.get(j).get("ITEMID") + "</DATA2>");
					resultXML.append("<DATA3>" + boardSearchList.get(j).get("WRITERID") + "</DATA3>");
					resultXML.append("<DATA4>" + boardSearchList.get(j).get("IMPORTANCE") + "</DATA4>");
					resultXML.append("<DATA5>" + boardSearchList.get(j).get("READFLAG") + "</DATA5>");
					resultXML.append("<DATA6>" + commonUtil.cleanValue(String.valueOf(boardSearchList.get(j).get("ABSTRACT"))) + "</DATA6>");
					
					String nowDate = commonUtil.getTodayUTCTime("");
					nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
					
					if (boardSearchList.get(j).get("WRITEDATE").toString().compareTo(nowDate) > 0) {
						resultXML.append("<DATA7>Y</DATA7>");
					} else {
						resultXML.append("<DATA7>N</DATA7>");
					}
					
					resultXML.append("<DATA8>" + boardSearchList.get(j).get("ITEMLEVEL") + "</DATA8>");
					resultXML.append("<DATA9>" + boardSearchList.get(j).get("NOTICE") + "</DATA9>");
					resultXML.append("<DATA10>" + boardSearchList.get(j).get("GUBUN") + "</DATA10>");
					resultXML.append("<DATA11>" + boardSearchList.get(j).get("ONELINECNT") + "</DATA11>");
					resultXML.append("<EXT>" + commonUtil.cleanValue(String.valueOf(boardSearchList.get(j).get("EXT"))) + "</EXT>");
					resultXML.append("<FILEPATH>" + commonUtil.cleanValue(String.valueOf(boardSearchList.get(j).get("FILEPATH"))) + "</FILEPATH>");

				}
				
				resultXML.append("</CELL>");
			}
			
			resultXML.append("</ROW>");
		}
		
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		resultXML.append("</DOCLIST>");

		logger.debug("getSearchApprListItemXML ended");
		return resultXML.toString();
	}
	
	/**
	 * 2018-10-11 홍승비 - 모두저장(압축파일 내려받기)
	 */
	@RequestMapping(value="/ezBoard/downloadAttachAll.do", method = RequestMethod.POST, produces="text/plain; charset=UTF-8")
	@ResponseBody
	public void downloadAttachAll(@CookieValue("loginCookie") String loginCookie, Locale locale, 
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("downloadAttachAll started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);		
		String filePath = request.getParameter("filePath");
		String fileNames = request.getParameter("fileNames");
		String fileNamesUID = request.getParameter("fileNamesUID");
		String realPath = commonUtil.getRealPath(request);
		String uploadFilePath = commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId());
		String tempFileUploadPath = realPath + uploadFilePath + commonUtil.separator + "tempUploadFile";
		String guid = UUID.randomUUID().toString();
		String pDirTempPath = tempFileUploadPath + commonUtil.separator + guid;
		String fullFilePath = realPath + filePath;
		// int bufferSize = 4096;

		//logger.debug("fullFilePath : " + fullFilePath);
		//logger.debug("fileNames : " + fileNames);
		
		ZipOutputStream zos = null;
		String downFileName = "";
		
		try {
			File tempFile = new File(pDirTempPath + commonUtil.separator + ".zip");
			
			if (tempFile.exists()) {
				tempFile.delete();
			}
			
			tempFile = new File(tempFileUploadPath);
			
			if (!tempFile.exists()) {
				tempFile.mkdirs();
			}
			
			zos = new ZipOutputStream(new FileOutputStream(pDirTempPath + ".zip"), Charset.forName("utf-8"));
			
			String[] fileNamesArr = fileNames.split(":");
			String[] fileNamesUIDArr = fileNamesUID.split(":");
			
			downFileName = fileNamesArr[0] + " " + egovMessageSource.getMessage("ezCircular.t50", userInfo.getLocale()) + " " + (fileNamesArr.length-1) + egovMessageSource.getMessage("ezStatistics.t1067", userInfo.getLocale()) + ".zip";//zip파일명
			
			/* 2019-04-02 홍승비 - 중복된 파일명을 덮어쓰지 않고 (1), (2)... 붙이도록 수정 */
			Map<String, Integer> fileNameMap = new HashMap<String, Integer>();
			
			if (fileNamesArr.length != 0) {// 파일이 있으면
				for (int i = 0; i < fileNamesArr.length; i++) { // 파일 갯수만큼
					BufferedInputStream bis = null;
					
					try {
						File sourceFile = new File(commonUtil.detectPathTraversal(fullFilePath + fileNamesUIDArr[i]));
						byte[] fileBytes = commonUtil.readBytesFromFile(sourceFile.toPath());
						
						if (fileNamesUIDArr[i].endsWith("." + EzApprovalGKlibService.ENCRYPTED_FILE_EXT)) {
							fileBytes = klibUtil.decrypt(fileBytes);
						}
						
						fileNamesArr[i] = commonUtil.getUniqueFileName(fileNamesArr[i], fileNameMap);
						ZipEntry zentry = new ZipEntry(fileNamesArr[i]);
						zos.putNextEntry(zentry);
						zos.write(fileBytes);
						zos.closeEntry();
					} catch (IOException e) {
						logger.error(e.getMessage(), e);
					} finally {
						if (bis != null) {
							try {
								bis.close();
							} catch (Exception e) {
								logger.error(e.getMessage(), e);
							}
						}
					}
				}
				zos.flush();
				zos.close();
				zos = null;
	
				File file = new File(pDirTempPath + ".zip");
				
				if (file.exists()) {
					downFile(request, response, pDirTempPath + ".zip", downFileName);
					file.delete();
				}
			}
		} catch (Exception e) {
			File file = new File(pDirTempPath + ".zip");
			
			if (file.exists()) {
				file.delete();
			}
		} finally {
			if (zos != null) {
				try {
					zos.close();
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
				}
			}
		}
		logger.debug("downloadAttachAll ended.");
	}
	
	/**
	 * 동영상게시판 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardItemListMovie.do", method = RequestMethod.GET)
	public String boardItemListMovie(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("boardItemListMovie started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String mode = "new";
		String apprFlag = "Y";
		String useOCS = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId());
		String useRunTime = ezCommonService.getTenantConfig("USERUNTIME", userInfo.getTenantId());
		String boardID = request.getParameter("boardID");
		String boardType = request.getParameter("boardType");
		String adminType = request.getParameter("adminType");
		String buttonHidden = "N";
		String boardName = request.getParameter("boardName");
		String boardViewForm = request.getParameter("boardViewForm");
		String useOneLineCount = "NO";
		String sortBy = "";
		int page = 0;
		
		if (request.getParameter("buttonHidden") != null) {
			buttonHidden = request.getParameter("buttonHidden");
		}
		if (request.getParameter("boardViewForm") == null) {
			boardViewForm = "thumbnail";
		}
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		BoardPropertyVO boardProperty = ezBoardService.getBoardProperty(boardID, userInfo.getTenantId());
		
		if (boardInfo.getListView_FG().equals("true")) {
			// 2024-08-22 조소정 - 게시판 리스트 호출 시 게시판 이름 사용자 설정 언어로 표출
			String userLang = userInfo.getLang();
			boardName = boardInfo.getBoardName(); // 기본값은 한국어로 설정

			if (userLang.equals("2") && boardInfo.getBoardName2() != null && !boardInfo.getBoardName2().isEmpty()) {
				boardName = boardInfo.getBoardName2();
			} else if (userLang.equals("3") && boardInfo.getBoardName3() != null && !boardInfo.getBoardName3().isEmpty()) {
				boardName = boardInfo.getBoardName3();
			} else if (userLang.equals("4") && boardInfo.getBoardName4() != null && !boardInfo.getBoardName4().isEmpty()) {
				boardName = boardInfo.getBoardName4();
			}
			
			if (request.getParameter("sortBy") != null) {
				sortBy = request.getParameter("sortBy");
			}
			
			if (request.getParameter("page") == null) {
				page = 1;
			} else {
				page = Integer.parseInt(request.getParameter("page"));
			}
		}
		
		// 현재 자신의 회사에서 즐겨찾기한 게시판 + 그룹사 게시판의 즐겨찾기 여부를 체크
		String isMyBoard = "";
		int isMyBoardExist = ezBoardService.getIsMyBoardExist(boardID, userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
		if (isMyBoardExist > 0) {
			isMyBoard = "YES";
		}

		String endDateOption = checkEndDateConfig(boardInfo, userInfo);

		model.addAttribute("mode", mode);
		model.addAttribute("apprFlag", apprFlag);
		model.addAttribute("useOCS", useOCS);
		model.addAttribute("useRunTime", useRunTime);
		model.addAttribute("boardID", boardID);
		model.addAttribute("boardType", boardType);
		model.addAttribute("adminType", adminType);
		model.addAttribute("buttonHidden", buttonHidden);
		model.addAttribute("boardName", commonUtil.cleanValue(boardName).replace("\\", "&#92;"));
		model.addAttribute("useOneLineCount", useOneLineCount);
		model.addAttribute("sortBy", sortBy);
		model.addAttribute("page", page);
		model.addAttribute("boardProperty", boardProperty);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("isMyBoard", isMyBoard);
		model.addAttribute("endDateOption", endDateOption);
		model.addAttribute("useKeyword", boardInfo.getUseKeyword());
		model.addAttribute("boardViewForm", boardViewForm);
		model.addAttribute("MyBoardScrapFlag", ezCommonService.getTenantConfig("MyBoardScrapFlag", userInfo.getTenantId()));

		logger.debug("boardItemListMovie ended");
		return "ezBoard/boardItemListMovie";
	}
	
	/**
	 * 게시판 동영상게시물 게시하기 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/newBoardItemMovie.do", method = RequestMethod.GET)
	public String newBoardItemMovie(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("newBoardItemMovie started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String userID = "";
		String userEditor = ezCommonService.getTenantConfig("MODULEEDITOR", userInfo.getTenantId());
		String boardID = request.getParameter("boardID");
		String url = request.getParameter("url");
		String boardType = request.getParameter("bType");
		String uploadFilePath = "";
		String strNow = "";
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		
		if (boardInfo.getWrite_FG().equals("false")) {
			return "main/warning"; 
		}
		
		String guBun = boardInfo.getGuBun();
		String paramGuBun = request.getParameter("gubun");
		
		if (!"7".equals(guBun) || (StringUtils.isNotEmpty(paramGuBun) && !guBun.equals(paramGuBun))) {
			model.addAttribute("gubunExchanged", "Y");
			return "main/warning_board";
		}
		
		uploadFilePath = commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId());
		strNow = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
		
		/* 2019-08-06 홍승비 - 동영상 게시물 작성 시 작성자 이름 다국어 처리 */
		if (userInfo.getPrimary().equals("1")) {
			userID = userInfo.getDisplayName1();
		} else {
			userID = userInfo.getDisplayName2();
		}
		
		// 2024-08-22 조소정 - 게시판 리스트 호출 시 게시판 이름 사용자 설정 언어로 표출
		String userLang = userInfo.getLang();		
		String boardName = boardInfo.getBoardName(); // 기본값은 한국어로 설정

		if (userLang.equals("2") && boardInfo.getBoardName2() != null && !boardInfo.getBoardName2().isEmpty()) {
			boardName = boardInfo.getBoardName2();
		} else if (userLang.equals("3") && boardInfo.getBoardName3() != null && !boardInfo.getBoardName3().isEmpty()) {
			boardName = boardInfo.getBoardName3();
		} else if (userLang.equals("4") && boardInfo.getBoardName4() != null && !boardInfo.getBoardName4().isEmpty()) {
			boardName = boardInfo.getBoardName4();
		}
		
		String displayName = "";
		if (userInfo.getPrimary().equals("1")) {
			displayName = userInfo.getDisplayName1();
		} else {
			displayName = userInfo.getDisplayName2();
		}
		
		String deptName = "";
		if (userInfo.getPrimary().equals("1")) {
			deptName = userInfo.getDeptName1();
		} else {
			deptName = userInfo.getDeptName2();
		}

		model.addAttribute("userID", userID);
		model.addAttribute("userEditor", userEditor);
		model.addAttribute("boardID", boardID);
		model.addAttribute("url", url);
		model.addAttribute("boardType", boardType);
		model.addAttribute("uploadFilePath", uploadFilePath);
		model.addAttribute("strNow", strNow);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("boardName", boardName);
		model.addAttribute("useKeyword", boardInfo.getUseKeyword());
		model.addAttribute("displayName",displayName);
		model.addAttribute("deptName", deptName);
		if ("Y".equals(boardInfo.getWriterFlag())) {
			model.addAttribute("writerOption", ezBoardService.getWriterOption(userInfo));
		}

		logger.debug("newBoardItemMovie ended");
		return "ezBoard/boardNewItemMovie";
	}
	
	/**
	 * 동영상게시판 동영상과 썸네일 업로드
	 */
	@RequestMapping(value = "/ezBoard/boardMovieUpload.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String MovieUpload(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("MovieUpload started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String mode = request.getParameter("mode");
		String pFileLimit = request.getParameter("fileLimit");
		String uniqueID = request.getParameter("uniqueID");
		String realPath = commonUtil.getRealPath(request);
		String dirPath = "";
		String serverPath = "";
		String resultUpload = "";
		String fileName = "";
		String fileLocation = "";
		String thumbnailName = "";
		long fileSize = 0;
		MultipartFile multiFile = null;
		String fileExt = "";
		
		if (mode.equals("MOVIE")) { // 동영상 업로드
			multiFile = request.getFile("file1");
			dirPath = realPath + commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", userInfo.getTenantId());
			serverPath = dirPath + commonUtil.separator;
		} else if (mode.equals("DEL")) { // 삭제
			String delServerPath = realPath + commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", userInfo.getTenantId());
			String imagePath = "";
			String s_imagePath = "";
			imagePath = commonUtil.detectPathTraversal(delServerPath + commonUtil.separator + uniqueID);
			s_imagePath = commonUtil.detectPathTraversal(delServerPath + commonUtil.separator + "s_" + uniqueID);
			File file = new File(imagePath);
			File file1 = new File(s_imagePath);
			
			if (file.exists()) {
				deleteFile(imagePath);
			}
			
			if (file1.exists()) {
				deleteFile(s_imagePath);
			}
			
			return "DEL";
		} else { // 임시저장
			multiFile = request.getFile("file1");
			dirPath = realPath + commonUtil.getUploadPath("upload_personal.PHOTOTEMP", userInfo.getTenantId());
			serverPath = dirPath + commonUtil.separator;
		}
		
		StringBuffer strXML = new StringBuffer();

		if (multiFile != null) {
			/* 2021-12-08 홍승비 - 동영상게시물 영상 업로드 시 서버단에서도 확장자 체크 진행 */
			String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", userInfo.getTenantId());
			String orgName = multiFile.getOriginalFilename();
			fileExt = orgName.substring(orgName.lastIndexOf(".") + 1, orgName.length());
			logger.debug("MovieUpload file extension is : " + fileExt);
			
			if (commonUtil.checkMovExtension(fileExt) == false || (!useExtension.equals("*") && useExtension.toLowerCase().indexOf(fileExt.toLowerCase()) < 0)) {
				logger.debug("MovieUpload failed, checkMovExtension return false");
				
				return "UPLOAD_EXT_ERROR";
			}
			
			String uniqueName = "";
			File file = new File(serverPath);
			
			if (!file.exists()) {
				file.mkdirs();
			}
						
			strXML.append("<ROOT><NODES>");
			
			if (pFileLimit != null && (pFileLimit.equals("0") || pFileLimit.equals(""))) {
				pFileLimit = "2";
			}
			
			long fileLimit = Long.parseLong(pFileLimit) * 1024 * 1024;
			
			fileSize = multiFile.getSize();
			if (fileSize > fileLimit) {
				resultUpload = "overflow";
				strXML.append("<NODE><PUPLOADSN><![CDATA[" + uniqueName + "]]></PUPLOADSN>");
				strXML.append("<RESULTUPLOADA><![CDATA[" + resultUpload + "]]></RESULTUPLOADA>");
				strXML.append("<PFILENAME><![CDATA[" + fileName + "]]></PFILENAME>");
				strXML.append("<FILESIZE>" + fileSize + "</FILESIZE>");
				strXML.append("<FILELOCATION><![CDATA[" + fileLocation + "]]></FILELOCATION>");
				strXML.append("<MODE><![CDATA[" + mode + "]]></MODE>");
				strXML.append("</NODE>");
			} else {
				if (multiFile.getOriginalFilename() != null && !multiFile.getOriginalFilename().equals("")) {
					String pFileName = multiFile.getOriginalFilename();
					
					if (pFileName.indexOf(commonUtil.separator.toString()) > 0) {
						pFileName = pFileName.split("/")[pFileName.split("/").length - 1];
					}
					
					fileName = commonUtil.cleanValue(pFileName);
				}
				
				/* 2018-09-20 홍승비 - 이미지 등록 시 3자리 이상 확장자 잘리는 문제 수정 */
				String extension = fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length());
				
				// 동영상과 썸네일은 동일한 guid 사용(앞부분의 s_로 파일 구분)
				String guid = "{" + UUID.randomUUID().toString() + "}";
				uniqueName = guid + "." + extension;
				thumbnailName = "s_" + guid + "." + extension;
				
				writeUploadedFile(multiFile, uniqueName, serverPath);
				
				resultUpload = "true";
				
				strXML.append("<NODE><THUMBNAILNAME><![CDATA[" + thumbnailName + "]]></THUMBNAILNAME>");
				strXML.append("<RESULTUPLOADA><![CDATA[" + resultUpload + "]]></RESULTUPLOADA>");
				strXML.append("<PFILENAME><![CDATA[" + fileName + "]]></PFILENAME>");
				strXML.append("<FILESIZE>" + fileSize + "</FILESIZE>");
				strXML.append("<FILELOCATION><![CDATA[" + serverPath + thumbnailName + "]]></FILELOCATION>");
				strXML.append("<MODE><![CDATA[" + mode + "]]></MODE>");
				strXML.append("<UNIQUEID><![CDATA[" + uniqueName + "]]></UNIQUEID>");
				strXML.append("<OFILENAME><![CDATA[" + multiFile.getOriginalFilename() + "]]></OFILENAME>");
				strXML.append("</NODE>");
			}
			
			strXML.append("</NODES></ROOT>");
		}

		logger.debug("MovieUpload ended");
		return strXML.toString();
	}
	
	/**
	 * 동영상게시판 동영상과 썸네일 업로드
	 */
	@RequestMapping(value = "/ezBoard/boardMovieThumb.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String MovieThumbUpload(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("MovieThumbUpload started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String pFileLimit = request.getParameter("fileLimit");
		String thumbnailID = commonUtil.detectPathTraversal(request.getParameter("thumbnailID"));
		String realPath = commonUtil.getRealPath(request);
		String dirPath = "";
		String serverPath = "";
		String resultUpload = "";		
		String thumbFile = ""; // 썸네일을 저장한다. canvas로 저장한 문자열 형태 (toDateURL...)의 이미지 파일이 온다.
		String addThumbnail = request.getParameter("addThumbnail") != null ? request.getParameter("addThumbnail") : "";
		
		thumbFile = request.getParameter("thumbnail");
		dirPath = realPath + commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", userInfo.getTenantId());	
		serverPath = dirPath + commonUtil.separator;
		
		File file = new File(serverPath);
		
		if (!file.exists()) {
			file.mkdirs();
		}
		
		if (pFileLimit != null && (pFileLimit.equals("0") || pFileLimit.equals(""))) {
			pFileLimit = "2";
		}
		
		if (addThumbnail.equals("Y")) {
			String ext = thumbFile.substring(thumbFile.lastIndexOf(".") + 1);
			thumbnailID = thumbnailID.substring(0, thumbnailID.lastIndexOf(".") + 1) + ext;
			File orgFile = new File(serverPath + thumbFile);
			File movieFile = new File(serverPath + thumbnailID);
			if (movieFile.exists()) {
				movieFile.delete();
			}
			FileUtils.moveFile(orgFile, movieFile);
			
			File s_moveFile = new File(serverPath + "s_" + thumbnailID);
			if (s_moveFile.exists()) {
				s_moveFile.delete();
			}
			FileUtils.copyFile(movieFile, s_moveFile);
			
		} else {
			thumbnailID = thumbnailID.substring(0, thumbnailID.lastIndexOf(".") + 1) + "png";
			
			File movieFile = new File(serverPath + thumbnailID);
			BufferedImage bi = null;
			String[] base64Arr = thumbFile.split(",");
			byte[] imageByte = Base64.decodeBase64(base64Arr[1]);
			
			ByteArrayInputStream bis = new ByteArrayInputStream(imageByte);
			bi = ImageIO.read(bis);
			bis.close();

			ImageIO.write(bi, "png", movieFile);
			
			File s_moveFile = new File(serverPath + "s_" + thumbnailID);
			if (s_moveFile.exists()) {
				s_moveFile.delete();
			}
			FileUtils.copyFile(movieFile, s_moveFile);
		}
		
		resultUpload = "true";
		
		StringBuffer strXML = new StringBuffer();
		strXML.append("<ROOT><NODES>");
		strXML.append("<NODE><THUMBNAILNAME><![CDATA[" + thumbnailID + "]]></THUMBNAILNAME>");
		strXML.append("<RESULTUPLOADA><![CDATA[" + resultUpload + "]]></RESULTUPLOADA>");
		strXML.append("</NODE>");
		strXML.append("</NODES></ROOT>");

		logger.debug("MovieThumbUpload ended");
		return strXML.toString();
	}
	
	/**
	 * 동영상게시판 게시물 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardItemViewMovie.do", method = RequestMethod.GET)
	public String boardItemViewMovie(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("boardItemViewMovie started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String subDateFormat = "";
		String mode = "new";
		String adjacentItemsEnableFlag = ezCommonService.getTenantConfig("ADJACENT_ITEMS_ENABLE", userInfo.getTenantId());
		String showAdjacent = request.getParameter("showAdjacent");
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		String location = request.getParameter("location");
		String scrapContID = request.getParameter("scrapContID");
		String useOCS = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId());
		String publicModulus = egovFileScrty.getPbm();
		String publicExponent = "10001";
		
		BoardListVO boardItem = new BoardListVO();
		BoardVO boardAdjacent = null;
		
		mode = request.getParameter("mode");
		
		boolean isExistBoardItem = ezBoardService.confirmBoardItemDeletion(boardID, itemID, userInfo.getTenantId());
		
		if (!isExistBoardItem) {
			model.addAttribute("messageContent", egovMessageSource.getMessage("ezMain.delete.hth01", userInfo.getLocale()));
			return "/common/error";
		}

		String authorization = request.getHeader("Authorization");
		String password = StringUtils.isNotBlank(authorization) ? new String(java.util.Base64.getDecoder().decode(StringUtils.removeStart(authorization, "Basic "))) : "";
		
		if (!accessCheck(boardID, itemID, location, userInfo, password)) {
			return "main/warning";
		}
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		
		if (!boardInfo.getRead_FG().equals("true")) {
			return "main/warning";
		}
		
		if (mode == null || !mode.equals("temp")) {
			boardItem = ezBoardService.getBrdGetItemInfo(boardID, itemID, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
		} else {
			boardItem = ezBoardService.getBrdGetItemInfoTemp(boardID, itemID, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
		}
		
		ezBoardService.setAsRead(userInfo, boardID, itemID);
		
		if (boardItem == null || boardItem.getWriterID() == null || boardItem.getWriterID().equals("")) {
			return "main/error";
		}
		
		if (boardItem.getApprFlag() != null && boardItem.getApprFlag().equals("N")) {
			int checkCnt = ezBoardService.checkApprUserList(userInfo.getId(), itemID, userInfo.getTenantId());
			if (checkCnt == 0) {
				boardItem.setApprFlag("");
			}
		}
		
		BoardPropertyVO boardProperty = ezBoardService.getBoardProperty(boardID, userInfo.getTenantId());
		
		if (boardItem.getEndDate().substring(0, 4).equals("9999")) {
			boardItem.setEndDate(egovMessageSource.getMessage("ezBoard.t287", userInfo.getLocale()));
		}
		
		if (adjacentItemsEnableFlag != null && showAdjacent != null && adjacentItemsEnableFlag.equals("1") && showAdjacent.equals("1")) {
			if (boardItem.getUpperItemIDTree() == null || boardItem.getUpperItemIDTree().equals("")) {
				boardItem.setUpperItemIDTree(itemID);
			}
			
			if (boardInfo.getGuBun().equals("3")) {
				boardAdjacent = getAdjacentItems(itemID, boardID, boardItem.getUpperItemIDTree(), boardItem.getParentWriteDate(), userInfo.getTenantId());
			} else {
				boardAdjacent = getAdjacentItemsPhoto(itemID, boardID, boardItem.getUpperItemIDTree(), boardItem.getParentWriteDate(), userInfo.getTenantId());
			}
			
			if (boardAdjacent.getPreviousTitle().equals("")) {
				boardAdjacent.setPreviousTitle(egovMessageSource.getMessage("ezBoard.t330", userInfo.getLocale()));
			}
			
			if (boardAdjacent.getNextTitle().equals("")) {
				boardAdjacent.setNextTitle(egovMessageSource.getMessage("ezBoard.t331", userInfo.getLocale()));
			}
		}
		
		if (boardInfo.getBoardName() != null && !boardInfo.getBoardName().equals("")) {
			boardInfo.setBoardName(commonUtil.cleanValue(boardInfo.getBoardName()));
		}
		
		if (boardInfo.getBoardName1() != null && !boardInfo.getBoardName1().equals("")) {
			boardInfo.setBoardName1(commonUtil.cleanValue(boardInfo.getBoardName1()));
		}
		
		if (boardInfo.getBoardName2() != null && !boardInfo.getBoardName2().equals("")) {
			boardInfo.setBoardName2(commonUtil.cleanValue(boardInfo.getBoardName2()));
		}
		
		subDateFormat = commonUtil.getDateStringInUTC(boardItem.getWriteDate(), userInfo.getOffset(), false);
		boardItem.setWriteDate(subDateFormat.substring(0, subDateFormat.length()-3));
		boardItem.setEndDate(commonUtil.getDateStringInUTC(boardItem.getEndDate(), userInfo.getOffset(), false));

		boardItem.setParentWriteDate(commonUtil.getDateStringInUTC(boardItem.getParentWriteDate(), userInfo.getOffset(), false));
		
		if (!StringUtils.isBlank(boardItem.getUpdateDate())) {
			boardItem.setUpdateDate(commonUtil.getDateStringInUTC(boardItem.getUpdateDate(), userInfo.getOffset(), false));
		}
		// 2017.12.29 강민수92 댓글 갯수 구하기
		if (boardProperty.getOneLineReply() != null && !boardProperty.getOneLineReply().equals("") && !boardProperty.getOneLineReply().equals("0")) {
			String commentCount = ezBoardService.getOneLineReplyCount(boardID, itemID, userInfo.getTenantId());
			model.addAttribute("commentCount", commentCount);
		}
		
		/* 2019-04-05 홍승비 - 해당 게시물에 대해 사용자가 좋아요를 표시했는지 체크 */
		String isLikeChecked = ezBoardService.likeCheck(userInfo.getId(), itemID, userInfo.getTenantId());
		/* 2023-04-06 기민혁 - 해당 게시물에 대해 사용자가 싫어요를 표시했는지 체크 */
		String isDisLikeChecked = ezBoardService.disLikeCheck(userInfo.getId(), itemID, userInfo.getTenantId());

		List<BoardKeywordVO> keywordList = new ArrayList<>();
		if (boardInfo.getUseKeyword() != null && boardInfo.getUseKeyword().equals("Y")) {
			keywordList = ezBoardService.selectBoardKeywordByBoardItem(boardItem.getItemID(), boardItem.getBoardID(), userInfo.getTenantId());
		}
		
		List<BoardThumbnailVO> thumbnailInfo = ezBoardService.thumbnailViewDB(itemID, boardID, -1, 0, userInfo.getTenantId());

		/* 2023-05-03 기민혁 - 해당 게시물에 대해 사용자가 스크랩을 했는지 체크 */ 
		String isScrap = ezBoardService.getScrapItemCount(userInfo.getId(), itemID, boardID, userInfo.getCompanyID(), userInfo.getTenantId());
		
		Map<String, Object> itemStarRating = ezBoardService.getItemStarRating(itemID, userInfo.getId(), userInfo.getTenantId());
		
		/* 2018-06-20 홍승비 - 포토/썸네일 승인게시판 게시물 apprFlag 수정 */
		model.addAttribute("boardAdjacent", boardAdjacent);
		model.addAttribute("itemID", itemID);
		model.addAttribute("apprFlag", boardItem.getApprFlag());
		model.addAttribute("boardID", boardID);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("useOCS", useOCS);
		model.addAttribute("boardItem", boardItem);
		model.addAttribute("adjacentItemsEnableFlag", adjacentItemsEnableFlag);
		model.addAttribute("showAdjacent", showAdjacent);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("oneLineReplyFlag", boardProperty.getOneLineReply());
		model.addAttribute("publicModulus", publicModulus);
		model.addAttribute("publicExponent", publicExponent);
		model.addAttribute("isLikeChecked", isLikeChecked);
		model.addAttribute("isDisLikeChecked", isDisLikeChecked);
		model.addAttribute("keywordList", keywordList);
		model.addAttribute("isScrap", isScrap);
		model.addAttribute("MyBoardScrapFlag", ezCommonService.getTenantConfig("MyBoardScrapFlag", userInfo.getTenantId()));
		model.addAttribute("scrapContID", scrapContID);
		model.addAttribute("attachFileNameMaxLength", ezCommonService.getTenantConfig("attachFileNameMaxLength", userInfo.getTenantId()));
		model.addAttribute("addThumbnail", thumbnailInfo.get(0).getAddThumbnail());
		model.addAttribute("thumbnailExt", thumbnailInfo.get(0).getThumbnailExt());
		model.addAttribute("itemStarRating", itemStarRating);

		logger.debug("boardItemViewMovie ended");
		return "ezBoard/boardItemViewMovie";
	}
	
	/**
	 * 동영상게시판 동영상정보 가져오기
	 */
	@RequestMapping(value = "/ezBoard/getBoardMovieInfo.do", method = RequestMethod.GET)
	@ResponseBody
	public void getBoardMovieInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("getBoardMovieInfo started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String type = request.getParameter("type");
		String boardID = request.getParameter("boardID");
		String fileName = request.getParameter("fileName");
		String realPath = commonUtil.getRealPath(request);
		String pSignatureDir = commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId());
		String filePath = "";
		
		if (type.equals("BOARDTHUM")) {
			pSignatureDir = pSignatureDir + commonUtil.separator + boardID + commonUtil.separator + "uploadFile";
		} else { // BOARDMOVIETEMP
			pSignatureDir = commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", userInfo.getTenantId());
		}
		
		filePath = pSignatureDir + commonUtil.separator + fileName;
		
		if (filePath != null && !filePath.equals("")) {
			//logger.debug("filePath : " + filePath + "|| fileName : " + fileName);
			downFile(request, response, realPath + filePath, fileName);
		}

		logger.debug("getBoardMovieInfo ended");
	}
	
	/**
	 * 2023-09-14 홍승비 - 동영상게시판 > 동영상의 경로를 문자열로 리턴 (/fileroot/...)
	 */
	@RequestMapping(value = "/ezBoard/getBoardMoviePath.do", method = RequestMethod.GET, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String getBoardMoviePath(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("getBoardMoviePath started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String type = request.getParameter("type");
		String boardID = request.getParameter("boardID");
		String fileName = request.getParameter("fileName");
		String pSignatureDir = commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId());
		String filePath = "";
		
		if (type.equals("BOARDTHUM")) {
			pSignatureDir = pSignatureDir + commonUtil.separator + boardID + commonUtil.separator + "uploadFile";
		} else { // BOARDMOVIETEMP
			pSignatureDir = commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", userInfo.getTenantId());
		}
		
		filePath = pSignatureDir + commonUtil.separator + fileName;
		
		logger.debug("getBoardMoviePath ended, filePath = " + filePath);
		return filePath;
	}
	
	/**
	 * 동영상게시판 앨범수정
	 */
	@RequestMapping(value = "/ezBoard/movieAlbumEdit.do", method = RequestMethod.GET)
	public String movieAlbumEdit() {
		return "ezBoard/boardMovieAlbumEdit";
	}
	
	/**
	 * 동영상게시판 동영상수정
	 */
	@RequestMapping(value = "/ezBoard/modifyMovieItem.do", method = RequestMethod.GET)
	public String modifyMovieItem(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("modifyMovieItem started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String movieID = request.getParameter("movieID");
		int page = Integer.parseInt(request.getParameter("page"));
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		String guBun = request.getParameter("guBun");
		String addThumbnail = request.getParameter("addThumbnail");
		String thumbnailExt = request.getParameter("thumbnailExt");
		String movieUrl = "";
		String moviePath = "";
		int imageCnt = 10;
		int pStartRow = Math.addExact(Math.multiplyExact(Math.subtractExact(page, 1), imageCnt), 1);
		int pEndRow = Math.multiplyExact(page, imageCnt);
		
		List<BoardAttachVO> movieList = ezBoardService.photoViewDB(itemID, boardID, pStartRow, pEndRow, userInfo.getTenantId());
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		
		String filePath = movieList.get(0).getFilePath();
		int idx = filePath.lastIndexOf(commonUtil.separator);
		
		movieUrl = filePath.substring(0, idx + 1) + filePath.substring(idx + 1);
		moviePath = "/ezBoard/getBoardThumbnailInfo.do?type=BOARDTHUM&boardID=" + boardID + "&fileName=" + movieUrl.split("/")[7].replace("s_", "");
		
		model.addAttribute("movieID", movieID);
		model.addAttribute("moviePath", moviePath);
		model.addAttribute("boardID", boardID);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("itemID", itemID);
		model.addAttribute("guBun", guBun);
		model.addAttribute("addThumbnail", addThumbnail);
		model.addAttribute("thumbnailExt", thumbnailExt);
		model.addAttribute("movieUrl", movieUrl);
		
		logger.debug("modifyMovieItem ended");
		return "ezBoard/boardModifyMovieItem";
	}

	/** 동영상게시판 미리보기 호출 */
	@RequestMapping(value = "/ezBoard/boardItemPreViewMovieContent.do", method = RequestMethod.GET)
	public String boardItemPreViewMovieContent(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("boardItemPreViewMovieContent started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String showAdjacent = request.getParameter("showAdjacent");
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		String mode = request.getParameter("mode");
		String likeCount = request.getParameter("likeCount");
		String disLikeCount = request.getParameter("disLikeCount");
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		
		if (!boardInfo.getRead_FG().equals("true")) {
        	return "main/warning";
        }
		
		ezBoardService.setAsRead(userInfo, boardID, itemID);
		
		/* 2019-04-05 홍승비 - 해당 게시물에 대해 사용자가 좋아요를 표시했는지 체크 */
		String isLikeChecked = ezBoardService.likeCheck(userInfo.getId(), itemID, userInfo.getTenantId());
		/* 2023-04-06 기민혁 - 해당 게시물에 대해 사용자가 싫어요를 표시했는지 체크 */
		String isDisLikeChecked = ezBoardService.disLikeCheck(userInfo.getId(), itemID, userInfo.getTenantId());
		
		// 2025-01-23 게시판 > 게시물 미리보기 > 게시물 평가하기 기능 추가
		Map<String, Object> itemStarRating = ezBoardService.getItemStarRating(itemID, userInfo.getId(), userInfo.getTenantId());
		
		model.addAttribute("itemID", itemID);
		model.addAttribute("boardID", boardID);
		model.addAttribute("mode", mode);
		model.addAttribute("showAdjacent", showAdjacent);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("likeCount", likeCount);
		model.addAttribute("isLikeChecked", isLikeChecked);
		model.addAttribute("disLikeCount", disLikeCount);
		model.addAttribute("isDisLikeChecked", isDisLikeChecked);
		model.addAttribute("attachFileNameMaxLength", ezCommonService.getTenantConfig("attachFileNameMaxLength", userInfo.getTenantId()));
		model.addAttribute("itemStarRating", itemStarRating);
				
		logger.debug("boardItemPreViewMovieContent ended");
		
		return "ezBoard/boardItemPreViewMovieContent";
	}
	
	 /** 2019-01-15 홍승비 - 게시물의 수정일(updateDate)만을 업데이트
	 * */
	@RequestMapping(value = "/ezBoard/modUpdateDate.do", method = RequestMethod.POST)
	@ResponseBody
	public void modUpdateDate(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("modUpdateDate started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String itemID = request.getParameter("itemID");
		
		ezBoardService.modUpdateDate(commonUtil.getTodayUTCTime(""), itemID, userInfo.getId(), userInfo.getTenantId());
		
		logger.debug("modUpdateDate ended.");
	}
	
	/** 2019-04-05 홍승비 - 게시물의 좋아요 삽입 및 삭제 */
	@RequestMapping(value = "/ezBoard/clickLikeMod.do", method = RequestMethod.POST)
	@ResponseBody
	public String clickLikeInsert(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("clickLikeMod started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String itemID = request.getParameter("itemID");
		String mod = request.getParameter("mod");
		String isLikeChecked = "";
		
		if (mod.equalsIgnoreCase("INSERT")) {
			ezBoardService.likeInsert(userInfo.getId(), itemID, userInfo.getTenantId());
			isLikeChecked = "Y";
		} else {
			ezBoardService.likeDelete(userInfo.getId(), itemID, userInfo.getTenantId());
			isLikeChecked = "N";
		}
		
		logger.debug("clickLikeMod ended.");
		return isLikeChecked;
	}

	/** 2019-04-05 홍승비 - 게시물의 좋아요 갯수 가져오기 */
	@RequestMapping(value = "/ezBoard/getLikeCount.do", method = RequestMethod.GET)
	@ResponseBody
	public int getLikeCount(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getLikeCount started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String itemID = request.getParameter("itemID");
		int likeCount = 0;
		
		likeCount = ezBoardService.getLikeCount(itemID, userInfo.getTenantId());
		
		logger.debug("getLikeCount ended.");
		return likeCount;
	}
	
	/** 2019-04-19 홍승비 - 게시판의 게시물 갯수만을 리턴하는 함수 */
	@RequestMapping(value = "/ezBoard/getItemCount.do", method = RequestMethod.GET)
	@ResponseBody
	public int getItemCount(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getItemCount started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String boardID = request.getParameter("boardID");
		int intCount = 0;
		
		/* 2019-06-19 홍승비 - USE_BOARD_LEFTMENU_COUNT 플래그가 NO인 경우 게시물 갯수 갱신하지 않음 */
		if (ezCommonService.getTenantConfig("USE_BOARD_LEFTMENU_COUNT", userInfo.getTenantId()).equals("YES")) {
			BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
			BoardMyFavoriteVO myFavoriteVO = new BoardMyFavoriteVO();
			
			if(boardInfo != null && boardInfo.getGuBun() != null) { // 마이게시판 트리의 boardID 전달 시 NullPointer 에러 방지
				myFavoriteVO.setBoardId(boardID);
				myFavoriteVO.setUserId(userInfo.getId());
				myFavoriteVO.setType("1");
				myFavoriteVO.setTenantID(userInfo.getTenantId());
				myFavoriteVO.setNowDate(commonUtil.getTodayUTCTime(""));
				myFavoriteVO.setUseVersion(ezBoardService.getUseVersionFlag(boardID, userInfo.getTenantId()));
				
				if (boardInfo.getGuBun().equals("4")) {
					intCount = ezBoardService.getThumbNailCount(myFavoriteVO);
				} else if (boardInfo.getGuBun().equals("5")) {
					myFavoriteVO.setBoardAdmin_FG(boardInfo.getBoardAdmin_FG());
					intCount = ezBoardService.getQNABrdTotalItemCount(myFavoriteVO);
				} else {
					intCount = ezBoardService.getBrdTotalItemCount(myFavoriteVO);
				}
			}
		} else {
			intCount = 0;
		}
		
		logger.debug("getItemCount ended.");
		return intCount;
	}
	
	/** 2019-05-29 홍승비 - 어레이 리스트로 넘겨준 권한 BoardPropertyVO를 취합하는 메서드 */
	public BoardPropertyVO sumBoardACL(List<BoardPropertyVO> boardACLList, BoardPropertyVO boardInfo) {
		logger.debug("sumBoardACL started");
		
		List<BoardPropertyVO> resultACLList = boardACLList;
		BoardPropertyVO resultACL = boardInfo;

		resultACL.setBoardGroupAdmin_FG("NO");
		resultACL.setAccess_("0");
		resultACL.setBoardAdmin_FG("false");
		resultACL.setListView_FG("false");
		resultACL.setRead_FG("false");
		resultACL.setWrite_FG("false");
		resultACL.setReply_FG("false");
		resultACL.setDelete_FG("false");
		resultACL.setInherit_FG("false");
		resultACL.setPostNotice("false");
		resultACL.setBoardGroupACL("N");
		
		for (BoardPropertyVO aclList: resultACLList) {
			if (aclList.getBoardGroupAdmin_FG() != null && aclList.getBoardGroupAdmin_FG().equals("OK")) { // 게시판 그룹 관리자 권한
				resultACL.setBoardGroupAdmin_FG("OK");
			}
			if (aclList.getBoardAdmin_FG() != null && aclList.getBoardAdmin_FG().equals("true")) { // 게시판 관리자 권한
				resultACL.setBoardAdmin_FG("true");
			}
			if (aclList.getAccess_() != null && aclList.getAccess_().equals("1")) { // 접근
				resultACL.setAccess_("1");
			}
			if (aclList.getListView_FG() != null && aclList.getListView_FG().equals("true")) { // 리스트 보기
				resultACL.setListView_FG("true");
			}
			if (aclList.getRead_FG() != null && aclList.getRead_FG().equals("true")) { // 읽기
				resultACL.setRead_FG("true");
			}
			if (aclList.getWrite_FG() != null && aclList.getWrite_FG().equals("true")) { // 쓰기
				resultACL.setWrite_FG("true");
			}
			if (aclList.getReply_FG() != null && aclList.getReply_FG().equals("true")) { // 답변
				resultACL.setReply_FG("true");
			}
			if (aclList.getDelete_FG() != null && aclList.getDelete_FG().equals("true")) { // 자신의 게시물 삭제
				resultACL.setDelete_FG("true");
			}
			if (aclList.getInherit_FG() != null && aclList.getInherit_FG().equals("true")) { // inherit_FG(미사용)
				resultACL.setInherit_FG("true");
			}
			if (aclList.getPostNotice() != null && aclList.getPostNotice().equals("true")) { // 게시알림 플래그
				resultACL.setPostNotice("true");
			}
			if (aclList.getBoardGroupACL() != null && aclList.getBoardGroupACL().equals("Y")) { // 하위부서 허용여부
				resultACL.setBoardGroupACL("Y");
			}
		}
		
		logger.debug("sumBoardACL ended");
		return resultACL;
	}
	
	/** 2019-06-03 홍승비 - 사내겸직, 하위부서 허용여부 판단하여 게시판 그룹의 관리자권한 체크 */
	public String checkIfBoardGroupAdmin(String pBoardGroupID, LoginVO userInfo) throws Exception {
		logger.debug("checkIfBoardGroupAdmin started");
		
		String result = "NO";
		String deptPath = userInfo.getDeptPathCode();
		StringBuilder deptPathOrgan = new StringBuilder();
		List<String> addJobDeptList = new ArrayList<String>();
		
		/* 2019-09-18 홍승비 - 개인ID 이후, 부서ID 이전 위치에 직위+직책ID (사내겸직 직위 포함) 추가 */
		String userJJID = ezBoardService.getUserJJID(userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
		
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
		
		List<String> addJobList = ezBoardService.getPDOAddJobDeptID(userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
		StringJoiner addJobStr = new StringJoiner(",");
		addJobStr.add(userInfo.getDeptID());
		if (addJobList != null && addJobList.size() > 0) {
			for (int i = 0; i < addJobList.size(); i++) {
				addJobStr.add(addJobList.get(i));
				String upperDept = ezBoardService.getUpperDeptID(addJobList.get(i), userInfo.getTenantId());
				
				if (upperDept != null && !upperDept.equals("")) {
					boolean loopContinue = true;
					StringJoiner upperDeptStr = new StringJoiner(",");
					upperDeptStr.add(upperDept);
					
					while (loopContinue) {
						String upperDeptLoop = ezBoardService.getUpperDeptID(upperDept, userInfo.getTenantId());
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
		
		boolean isBoardGroup = false;
		BoardPropertyVO orgBoardProp = ezBoardService.getBoardProperty(pBoardGroupID, userInfo.getTenantId());
		if (orgBoardProp != null) {
			if (orgBoardProp.getBoardGroupID() != null && !orgBoardProp.getBoardGroupID().equals("")) { // 하위게시판
				isBoardGroup = false;
			} else { // 게시판그룹
				isBoardGroup = true;
			}
		}
		
		// 부서, 회사 / 직위, 직책 Set 추가
		Set<String> boardGroupAdminFGSetDept = new HashSet<String>();
		Set<String> boardGroupAdminFGSetJJ = new HashSet<String>();
		Set<String> userJJIDSet = new HashSet<String>(Arrays.asList(userJJID.split(",")));
		
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
					
					int isDept = ezBoardService.isDeptChk(addJobDeptList.get(jl).split(",")[i].trim(), userInfo.getTenantId());
					
					/* 2019-09-20 홍승비 - 권한그룹을 포함하여 게시판그룹 관리자권한 체크 */
					// 권한그룹 적용 시 개인권한이 다수 존재 가능하므로, 권한을 리스트로 가져온 뒤 '허용(OK)'기준으로 취합한다.
					List<String> boardGroupAdminNew_FG_List = ezBoardService.checkIfBoardGroupAdminNew(pBoardGroupID, addJobDeptList.get(jl).split(",")[i].trim(), userInfo.getTenantId(), isDept, isEqualDept, isBoardGroup);
					String boardGroupAdminNew_FG = "";
					// 전달한 ACCESSID에 대한 게시판 관리자권한 리스트 (OK, NO)
					if (boardGroupAdminNew_FG_List != null && boardGroupAdminNew_FG_List.size() > 0) { // 권한이 없으면 공백값을 유지 > 다음 루프 진행
						if (boardGroupAdminNew_FG_List.contains("OK")) { // 동일한 우선순위의 권한에 대해서, OK가 하나라도 존재한다면 OK로 판정
							boardGroupAdminNew_FG = "OK";
						} else {
							boardGroupAdminNew_FG = "NO";
						}
					}
					
					if (!boardGroupAdminNew_FG.equals("")) {
						if (addJobDeptList.get(jl).split(",")[i].trim().equals(userInfo.getId())) { // 개인의 권한
							result = boardGroupAdminNew_FG; // 그룹권한에 포함된 개인권한을 상단에서 취합했으므로, 그대로 사용 가능
							isUserHasACL = true;
							break;
						}
						else if (userJJIDSet.contains(addJobDeptList.get(jl).split(",")[i].trim())) { // 직위, 직책 권한
							boardGroupAdminFGSetJJ.add(boardGroupAdminNew_FG);
							isUserHasACL = false;
							// 직위, 직책권한은 레코드 전부 찾을때까지 break 안함
						}
						else { // 부서, 회사의 권한
							boardGroupAdminFGSetDept.add(boardGroupAdminNew_FG);
							isUserHasACL = false;
							break;
						}
					}
				}
			}
		}
		
		// 개인권한이 있다면 개인권한을  result로 사용 / 개인권한이 없다면 직위, 직책권한 -> 부서권한 순으로 체크
		if (isUserHasACL == false) {
			if (boardGroupAdminFGSetJJ.size() > 0 && boardGroupAdminFGSetJJ.contains("OK")) { // 직위, 직책권한이 존재하고 OK를 가지는 경우
				result = "OK";
			} else if (boardGroupAdminFGSetJJ.size() == 0 && boardGroupAdminFGSetDept.contains("OK")) { // 직위, 직책권한이 없고 부서권한이 OK를 가지는 경우
				result = "OK";
			} // 이외의 경우는 직위, 직책권한이 존재하고 NO만 가지는 경우 || 직위, 직잭권한이 없고 부서권한이 NO만 가지는 경우 => 즉 result는 NO로 유지되어 리턴
		}
		
		//logger.debug("result in checkIfBoardGroupAdmin   ::   " + result);
		logger.debug("checkIfBoardGroupAdmin ended");
		return result;
	}
	
	/**
	 * 2019-07-02 홍승비 - 게시판의 승인 사용 여부를 리턴 (Y/N)
	 * */
	@RequestMapping(value = "/ezBoard/getBoardApprProperty.do", method = RequestMethod.GET)
	@ResponseBody
	public String getBoardApprProperty(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getBoardApprProperty started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String pBoardID = request.getParameter("boardID");
		String useAppr = "N";
		
		BoardPropertyVO boardProp = ezBoardService.getBoardProperty(pBoardID, userInfo.getTenantId());
		if (boardProp != null && boardProp.getApprFlag() != null) {
			useAppr = boardProp.getApprFlag();
		}
		
		logger.debug("getBoardApprProperty ended, getApprFlag result = " + useAppr);
		return useAppr;
	}
	
	/**
	 * 2020-06-15 홍승비 - 즐겨찾기 게시판 여부 리턴(YES/NO)
	 * */
	@RequestMapping(value = "/ezBoard/getIsMyBoard.do", method = RequestMethod.GET)
	@ResponseBody
	public String getIsMyBoard(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getIsMyBoard started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String pBoardID = request.getParameter("boardID");
		String result = "NO";
		
		// 현재 자신의 회사에서 즐겨찾기한 게시판 + 그룹사 게시판의 즐겨찾기 여부를 체크
		int isMyBoardExist = ezBoardService.getIsMyBoardExist(pBoardID, userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
		if (isMyBoardExist > 0) {
			result = "YES";
		}
		
		logger.debug("getIsMyBoard ended.");
		return result;
	}
	
	/**
	 * 2020-06-15 홍승비 - 즐겨찾기 게시판 단일 삭제 메서드 (ajax용)
	 * */
	@RequestMapping(value = "/ezBoard/deleteMyBoards.do", method = RequestMethod.POST)
	@ResponseBody
	public void deleteMyBoards(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("deleteMyBoards started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String pBoardID = request.getParameter("boardID");
		
		ezBoardService.deleteMyBoards(pBoardID, userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
		
		logger.debug("deleteMyBoards ended.");
	}
	
	/**
	 * 2019-09-16 홍승비 - 기본 게시판으로 이동하기 위한 리다이렉트용 게시판 그룹ID와 게시판ID 리턴
	 * */
	@RequestMapping(value = "/ezBoard/getDefaultBoardID.do", method = RequestMethod.GET)
	@ResponseBody
	public String getDefaultBoardID(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getDefaultBoardID started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String returnStr = "";
		
		/* 2019-10-11 홍승비 - 테넌트 컨피그가 아니라 회사별로 지정한 공지사항 게시판으로 이동하도록 수정 */
		String defaultBoardID = ezBoardService.getCompanyNoticeBoardID(userInfo.getCompanyID(), userInfo.getTenantId());
		
		BoardPropertyVO boardProp = ezBoardService.getBoardProperty(defaultBoardID, userInfo.getTenantId());
		
		if (boardProp != null && boardProp.getBoardGroupID() != null && defaultBoardID != null && !defaultBoardID.trim().equals("")) {
			returnStr = boardProp.getBoardGroupID() + ";" + defaultBoardID;
		}
		
		logger.debug("getDefaultBoardID ended.");
		return returnStr;
	}
	
	/**
	 * 2020-07-14 홍승비 - 선택한 마이게시판 분류 하위에 해당 게시판이 존재하는지 리턴 (Y/N)
	 * */
	@RequestMapping(value = "/ezBoard/checkMyBoardExist.do", method = RequestMethod.GET)
	@ResponseBody
	public String checkMyBoardExist(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("checkMyBoardExist started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String pTreeID = request.getParameter("treeID");
		String pBoardID = request.getParameter("boardID");
		String result = "";
		
		result = ezBoardService.isMyBoardExist(pTreeID, pBoardID, userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
		
		logger.debug("checkMyBoardExist ended.");
		return result;
	}
	
	/**
	 * 2021-06-21 홍승비 - 게시판 메일알림 메일 발송 컨트롤러 (게시알림, 수정알림, 댓글알림)
	 * */
	@RequestMapping(value = "/ezBoard/sendBoardAlert.do", method = RequestMethod.POST)
	@ResponseBody
	public void sendBoardAlert(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("sendBoardAlert started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		String pIsAllGroupBoard = request.getParameter("isAllGroupBoard");
		String pMode = request.getParameter("mode");
		// 2023-08-03 조수빈 - 개인이 게시판 알람을 설정한 항목인지에 대한 여부
		boolean disableMail = false;
		
		// 게시판 옵션에서 메일알림을 사용하는 경우에만 발송한다.
		BoardPropertyVO boardProperty = ezBoardService.getBoardProperty(boardID, userInfo.getTenantId());

		if (boardProperty.getGuBun().equals("2")) {
			logger.debug("Sending Noti doesn't support on Anonymous Board");
			logger.debug("sendBoardAlert ended.");
			return;
		}
		
		String boardName = ezBoardService.getBoardNameLocalizing(userInfo.getLang(), boardProperty);

		List<HashMap<String, String>> possibleUserInfo = new ArrayList<HashMap<String, String>>();
		HashMap<String, String> recipientIDs = new HashMap<String, String>();
		String companyID = pIsAllGroupBoard.equals("Y") ? "" : boardProperty.getCompanyID(); // 회사ID의 경우, 그룹사게시판이 아닌 경우에만 게시판이 속한 회사ID로 세팅한다.
		
		List<String> notiRecipientIds = new ArrayList<String>();
		List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();
		
		if ((pMode.equals("new") && boardProperty.getMailFG_Post() != null && boardProperty.getMailFG_Post().equals("Y")) || (pMode.equals("modify") && boardProperty.getMailFG_Mod() != null && boardProperty.getMailFG_Mod().equals("Y"))) {
			// 표준모듈(포탈, 게시판)에 회사 전환 기능이 없으므로, 사간겸직에 대해서는 권한을 체크하지 않는다. (회사 변경기능이 있다면 해당 회사에 대응하도록 수정 필요)
			// 2024-03-28 한태훈 > 게시판 일반 사용자 즐겨찾기 게시판 새게시물 등록 시 통합알림 추가
			List<OrganUserVO> favoriteBoardUserList = ezBoardService.getFavoriteBoardUserList(boardID, userInfo.getCompanyID(), userInfo.getTenantId());

			for (int i = 0; i < favoriteBoardUserList.size(); i++) {
				String writerID = favoriteBoardUserList.get(i).getCn();
				String value = favoriteBoardUserList.get(i).getDisplayName() + ";;" + favoriteBoardUserList.get(i).getMail();
				int tenantId = favoriteBoardUserList.get(i).getTenantId();
				disableMail = ezPersonalService.hasNotiDiableItem(writerID, pMode.equals("new") ? NotiType.BOARD_NEW : NotiType.BOARD_MODIFY, NotiPlatform.MAIL, tenantId);
				if (!disableMail) {
			        recipientIDs.put(writerID, value);
				}

				if (!notiRecipientIds.contains(writerID)) {
					notiRecipientIds.add(writerID);
					Map<String, Object> recipientMap = new HashMap<String, Object>();
					recipientMap.put("userType", "PERSON");
					recipientMap.put("companyId", userInfo.getCompanyID());
					recipientMap.put("cn", writerID);
					notiRecipientList.add(recipientMap);
				}
			}
		}
		// 게시물 댓글 알림에 대한 수신인 ID 리턴
		else if (pMode.equals("comment") && boardProperty.getMailFG_Comment() != null && boardProperty.getMailFG_Comment().equals("Y")) {
			possibleUserInfo = ezBoardService.getCommentNoticeMail(boardID, itemID, userInfo.getLang(), userInfo.getTenantId());
			for (int i = 0; i < possibleUserInfo.size(); i++) {
				String writerID = possibleUserInfo.get(i).get("WRITERID");
				String writerName = possibleUserInfo.get(i).get("WRITERNAME");
				String mail = possibleUserInfo.get(i).get("MAIL");
				int tenantId = Integer.parseInt(possibleUserInfo.get(i).get("TENANT_ID"));
				String value = writerName + ";;" + mail;
				disableMail = ezPersonalService.hasNotiDiableItem(writerID, NotiType.BOARD_COMMENT, NotiPlatform.MAIL, tenantId);
				
				if (!disableMail) {
					recipientIDs.put(writerID, value);
				}
				
				if (!notiRecipientIds.contains(writerID)) {
					notiRecipientIds.add(writerID);
					Map<String, Object> recipientMap = new HashMap<String, Object>();
					recipientMap.put("userType", "PERSON");
					recipientMap.put("companyId", userInfo.getCompanyID());
					recipientMap.put("cn", writerID);
					notiRecipientList.add(recipientMap);
				}
			}
		}
		// 알림발송 하지 않는 경우, 바로 리턴
		else {
			logger.debug("sendBoardAlert ended. (Sending alert is not used for mode [" + pMode + "])");
			return;
		}
		
		BoardListVO boardItem = ezBoardService.getBrdGetItemInfo(boardID, itemID, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
		
		// 게시물 링크, 게시일 정보 등 생성
		String strURL = "Item_View_New('" + boardID + "','" + itemID + "','" + boardProperty.getGuBun() + "');";
        strURL = "<span id='board_a' style=\"color:blue;cursor:pointer;text-decoration:underline;\" onClick=\"" + strURL + "\">";
        String strDate = commonUtil.getDateStringInUTC(boardItem.getWriteDate(), userInfo.getOffset(), false);
        strDate += "( " + userInfo.getOffset().split("\\|")[1] + " )";

		// 메일 본문 생성
		StringBuilder bodyContent = new StringBuilder();
		String content = "";
		String subject = "";


		if (pMode.equals("new")) { // 게시판 게시알림 (아래 게시판에 새 게시글이 게시되었습니다.)
			bodyContent.append("<br>" + egovMessageSource.getMessage("ezBoard.t250", userInfo.getLocale()) + "<br><br>");
	        bodyContent.append("<br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t251", userInfo.getLocale()) + commonUtil.cleanValue(boardName));
	        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t252", userInfo.getLocale()) + strDate);
	        
	        /* 2024-02-02 홍승비 - 승인게시판의 경우, 승인자가 아닌 게시물 작성자의 정보가 메일에 표출되도록 수정 (익명게시판은 승인여부 사용불가, getBrdGetItemInfo로 가져온 데이터는 작성자/작성자 부서명/작성자 회사명 전부 다국어 대응됨) */
	        if (boardProperty.getApprFlag() != null && boardProperty.getApprFlag().equalsIgnoreCase("Y")) { // 승인게시판
	        	bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t253", userInfo.getLocale()) + boardItem.getWriterName() + "(" + (boardItem.getExtensionAttribute3() == null || "null".equals(boardItem.getExtensionAttribute3()) ? "" : boardItem.getExtensionAttribute3()+ ", ") + boardItem.getWriterDeptName() + ", " + boardItem.getWriterCompanyName() + ")");
	        } else {
	        	bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t253", userInfo.getLocale()) + userInfo.getDisplayName() + "(" + (userInfo.getTitle() == null || "null".equals(userInfo.getTitle()) ? "" : userInfo.getTitle()+ ", ") + userInfo.getDeptName() + ", " + userInfo.getCompanyName() + ")");
	        }
	        
	        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t254", userInfo.getLocale()) + strURL + commonUtil.cleanValue(boardItem.getTitle()) + "</a>");

	        content = commonUtil.createNotiMailContent(bodyContent.toString(), userInfo.getTenantId(), userInfo.getLocale());
	        subject = "[" + egovMessageSource.getMessage("ezBoard.t255", userInfo.getLocale()) + boardName + "] " + boardItem.getTitle();

		} else if (pMode.equals("modify")) { // 게시판 수정알림 (아래 게시판의 게시물이 수정되었습니다.)
			bodyContent.append("<br>" + egovMessageSource.getMessage("ezBoard.HSBMail05", userInfo.getLocale()) + "<br><br>");
	        bodyContent.append("<br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t251", userInfo.getLocale()) + commonUtil.cleanValue(boardName));
	        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t252", userInfo.getLocale()) + strDate);
	        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t253", userInfo.getLocale()) + userInfo.getDisplayName() + "(" + (userInfo.getTitle() == null || "null".equals(userInfo.getTitle()) ? "" : userInfo.getTitle()) + ", " + userInfo.getDeptName() + ", " + userInfo.getCompanyName() + ")");
	        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t254", userInfo.getLocale()) + strURL + commonUtil.cleanValue(boardItem.getTitle()) + "</a>");


	        content = commonUtil.createNotiMailContent(bodyContent.toString(), userInfo.getTenantId(), userInfo.getLocale());
	        subject = "[" + egovMessageSource.getMessage("ezBoard.HSBMail07", userInfo.getLocale()) + boardName + "] " + boardItem.getTitle();

		} else if (pMode.equals("comment")) { // 게시판 댓글알림 (아래 게시판의 게시물에 댓글이 등록되었습니다.)
			bodyContent.append("<br>" + egovMessageSource.getMessage("ezBoard.HSBMail06", userInfo.getLocale()) + "<br><br>");
	        bodyContent.append("<br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t251", userInfo.getLocale()) + commonUtil.cleanValue(boardName));
	        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t252", userInfo.getLocale()) + strDate);
	        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t253", userInfo.getLocale()) + userInfo.getDisplayName() + "(" + (userInfo.getTitle() == null || "null".equals(userInfo.getTitle()) ? "" : userInfo.getTitle()) + ", " + userInfo.getDeptName() + ", " + userInfo.getCompanyName() + ")");
	        bodyContent.append("<br><br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezBoard.t254", userInfo.getLocale()) + strURL + commonUtil.cleanValue(boardItem.getTitle()) + "</a>");

	        content = commonUtil.createNotiMailContent(bodyContent.toString(), userInfo.getTenantId(), userInfo.getLocale());
	        subject = "[" + egovMessageSource.getMessage("ezBoard.HSBMail08", userInfo.getLocale()) + boardName + "] " + boardItem.getTitle();
		}

		logger.debug("Sending mail starts.");
		// 수신인 ID에 대해 개별 메일발송 실행
		Iterator<String> keys = recipientIDs.keySet().iterator();
		String key = "";
		while (keys.hasNext()) {
			try {
				key = keys.next(); // userID
				String value = recipientIDs.get(key); // userName;;mail
				String userName = value.split(";;")[0];
				String mail = value.split(";;")[1];

				InternetAddress from = new InternetAddress();
	        	from.setPersonal(userInfo.getDisplayName(), "UTF-8");
	        	from.setAddress(userInfo.getEmail());

				InternetAddress to = new InternetAddress();
	        	to.setPersonal(userName, "UTF-8");
	        	to.setAddress(mail);

	        	ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject, content, false);
			} catch (Exception e) {
				logger.debug(e.getMessage());
				logger.debug("Sending mail is falied : " + key);
				continue;
			}
		}

		logger.debug("Sending mail ends.");
		
		String notiContent = boardName + " - " + boardItem.getTitle();
		String boardType = boardProperty.getGuBun();
		String linkUrl = "";
		String linkUrlMobile = "";
		String boardStatus = "";

		if (boardType != null && (boardType.equals("4") || boardType.equals("3"))) {
			boardStatus = "photoBoardItem";
		}

		if (boardID.equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")) {
			boardStatus = "newBoardItemList";
		} else {
			boardStatus = "boardItemList";
		}

		String tempItemID = encodeURIComponent(itemID);
		String tempBoardID = encodeURIComponent(boardID);
		boardStatus = encodeURIComponent(boardStatus);

		switch (boardType) {
		case "3":
		case "4":
			linkUrl += "/ezBoard/boardItemViewPhoto.do?itemID=" + (tempItemID) + "&boardID=" + (tempBoardID);
			linkUrlMobile += "/mobile/ezBoard/photoBoardItem.do?boardID=" + (tempBoardID) + "&itemID=" + (tempItemID) + "&type=photoBoardItem&boardItemListType=" + (boardStatus);
			break;
		case "7":
			linkUrl += "/ezBoard/boardItemViewMovie.do?itemID=" + (tempItemID) + "&boardID=" + (tempBoardID);
			linkUrlMobile += "/mobile/ezBoard/movieBoardItem.do?boardID=" + (tempBoardID) + "&itemID=" + (tempItemID) + "&type=movieBoardItem&boardItemListType=" + (boardStatus);
			break;
		default:
			linkUrl += "/ezBoard/boardItemView.do?itemID=" + (tempItemID) + "&boardID=" + (tempBoardID);
			linkUrlMobile += "/mobile/ezBoard/boardItem.do?boardID=" + (tempBoardID) + "&itemID=" + (tempItemID) + "&type=boardItem&boardItemListType=" + (boardStatus);
			break;
		}
		// 2024-03-28 한태훈 > 게시판 일반 사용자 통합 알림 추가
		if (notiRecipientIds != null && notiRecipientIds.size() > 0) {
			String notiStatus = ezNotificationService.sendNoti(request, userInfo.getId(), userInfo.getDisplayName(), notiRecipientList, "board", pMode, notiContent, "popup", "780", "800", linkUrl, linkUrlMobile, "");
			logger.debug("board " +  pMode + " noti status : " + notiStatus);
		}
		logger.debug("sendBoardAlert ended.");
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
					
					if ((commonUtil.isAdmin(userID, tenantID, rollInfo, "c") || boardGroupAdmin_FG_New.equals("OK") ||
							(isAllGroupBoard.equals("N") && commonUtil.isAdmin(userID, tenantID, rollInfo, "c;n;k")))) {
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
	 * 2022-01-04 홍승비 - 홈페이지 게시판 게시물 호출 Method
	 */
	@RequestMapping(value = "/ezBoard/boardItemViewHomePage.do", method = RequestMethod.GET)
	public String boardItemViewHomePage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo, Model model) throws Exception {
		logger.debug("boardItemViewHomePage started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String publicModulus = egovFileScrty.getPbm();
		String publicExponent = "10001";
		String boardID = request.getParameter("boardID");
		String itemID = "";
		String contentLocation = "";
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		
		// 리스트뷰 보기, 읽기권한이 모두 true여야 접근 가능 (사실상 게시물 접근이므로)
		if (!boardInfo.getListView_FG().equals("true") || !boardInfo.getRead_FG().equals("true")) {
			return "main/warning";
		}
		
		String guBun = boardInfo.getGuBun();
		
		// 공지사항을 무시하고 가장 최신 게시물 하나의 정보를 가져온다. 기본적으로 관리자단 리스트 표출 순서와 동일함
		List<HashMap<String, Object>> boardListItem = ezBoardService.getBoardListItem(boardID, userInfo.getId(), 1, 1, 1, "", "", new HashMap<String, String>(), "1", userInfo.getTenantId(), "");
		
		if (boardListItem.size() > 0) {
			itemID = (String) boardListItem.get(0).get("ITEMID");
			BoardListVO boardItem = ezBoardService.getBrdGetItemInfo(boardID, itemID, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
			
			if (boardItem == null) {
				return "main/warning";
			}
			
			contentLocation = boardItem.getContentLocation();
			
			ezBoardService.setAsRead(userInfo, boardID, itemID);
		} else {
			model.addAttribute("noItem", "Y");
			return "main/warning_board"; // 등록된 게시물이 없는 경우
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("contentLocation", contentLocation);
		model.addAttribute("boardID", boardID);
		model.addAttribute("itemID", itemID);
		model.addAttribute("guBun", guBun);
		model.addAttribute("publicModulus", publicModulus);
		model.addAttribute("publicExponent", publicExponent);
		
		logger.debug("boardItemViewHomePage ended");
	    return "ezBoard/boardItemViewHomePage";
	}

	// 2023-05-22 조수빈 - 게시판 첨부파일 미리보기
	// 게시판 첨부파일 미리보기 아이콘 생성 시 useBoardFilePrvw 테넌트 컨피크를 체크하므로, 해당 테넌트 컨피그의 값이 1(사용)인 경우에만 컨트롤러 접근 가능
	@RequestMapping(value = "/ezBoard/attachItemPreview.do", method = RequestMethod.GET)
	public void attachItemPreview(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response
								, @RequestParam String pFilePath, @RequestParam String fileName) throws Exception {
		
		logger.debug("attachItemPreview started.");
		logger.debug("fileName : " + fileName + " / pFilePath : " + pFilePath);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		try (OutputStream output = response.getOutputStream()) {
			// 기존 파일 객체 생성
			pFilePath = URLDecoder.decode(pFilePath, "UTF-8");
			fileName = URLDecoder.decode(fileName, "UTF-8");

			logger.debug("filePath : {}",pFilePath);
			
			String realPath = commonUtil.getRealPath(request);
			File srcFile = new File(commonUtil.detectPathTraversal(realPath + pFilePath));
			
			if (!srcFile.exists() || !srcFile.isFile()) {
			    throw new FileNotFoundException(fileName);
			}
			
			String destFilePath = realPath + commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId()) + commonUtil.separator + "tempUploadFile";
			MessageDigest md2 = MessageDigest.getInstance("SHA-256");
			md2.update(fileName.substring(0, fileName.lastIndexOf(".")).getBytes());
			byte mdDate2[] = md2.digest();
			StringBuffer sb2 = new StringBuffer();
			
			for (int i = 0; i < mdDate2.length; i++) {
				sb2.append(Integer.toHexString((int) mdDate2[i] & 0x00ff));
			}
			
			String md5FileName = sb2.toString() + fileName.substring(fileName.lastIndexOf("."));
			File destFile = new File(destFilePath + commonUtil.separator + md5FileName);
			File newFolder = new File(destFilePath);
			
			if (!newFolder.exists()) {
				newFolder.mkdirs();
			}
			
			FileUtils.copyFile(srcFile, destFile);
			
			String SATimageConvertServerURL = ezCommonService.getTenantConfig("SATimageConvertServerURL", userInfo.getTenantId());
			String fileExt = fileName.split("\\.")[fileName.split("\\.").length - 1];
			destFilePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId())
							+ commonUtil.separator + "tempUploadFile" + commonUtil.separator + md5FileName;
			output.write((SATimageConvertServerURL 
					+ "?filepath=" + URLEncoder.encode(destFilePath, "UTF-8").replace("+", "%20") +
					"&filename=" + URLEncoder.encode(fileName, "UTF-8").replace("+", "%20") +
					"&fileext=" + fileExt.replace("+", "%20") +
					"&viewerselect=image" +
					"&userid=" + userInfo.getId()).getBytes());
			
		} catch (Exception e){
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("attachItemPreview ended.");
	}

	/**
	 * 2023-03-07 이가은 - 댓글 반응 제어 메서드 (삽입, 삭제, 댓글 좋아요/싫어요 선택 조건 체크 등을 분기처리하여 진행)
	 */
	@ResponseBody
	@RequestMapping(value = "/ezBoard/reactAndModeCheck.do", method = RequestMethod.POST)
	public int reactAndModeCheck(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception {
		logger.debug("reactAndModeCheck started.");

		userInfo = commonUtil.userInfo(loginCookie);
		String itemId = request.getParameter("itemID");
		String replyId = request.getParameter("replyID");
		String replyWriter = request.getParameter("replyWriter");
		String reactFlag = request.getParameter("reactFlag");
		String userId = userInfo.getId();
		int tenantId = userInfo.getTenantId();
		String companyId = userInfo.getCompanyID();
		String reactDate = commonUtil.getTodayUTCTime("");

		int isReplyFlag = ezBoardService.checkReplyID(itemId, replyId, tenantId);
		String react = ezBoardService.checkReactUser(itemId, replyId, userId, tenantId);

		logger.debug("reactAndModeCheck ended.");

		if (isReplyFlag == 0) {
			return 1;	// 댓글이 존재하지 않는 경우
		} else if (replyWriter.equals(userId)) {
			return 2;	// 댓글 작성자인 경우
		} else if (react == null || react.equals("")) {
			ezBoardService.inserBoardReact(itemId, replyId, userId, reactFlag, tenantId, companyId, reactDate);
			return 3;	// '좋아요' 또는 '싫어요' 추가되는 경우
		} else if (reactFlag.equals(react)) {
			ezBoardService.deleteBoardReact(itemId, replyId, userId, tenantId);
			return 4;	// 같은 반응을 눌렀을 경우
		} else {
			ezBoardService.deleteBoardReact(itemId, replyId, userId, tenantId);
			ezBoardService.inserBoardReact(itemId, replyId, userId, reactFlag, tenantId, companyId, reactDate);
			return 5;	// 다른 반응을 눌렀을 경우
		}
	}

	/**
	 * 2023-03-07 이가은 - 댓글 삭제되었을 경우 모든 반응 삭제하는 메서드
	 */
	@ResponseBody
	@RequestMapping(value = "/ezBoard/allReactDelete.do", method = RequestMethod.POST)
	public void allReactDelete(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception {
		logger.debug("allReactDelete started.");

		userInfo = commonUtil.userInfo(loginCookie);
		String itemID = request.getParameter("itemID");
		String delReplyID = request.getParameter("delReplyID");
		int tenantID = userInfo.getTenantId();

		ezBoardService.allReactDelete(itemID, delReplyID, tenantID);

		logger.debug("allReactDelete ended.");
	}

	/**
	 * 2023-03-08 이가은 -  게시물에 대한 사용자의 댓글 반응 HashMap List로 리턴하는 메서드
	 */
	@ResponseBody
	@RequestMapping(value = "/ezBoard/getUserReplyReact.do", method = RequestMethod.GET)
	public List<HashMap<String, String>> getUserReplyReact(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception {
		logger.debug("getUserReplyReact started.");

		userInfo = commonUtil.userInfo(loginCookie);
		String itemID = request.getParameter("pItemID");
		String userID = userInfo.getId();
		int tenantID = userInfo.getTenantId();

		List<HashMap<String, String>> getUserReplyReactList = ezBoardService.getUserReplyReact(itemID, userID, tenantID);

		logger.debug("getUserReplyReact ended.");
		return getUserReplyReactList;
	}

	// 2024-05-29 전인하 - 게시판 > 게시물 리스트 > 만료된 게시물 리스트 표출 가능여부 메소드
	public String checkEndDateConfig(BoardPropertyVO boardInfo, LoginVO userInfo) throws Exception {
		String endDateOptionConfig = ezCommonService.getTenantConfig("endDateOptionConfig", userInfo.getTenantId());
		String endDateOption = "NO";
		if (endDateOptionConfig != null) {
			if (endDateOptionConfig.equals("ALWAYS") || (endDateOptionConfig.equals("ADMIN") && boardInfo.getBoardAdmin_FG().equals("true"))) {
				endDateOption = "YES";
			} else {
				endDateOption = "NO";
			}
		}
		return endDateOption;
	}

	@GetMapping("/ezBoard/boardView.do")
	public String openBoardView(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie) throws Exception {
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		// 현재 기존 소스에서 모두 비어있는 값임. 추후 수정 가능성 있음.
		String showAdjacent = Optional.ofNullable(request.getParameter("showAdjacent")).orElse("");

		BoardPropertyVO vo = ezBoardService.getBoardProperty(boardID, commonUtil.userInfo(loginCookie).getTenantId());
		UriComponentsBuilder builder = UriComponentsBuilder.newInstance();

		switch(vo.getGuBun()) {
			case "3":
			case "4":
				builder.uri(URI.create("/ezBoard/boardItemViewPhoto.do"));
				break;
			case "7":
				builder.uri(URI.create("/ezBoard/boardItemViewMovie.do"));
				break;
			default:
				builder.uri(URI.create("/ezBoard/boardItemView.do"));
				break;
		}
		builder.queryParam("boardID", boardID);
		builder.queryParam("itemID", itemID);
		builder.queryParam("showAdjacent", showAdjacent);

		return "redirect:" + builder.build().encode().toUriString();
	}

	// 2023-12-07 한태훈 - java에서 encodeURIComponent 메소드 구현
	private String encodeURIComponent(String s) throws Exception {
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
	@GetMapping("/ezBoard/fileViewerBoard.do")
	public String fileViewerBoard(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.info("fileViewerBoard started");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);

		String boardID = request.getParameter("boardID");
		String mode = request.getParameter("mode") == null ? "new" : request.getParameter("mode");
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		String today = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
		String uploadFilePath = commonUtil.getUploadPath("upload_board.ROOT", userInfo.getTenantId());

		BoardItemVO boardItemInfo = ezBoardService.getFileViewerBoardInfo(request, userInfo, boardInfo.getVersionManage());

		if ("modify".equals(mode)) {
			// 게시물과 게시판의 boardID 정보가 서로 맞지 않는 경우 오류 페이지 리턴
			if (boardItemInfo.getBoardID() == null || boardID == null || !boardItemInfo.getBoardID().equals(boardID)) {
				return "main/warning";
			}
			// 해당 게시판에 관리자 권한이 없으면서 다른 사용자의 게시물을 수정하려는 경우 오류 페이지 리턴
			else if ((boardInfo.getBoardAdmin_FG() == null || (boardInfo.getBoardAdmin_FG() != null && boardInfo.getBoardAdmin_FG().equals("false"))) &&
					!boardItemInfo.getWriterID().equals(userInfo.getId())) {
				return "main/warning";
			}
		}

		String expireDays = boardInfo.getExpireDays() != null ? boardInfo.getExpireDays() : "-1";
		String endDateTime = "-1".equals(expireDays) ? "9999-12-31" : EgovDateUtil.addDay(today, Integer.parseInt(expireDays), "yyyy-MM-dd");
		
		/* 
		* 2025-06-19 master 반영시점에 자동저장 기능이 없어서 주석처리 
		* 추후 자동저장 master 반영되면 아래 주석 해제 및 fileViewerBoard.jsp 에 자동저장 관련 로직 추가해야 함.
		String useAutoSaveFlag = ezCommonService.getTenantConfig("useAutoSaveBoardItem", userInfo.getTenantId());
		if ("Y".equals(useAutoSaveFlag)) {
			BoardConfigVO boardConfig = ezBoardService.getBoardList_Config(userInfo.getId(), userInfo.getTenantId());
			model.addAttribute("autoSaveTime", boardConfig != null ? boardConfig.getAutoSaveTime() : 0);
		} else {
			model.addAttribute("autoSaveTime", 0);
		}
		**/

		if (boardItemInfo != null) {
			BoardListVO bi = ezBoardService.getBrdGetItemInfo(boardID, boardItemInfo.getItemID(), commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getTenantId());
			model.addAttribute("bi", bi);
		}

		model.addAttribute("boardItemInfo", boardItemInfo);
		model.addAttribute("boardID", boardID);
		model.addAttribute("boardName", request.getParameter("boardName"));
		model.addAttribute("isCrossBrowser", true);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("strNow", today);
		model.addAttribute("endDateTime", endDateTime);
		model.addAttribute("newGuid", UUID.randomUUID().toString());
		model.addAttribute("mode", mode);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("reservedItem", "false"); // 파일뷰어게시판은 예약게시 불가
		model.addAttribute("uploadFilePath", uploadFilePath);
		model.addAttribute("itemID", boardItemInfo == null ? "" : boardItemInfo.getItemID());
		model.addAttribute("boardHref", boardItemInfo == null ? "" : boardItemInfo.getFilePath());
		model.addAttribute("useVersion", ezBoardService.getUseVersionFlag(boardID, userInfo.getTenantId()));

		logger.info("fileViewerBoard ended");
		return "ezBoard/fileViewerBoard";
	}

	
	// 2024-07-31 전인하 - 게시판 > 확장컬럼 > peoplePicker 타입 > 유저 선택 팝업 호출
	@RequestMapping(value = "/ezBoard/boardSelectUser.do", method = RequestMethod.GET)
	public String personalPopupUser(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("personalPopupUser started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String deptID = userInfo.getDeptID();
		String cn = request.getParameter("cn") == null ? "" : request.getParameter("cn");
		String textName = request.getParameter("name") == null ? "" : request.getParameter("name");
		String companyId = request.getParameter("companyId");
		String lang = userInfo.getLang();
		String columnName = request.getParameter("columnName") == null ? "" : request.getParameter("columnName");

		model.addAttribute("columnName", columnName);
		model.addAttribute("deptID", deptID);
		model.addAttribute("cn", cn);
		model.addAttribute("textName", textName);
		model.addAttribute("companyId", companyId);
		model.addAttribute("dept", userInfo.getDeptID());
		model.addAttribute("lang", lang);

		logger.debug("personalPopupUser ended");
		return "/ezBoard/boardSelectUser";
	}

	/**
	 * 2023-03-30 이가은 - 게시물 댓글의 답글 작성/수정기능 추가 > 댓글 또는 답글 수정되었을 경우 업데이트하는 메서드
	 */
	@ResponseBody
	@RequestMapping(value = "/ezBoard/updateOneLineReply.do", method = RequestMethod.POST)
	public void updateOneLineReply(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception {
		logger.debug("updateOneLineReply started");

		userInfo = commonUtil.userInfo(loginCookie);
		String itemID = request.getParameter("itemID");
		String boardID = request.getParameter("boardID");
		String replyID = request.getParameter("replyID");
		String content = request.getParameter("content");
		int tenantID = userInfo.getTenantId();
		String updateDate = commonUtil.getTodayUTCTime("");
		String imageContent = request.getParameter("imageContent");
		String commentAttach = request.getParameter("commentAttach");
		String realPath = commonUtil.getRealPath(request);

		ezBoardService.updateOneLineReply(itemID, boardID, replyID, content, updateDate, tenantID, imageContent);
		ezBoardService.saveCommentAttachment(commentAttach, replyID, itemID, boardID, realPath, userInfo.getTenantId());
		
		logger.debug("updateOneLineReply ended");
	}

	/**
	 * 2023-04-12 이가은 - 게시물 댓글의 답글 작성/수정기능 추가 > 댓글 삭제 시 자식 댓글 개수 리턴하는 메서드
	 */
	@ResponseBody
	@RequestMapping(value = "/ezBoard/getChildReplyCnt.do", method = RequestMethod.GET)
	public int getChildReplyCnt(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception {
		logger.debug("getChildReplyCnt started");

		userInfo = commonUtil.userInfo(loginCookie);
		String itemID = request.getParameter("itemID");
		String boardID = request.getParameter("boardID");
		String replyID = request.getParameter("replyID");
		int tenantID = userInfo.getTenantId();

		logger.debug("getChildReplyCnt ended");
		return ezBoardService.getChildReplyCnt(itemID, boardID, replyID, tenantID);
	}
	/**
	 * 2023-04-06 기민혁(싫어요 기능) - 좋아요/싫어요 명단 호출
	 */
	@RequestMapping(value = "/ezBoard/boardLikeAndDisLikeList.do", method = RequestMethod.GET)
	public String boardLikeAndDisLikeList(HttpServletRequest request,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model)throws Exception {
		logger.debug("boardLikeAndDisLikeList started");

		userInfo = commonUtil.userInfo(loginCookie);

		String pBoardID = "";
		String pItemIDList = "";

		if (request.getParameter("boardID") != null) {
			pBoardID = request.getParameter("boardID");
		}

		if (request.getParameter("itemIDList") != null) {
			pItemIDList = request.getParameter("itemIDList");
		}

		String[] itemIDs = pItemIDList.split(";");

		String strXML = ezBoardService.boardLikeAndDisLikeList(userInfo, pBoardID, itemIDs);

		model.addAttribute("strXML", strXML);

		logger.debug("boardLikeAndDisLikeList ended");
		return "ezBoard/boardLikeAndDisLikeList";
	}

	/** 2023-04-06 기민혁 - 게시물의 싫어요 삽입 및 삭제 */
	@RequestMapping(value = "/ezBoard/clickDisLikeMod.do", method = RequestMethod.POST)
	@ResponseBody
	public String clickDisLikeInsert(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("clickDisLikeMod started.");

		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String itemID = request.getParameter("itemID");
		String mod = request.getParameter("mod");
		String isDisLikeChecked = "";

		if (mod.equalsIgnoreCase("INSERT")) {
			ezBoardService.disLikeInsert(userInfo.getId(), itemID, userInfo.getTenantId());
			isDisLikeChecked = "Y";
		} else {
			ezBoardService.disLikeDelete(userInfo.getId(), itemID, userInfo.getTenantId());
			isDisLikeChecked = "N";
		}

		logger.debug("clickDisLikeMod ended.");
		return isDisLikeChecked;
	}

	/** 2023-04-06 기민혁 - 게시물의 싫어요 갯수 가져오기 */
	@RequestMapping(value = "/ezBoard/getDisLikeCount.do", method = RequestMethod.GET)
	@ResponseBody
	public int getDisLikeCount(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getDisLikeCount started.");

		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String itemID = request.getParameter("itemID");
		int disLikeCount = 0;

		disLikeCount = ezBoardService.getDisLikeCount(itemID, userInfo.getTenantId());

		logger.debug("getDisLikeCount ended.");
		return disLikeCount;
	}

	/** 2023-04-06 기민혁 - 좋아요 싫어요 엑셀 다운로드 */
	@RequestMapping(value = "/ezBoard/excelLikeAndDisLikeList.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public void getExcelLikeAndDisLikeList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response, Model model, @RequestBody String xmlPara) throws Exception{
		logger.debug("getExcelLikeAndDisLikeList started");

		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);

		HSSFWorkbook workbook = new HSSFWorkbook();
		HSSFSheet sheet;

		HSSFCellStyle headerStyle= workbook.createCellStyle();
		headerStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
		headerStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		headerStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		headerStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
		headerStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
		headerStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		headerStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		headerStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);

		HSSFCellStyle bodyStyle= workbook.createCellStyle();
		bodyStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		bodyStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
		bodyStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
		bodyStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		bodyStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		bodyStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);

		Row row;
		Cell cell;
		int rowNum = 0;
		sheet = workbook.createSheet("report");

		// XPath를 생성
		XPathFactory xPathFactory = XPathFactory.newInstance();
		XPath xPath = xPathFactory.newXPath();

		// XPath 표현식을 컴파일하여 "DATA/ROW" 노드를 선택
		XPathExpression expr = xPath.compile("DATA/ROW");
		NodeList nodeList = (NodeList) expr.evaluate(xmlDom, XPathConstants.NODESET);

		for (int i = 0; i < nodeList.getLength(); i++){
			Node node = nodeList.item(i);
			String titleValue = xPath.compile("ITEMINFO/TITLE").evaluate(node);

			// likeList와 dislikeList 정보 호출
			NodeList likeList = (NodeList) xPath.compile("LIKELIST").evaluate(node, XPathConstants.NODESET);
			NodeList dislikeList = (NodeList) xPath.compile("DISLIKELIST").evaluate(node, XPathConstants.NODESET);
			Node likeNode = likeList.item(0);
			Node dislikeListNode = dislikeList.item(0);

			// LIKELIST DISPLAYNAME 개수 얻기
			NodeList likeDisplayNameList = (NodeList) xPath.compile("LIKELIST/DISPLAYNAME").evaluate(node, XPathConstants.NODESET);

			// DISLIKELIST의 D_DISPLAYNAME 개수 얻기
			NodeList dislikeDisplayNameList = (NodeList) xPath.compile("DISLIKELIST/D_DISPLAYNAME").evaluate(node, XPathConstants.NODESET);

			row = sheet.createRow(rowNum);

			cell = row.createCell(0);
			cell.setCellValue(egovMessageSource.getMessage("ezBoard.kmh04", userInfo.getLocale()));
			cell.setCellStyle(headerStyle);

			cell = row.createCell(1);
			cell.setCellValue(titleValue);
			cell.setCellStyle(bodyStyle);

			// 병합할 범위 지정 (현재 행에서 오른쪽으로 5개의 셀을 병합)
			CellRangeAddress mergedRegion = new CellRangeAddress(row.getRowNum(), row.getRowNum(), 1, 5);
			sheet.addMergedRegion(mergedRegion);
			RegionUtil.setBorderBottom(CellStyle.BORDER_THIN, mergedRegion, sheet, workbook);
			RegionUtil.setBorderTop(CellStyle.BORDER_THIN, mergedRegion, sheet, workbook);
			RegionUtil.setBorderLeft(CellStyle.BORDER_THIN, mergedRegion, sheet, workbook);
			RegionUtil.setBorderRight(CellStyle.BORDER_THIN, mergedRegion, sheet, workbook);

			rowNum++;
			row = sheet.createRow(rowNum);

			cell = row.createCell(0);
			cell.setCellValue(egovMessageSource.getMessage("ezBoard.kmh05", userInfo.getLocale())+ "(" + likeDisplayNameList.getLength() + ")");
			cell.setCellStyle(headerStyle);

			// 병합할 범위 지정 (현재 행에서 오른쪽으로 2개의 셀을 병합)
			CellRangeAddress MergedRegion1 = new CellRangeAddress(row.getRowNum(), row.getRowNum(), 0, 2);
			sheet.addMergedRegion(MergedRegion1);

			// 병합된 영역의 경계선 설정
			RegionUtil.setBorderBottom(CellStyle.BORDER_THIN, MergedRegion1, sheet, workbook);
			RegionUtil.setBorderTop(CellStyle.BORDER_THIN, MergedRegion1, sheet, workbook);
			RegionUtil.setBorderLeft(CellStyle.BORDER_THIN, MergedRegion1, sheet, workbook);
			RegionUtil.setBorderRight(CellStyle.BORDER_THIN, MergedRegion1, sheet, workbook);

			cell = row.createCell(3);
			cell.setCellValue(egovMessageSource.getMessage("ezBoard.kmh06", userInfo.getLocale())+ "(" +dislikeDisplayNameList.getLength() + ")");
			cell.setCellStyle(headerStyle);

			// 병합할 범위 지정 (현재 행에서 오른쪽으로 2개의 셀을 병합)
			CellRangeAddress MergedRegion2 = new CellRangeAddress(row.getRowNum(), row.getRowNum(), 3, 5);
			sheet.addMergedRegion(MergedRegion2);

			// 병합된 영역의 경계선 설정
			RegionUtil.setBorderBottom(CellStyle.BORDER_THIN, MergedRegion2, sheet, workbook);
			RegionUtil.setBorderTop(CellStyle.BORDER_THIN, MergedRegion2, sheet, workbook);
			RegionUtil.setBorderLeft(CellStyle.BORDER_THIN, MergedRegion2, sheet, workbook);
			RegionUtil.setBorderRight(CellStyle.BORDER_THIN, MergedRegion2, sheet, workbook);

			int maxDisplayNameCount = Math.max(likeDisplayNameList.getLength(), dislikeDisplayNameList.getLength());

			if(maxDisplayNameCount == 0){
				rowNum++;
				row = sheet.createRow(rowNum);

				cell = row.createCell(0);
				cell.setCellValue(egovMessageSource.getMessage("ezBoard.kmh02", userInfo.getLocale()));
				cell.setCellStyle(bodyStyle);

				// 병합할 범위 지정 (현재 행에서 오른쪽으로 2개의 셀을 병합)
				CellRangeAddress MergedRegion3 = new CellRangeAddress(row.getRowNum(), row.getRowNum(), 0, 2);
				sheet.addMergedRegion(MergedRegion3);

				// 병합된 영역의 경계선 설정
				RegionUtil.setBorderBottom(CellStyle.BORDER_THIN, MergedRegion3, sheet, workbook);
				RegionUtil.setBorderTop(CellStyle.BORDER_THIN, MergedRegion3, sheet, workbook);
				RegionUtil.setBorderLeft(CellStyle.BORDER_THIN, MergedRegion3, sheet, workbook);
				RegionUtil.setBorderRight(CellStyle.BORDER_THIN, MergedRegion3, sheet, workbook);

				cell = row.createCell(3);
				cell.setCellValue(egovMessageSource.getMessage("ezBoard.kmh03", userInfo.getLocale()));
				cell.setCellStyle(bodyStyle);

				// 병합할 범위 지정 (현재 행에서 오른쪽으로 2개의 셀을 병합)
				CellRangeAddress MergedRegion4 = new CellRangeAddress(row.getRowNum(), row.getRowNum(), 3, 5);
				sheet.addMergedRegion(MergedRegion4);

				// 병합된 영역의 경계선 설정
				RegionUtil.setBorderBottom(CellStyle.BORDER_THIN, MergedRegion4, sheet, workbook);
				RegionUtil.setBorderTop(CellStyle.BORDER_THIN, MergedRegion4, sheet, workbook);
				RegionUtil.setBorderLeft(CellStyle.BORDER_THIN, MergedRegion4, sheet, workbook);
				RegionUtil.setBorderRight(CellStyle.BORDER_THIN, MergedRegion4, sheet, workbook);
			} else {
				for (int j = 0; j < maxDisplayNameCount; j++) {
					rowNum++;
					row = sheet.createRow(rowNum);

					// LIKELIST 처리
					if (j < likeDisplayNameList.getLength()) {
						NodeList dDisplayName = (NodeList) xPath.compile("DISPLAYNAME").evaluate(likeNode, XPathConstants.NODESET);
						NodeList dUserId = (NodeList) xPath.compile("USERID").evaluate(likeNode, XPathConstants.NODESET);
						NodeList dLikeDate = (NodeList) xPath.compile("LIKEDATE").evaluate(likeNode, XPathConstants.NODESET);
						Node displayNameNode = dDisplayName.item(j);
						Node userIdNode = dUserId.item(j);
						Node likeDateNode = dLikeDate.item(j);
						String displayName = displayNameNode.getTextContent();
						String userId = userIdNode.getTextContent();
						String likeDate = likeDateNode.getTextContent();

						cell = row.createCell(0);
						cell.setCellValue(displayName);
						cell.setCellStyle(bodyStyle);
						cell = row.createCell(1);
						cell.setCellValue(userId);
						cell.setCellStyle(bodyStyle);
						cell = row.createCell(2);
						cell.setCellValue(likeDate);
						cell.setCellStyle(bodyStyle);
					} else {
						cell = row.createCell(0);
						cell.setCellValue("");
						cell.setCellStyle(bodyStyle);
						cell = row.createCell(1);
						cell.setCellValue("");
						cell.setCellStyle(bodyStyle);
						cell = row.createCell(2);
						cell.setCellValue("");
						cell.setCellStyle(bodyStyle);
					}

					// DISLIKELIST 처리
					if (j < dislikeDisplayNameList.getLength()) {
						NodeList dDisplayName = (NodeList) xPath.compile("D_DISPLAYNAME").evaluate(dislikeListNode, XPathConstants.NODESET);
						NodeList dUserId = (NodeList) xPath.compile("D_USERID").evaluate(dislikeListNode, XPathConstants.NODESET);
						NodeList dDislikeDate = (NodeList) xPath.compile("D_DISLIKEDATE").evaluate(dislikeListNode, XPathConstants.NODESET);
						Node displayNameNode = dDisplayName.item(j);
						Node userIdNode = dUserId.item(j);
						Node dislikeDateNode = dDislikeDate.item(j);
						String displayNameValue = displayNameNode.getTextContent();
						String userIdValue = userIdNode.getTextContent();
						String dislikeDateValue = dislikeDateNode.getTextContent();

						cell = row.createCell(3);
						cell.setCellValue(displayNameValue);
						cell.setCellStyle(bodyStyle);
						cell = row.createCell(4);
						cell.setCellValue(userIdValue);
						cell.setCellStyle(bodyStyle);
						cell = row.createCell(5);
						cell.setCellValue(dislikeDateValue);
						cell.setCellStyle(bodyStyle);
					} else {
						cell = row.createCell(3);
						cell.setCellValue("");
						cell.setCellStyle(bodyStyle);
						cell = row.createCell(4);
						cell.setCellValue("");
						cell.setCellStyle(bodyStyle);
						cell = row.createCell(5);
						cell.setCellValue("");
						cell.setCellStyle(bodyStyle);
					}
				}
			}
			rowNum = rowNum+2;
		}

		sheet.setColumnWidth(0, 5000);
		sheet.setColumnWidth(1, 5000);
		sheet.setColumnWidth(2, 5000);
		sheet.setColumnWidth(3, 5000);
		sheet.setColumnWidth(4, 5000);
		sheet.setColumnWidth(5, 5000);

		workbook.write(response.getOutputStream());
		workbook.close();

		logger.debug("getExcelLikeAndDisLikeList ended");

	}

	/**
	 * 2023-04-12 이가은 - 게시물 댓글의 답글 작성/수정기능 추가 > 자식이 존재하는 부모댓글 삭제할 경우 해당 댓글 정보를 NULL로 변경해주는 메서드
	 */
	@ResponseBody
	@RequestMapping(value = "/ezBoard/updateDelParentReply.do", method = RequestMethod.GET)
	public void updateDelParentReply(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception {
		logger.debug("updateDelParentReply started");

		userInfo = commonUtil.userInfo(loginCookie);
		String itemID = request.getParameter("itemID");
		String boardID = request.getParameter("boardID");
		String replyID = request.getParameter("replyID");
		int tenantID = userInfo.getTenantId();

		ezBoardService.updateDelParentReply(replyID, itemID, boardID, tenantID);

		logger.debug("updateDelParentReply ended");
	}

    /**
     * 익명게시판 비번체크
     */
    @RequestMapping(value = "/ezBoard/chkPasswordAnonymous.do", method = RequestMethod.GET ,produces = "text/plain; charset=utf-8")
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
	
	/**
	 * 게시판 전체게시물 리스트 표출 Method
	 */
	public String getAllItemList(BoardVO boardVO, LoginVO userInfo) throws Exception {
		logger.debug("getAllItemList started");

		String orderOption1 = "";
		String orderOption2 = "";
		String strMultiData = commonUtil.getMultiData(boardVO.getLang(), userInfo.getTenantId());
		String anonyMsg = "";
		
		BoardListVO boardListVO = new BoardListVO();
		boardVO.setBoardType("E");
		boardVO.setLang(userInfo.getLang());
		boardVO.setTenantID(userInfo.getTenantId());
		
		List<BoardListHeaderVO> headerList = ezBoardService.getListHeader(userInfo, boardVO);

		int i = 0;
		int hlength = headerList.size();
		Map<String, String> orderByMap = new HashMap<String, String>();
		
		for (i = 0; i < hlength; i++) {
			if (boardVO.getOrderCell() != null && !boardVO.getOrderCell().equals("") && boardVO.getOrderCell().equals(headerList.get(i).getName())) {
				orderByMap.put("orderByCol", headerList.get(i).getColName().toUpperCase());
				if (boardVO.getOrderOption().equals("")) {
					orderByMap.put("orderByColDesc", "N");
					if (headerList.get(i).getName().indexOf("BOARDNAME") > -1) {
						orderOption1 = headerList.get(i).getColName().replace("BOARDNAME", "B.BOARDNAME") + " ";
					} else {
						orderOption1 = headerList.get(i).getColName() + " ";
					}
				} else {
					orderByMap.put("orderByColDesc", "Y");
					if (headerList.get(i).getColName().indexOf("BOARDNAME") > -1) {
						orderOption1 = headerList.get(i).getColName().replace("BOARDNAME", "B.BOARDNAME") + " DESC ";
					} else {
						orderOption1 = headerList.get(i).getColName() + " DESC ";
					}
				}
			}
		}

		String fieldName = "";
		String fieldValue = "";

		BoardConfigVO boardConfigVO = ezBoardService.getPersonalCount(userInfo);

		// 새게시물 카운트 시 companyID 조건 추가
		int boardCount = ezBoardService.getAllBoardItemListCount(userInfo);
		int startRow = 1;
		int endRow = 0;
		int personalCount_ = boardConfigVO.getListCount();

		boardConfigVO.setPageCnt(boardCount);
		boardConfigVO.setTotalCnt(boardCount);

		startRow = (personalCount_ * (boardVO.getPageNum() - 1)) + 1;
		endRow = (personalCount_ * boardVO.getPageNum());

		boardListVO.setUserID(userInfo.getId());
		boardListVO.setWriterCompanyID(userInfo.getCompanyID());
		boardListVO.setTenantID(userInfo.getTenantId());
		boardListVO.setStartRow(startRow);
		boardListVO.setEndRow(endRow);
		boardListVO.setTotalCount(boardCount);
		boardListVO.setOrderBySub(orderOption1);
		boardListVO.setOrderByMain(orderOption2);

		// 새게시물 표출 시 companyID 조건 추가
		List<HashMap<String, Object>> boardList = ezBoardService.getAllBoardItemList(boardListVO, orderByMap);

		int dlength = boardList.size();
		StringBuffer resultXML = new StringBuffer();

		resultXML.append("<DOCLIST>");
		resultXML.append("<TOTALCNT>" + boardCount + "</TOTALCNT>");
		resultXML.append("<PAGECNT>" + boardCount + "</PAGECNT>");
		resultXML.append("<PERSONALCNT>" + personalCount_ + "</PERSONALCNT>");
		resultXML.append("<PREVIEWTYPE>" + boardConfigVO.getPreview() + "</PREVIEWTYPE>");
		resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
		resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
		resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
		resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");

		for (BoardListHeaderVO vo:headerList) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + vo.getName() + "</NAME>");
			resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
			resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
			resultXML.append("</HEADER>");
		}

		resultXML.append("</HEADERS>");
		resultXML.append("<ROWS>");

		/* 2018-11-28 홍승비 - 새게시물 리스트의 익명게시물 부서칼럼 '익명'으로 표출 */
		anonyMsg = egovMessageSource.getMessage("ezBoard.t249", userInfo.getLocale()).split(";")[0];

		for (int j = 0; j < dlength; j++) {
			resultXML.append("<ROW>");

			/* 2019-08-02 홍승비 - 다국어 환경에서 부서명 '익명'처리되지 않는 오류 수정 */
			if (String.valueOf(boardList.get(j).get("GUBUN")).equals("2")) {
				boardList.get(j).replace("WRITERDEPTNAME", anonyMsg);
				boardList.get(j).replace("WRITERDEPTNAME2", anonyMsg);
			}

			for (i = 0; i < hlength; i++) {
				resultXML.append("<CELL>");
				fieldName = headerList.get(i).getColName().toUpperCase();

				if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME") || fieldName.equals("BOARDNAME")) {
					fieldName = fieldName + strMultiData;
				}
				if (fieldName.equals("WRITEDATE")) {
					fieldValue = commonUtil.getDateStringInUTC((String)boardList.get(j).get(fieldName), userInfo.getOffset(), false);
					fieldValue = fieldValue.substring(0, fieldValue.length()-3);
				} else {
					fieldValue = commonUtil.cleanValue(String.valueOf(boardList.get(j).get(fieldName)));
				}

				resultXML.append("<VALUE>" + fieldValue + "</VALUE>");

				if (i == 0) {
					resultXML.append("<DATA1>" + boardList.get(j).get("BOARDID") + "</DATA1>");
					resultXML.append("<DATA2>" + boardList.get(j).get("ITEMID") + "</DATA2>");
					resultXML.append("<DATA3>" + boardList.get(j).get("WRITERID") + "</DATA3>");
					resultXML.append("<DATA4>" + boardList.get(j).get("IMPORTANCE") + "</DATA4>");
					resultXML.append("<DATA5>1</DATA5>");
					resultXML.append("<DATA6>" + commonUtil.cleanValue((String)boardList.get(j).get("ABSTRACT")) + "</DATA6>");
					resultXML.append("<DATA7>N</DATA7>");
					resultXML.append("<DATA8>" + boardList.get(j).get("ITEMLEVEL") + "</DATA8>");
					resultXML.append("<DATA9>" + boardList.get(j).get("NOTICE") + "</DATA9>");
					resultXML.append("<DATA10>" + boardList.get(j).get("GUBUN") + "</DATA10>");
					resultXML.append("<DATA11>" + boardList.get(j).get("ONELINECNT") + "</DATA11>");
					resultXML.append("<EXT>" + commonUtil.cleanValue((String) boardList.get(j).get("EXT")) + "</EXT>");
					resultXML.append("<FILEPATH>" + commonUtil.cleanValue((String) boardList.get(j).get("FILEPATH")) + "</FILEPATH>");

					if (globals.getProperty("Globals.DbType").equals("oracle")) {
						resultXML.append("<DATA12>" + commonUtil.cleanValue((String)boardList.get(j).get("TO_CHAR(MAINCONTENT)")) + "</DATA12>");
					} else if (globals.getProperty("Globals.DbType").equals("tibero")) {
						resultXML.append("<DATA12>" + commonUtil.cleanValue((String)boardList.get(j).get("TO_CHAR(MAINCONTENT)")) + "</DATA12>");
					} else {
						resultXML.append("<DATA12>" + commonUtil.cleanValue((String)boardList.get(j).get("MAINCONTENT")) + "</DATA12>");
					}

					resultXML.append("<TITLE>" + commonUtil.cleanValue((String)boardList.get(j).get("TITLE")) + "</TITLE>");
					/* 2019-07-04 홍승비 - 게시판 미독건수 읽음표시 처리용 boardGroupID 추가 */
					resultXML.append("<BOARDGROUPID>" + boardList.get(j).get("BOARDGROUPID") + "</BOARDGROUPID>");
					resultXML.append("<ITEMREAD_FG>" + (accessCheck((String)boardList.get(j).get("BOARDID"), (String)boardList.get(j).get("ITEMID"),
							"GENERAL", userInfo, "") ? "Y" : "N") + "</ITEMREAD_FG>");
				}
				resultXML.append("</CELL>");
			}
			resultXML.append("</ROW>");
		}
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		resultXML.append("</DOCLIST>");

		logger.debug("getAllItemList ended");
		return resultXML.toString();
	}

	@RequestMapping(value = "/ezBoard/boardItemWarnPage.do", method = RequestMethod.GET)
	public String getBoardWarningPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo, Model model) throws Exception {
		logger.debug("getBoardWarningPage started");
		String pPreviewShow_HOW = request.getParameter("pPreviewShow_HOW");
		
		model.addAttribute("pPreviewShow_HOW", pPreviewShow_HOW);
		
		logger.debug("getBoardWarningPage ended");
		return "main/warning";
	}
	
	@RequestMapping(value="/ezBoard/WHWPEditor.do", method = RequestMethod.GET)
	public String WHWPEditor(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("WHWPEditor started.");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String type = request.getParameter("type");
		
		model.addAttribute("webHWPUrl", ezCommonService.getTenantConfig("webHWPUrl", userInfo.getTenantId()));
		model.addAttribute("type", type);
		
		logger.debug("WHWPEditor ended.");
		return "/ezBoard/boardWHWPEditor";
	}
	
	/**
	 * 2023-05-03 기민혁(마이게시판 하위 스크랩 기능) - 스크랩 추가 버튼 클릭시 정보 등록
	 */
	@RequestMapping(value = "/ezBoard/setScrapItem.do", method = RequestMethod.GET)
	@ResponseBody
	public String setScrapItem(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("setScrapItem started");
			
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
			
		String userID = userInfo.getId();
		String itemID = request.getParameter("itemID");
		String boardID = request.getParameter("boardID");
		String companyID = userInfo.getCompanyID();
		int tenantID = userInfo.getTenantId();
			
		String result = ezBoardService.getScrapItemCount(userID,itemID,boardID,companyID,tenantID);
			
		if("true".equals(result)){
			result = ezBoardService.setScrapItem(userID,itemID,boardID,companyID,tenantID);
		}
			
		logger.debug("setScrapItem ended");
		return result;
	}
		
	/**
	 * 2023-05-03 기민혁(마이게시판 하위 스크랩 기능) - 스크랩 해제 버튼 클릭시 정보 삭제
	 */
	@RequestMapping(value = "/ezBoard/delScrapItem.do", method = RequestMethod.POST)
	@ResponseBody
	public String delScrapItem(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("delScrapItem started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String userID = userInfo.getId();
		String itemID = request.getParameter("itemID");
		String boardID = request.getParameter("boardID");
		String companyID = userInfo.getCompanyID();
		int tenantID = userInfo.getTenantId();
		
		String result = ezBoardService.getScrapItemCount(userID,itemID,boardID,companyID,tenantID);
		
		if("false".equals(result)){
			result = ezBoardService.delScrapItem(userID,itemID,boardID,companyID,tenantID);
		}

		logger.debug("delScrapItem ended");
		return result;
	}

	/**
	 * 2023-05-03 기민혁(마이게시판 하위 스크랩 기능) - 나의 스크랩 화면 표출
	 */
	@RequestMapping(value = "/ezBoard/boardMyScrapList.do", method = RequestMethod.GET)
	public String boardMyScrapList(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("boardMyScrapList started");

		userInfo = commonUtil.userInfo(loginCookie);

		int page = StringUtils.isNotBlank(request.getParameter("page")) ? Integer.parseInt(request.getParameter("page")) : 1;
		String useOcs = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId());
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String useRunTime = ezCommonService.getTenantConfig("USERUNTIME", userInfo.getTenantId());

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("page", page);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("useRunTime", useRunTime);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("use_oneLineCount", "YES");

		logger.debug("boardMyScrapList ended");
		return "ezBoard/boardMyScrapList";
	}

	/**
	 * 2023-05-03 기민혁(마이게시판 하위 스크랩 기능) - 나의 스크랩 page에서 스크랩 게시물 다중 해제 기능
	 */
	@RequestMapping(value = "/ezBoard/deleteScrapItem.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String deleteScrapItem(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("deleteScrapItem started");

		userInfo = commonUtil.userInfo(loginCookie);
		String userID = userInfo.getId();
		String itemList = request.getParameter("itemList");
		String companyID = userInfo.getCompanyID();
		int tenantID = userInfo.getTenantId();

		String result = ezBoardService.deleteScrapItem(userID, itemList, companyID, tenantID);

		logger.debug("deleteScrapItem ended");
		return result;
	}
	
	/**
	 * 2023-05-22 기민혁(스크랩함 스크랩 기능) - 게시판 left에서 스크랩함 관리창 호출
	 */
	@RequestMapping(value = "/ezBoard/mngUserScrapCont.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	public String mngUserScrapCont(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("mngUserScrapCont started");

		userInfo = commonUtil.userInfo(loginCookie);
		String userScrapCont = ezBoardService.getUserScrapContTree(userInfo.getId(), "ROOT", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getLocale());
		model.addAttribute("userScrapCont", userScrapCont.replace("\"", "\\\""));
		model.addAttribute("userInfo", userInfo);

		logger.debug("mngUserScrapCont ended");
		return "ezBoard/boardMngUserScrapCont";
	}

	/**
	 * 2023-05-22 기민혁(스크랩함 스크랩 기능) - 스크랩함 관리창에서 문서함추가, 이름수정시 창 호출
	 */
	@RequestMapping(value = "/ezBoard/getScrapContName.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	public String getScrapContName(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("getScrapContName started");

		userInfo = commonUtil.userInfo(loginCookie);
		String title = request.getParameter("Title");
		String titleText = URLDecoder.decode(request.getParameter("TitleText"), "utf-8");

		if (title.equals("")) {
			title = egovMessageSource.getMessage("ezBoard.kmh28", userInfo.getLocale());
		}

		model.addAttribute("titleText", titleText);
		model.addAttribute("title", title);

		logger.debug("getScrapContName ended");
		return "ezBoard/boardGetScrapContName";
	}


	/**
	 * 2023-05-22 기민혁(스크랩함 스크랩 기능) - 스크랩함 관리창에서 문서함 추가
	 */
	@RequestMapping(value = "/ezBoard/insertUserScrapCont.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String insertUserScrapCont(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model , @RequestBody String xmlPara) throws Exception{
		logger.debug("insertUserScrapCont started");

		userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String OwnUserID = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
		String ParentScrapContID = xmlDom.getDocumentElement().getChildNodes().item(1).getTextContent();
		String OwnUserName = xmlDom.getDocumentElement().getChildNodes().item(2).getTextContent();
		String description = xmlDom.getDocumentElement().getChildNodes().item(3).getTextContent();

		String result = ezBoardService.insUserScrapCont(OwnUserID, ParentScrapContID, OwnUserName, description, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());

		logger.debug("insertUserScrapCont ended");
		return result;
	}

	/**
	 * 2023-05-22 기민혁(스크랩함 스크랩 기능) - 스크랩함 관리창에서 문서함 추가 후 데이터 표출
	 */
	@RequestMapping(value = "/ezBoard/getUserScrapContSubTree.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getUserScrapContSubTree(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model , @RequestBody String xmlPara) throws Exception{
		logger.debug("getUserScrapContSubTree started");

		userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String OwnUserID = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
		String ParentScrapContID = xmlDom.getDocumentElement().getChildNodes().item(1).getTextContent();

		String result = ezBoardService.getUserScrapContTree(OwnUserID, ParentScrapContID, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getLocale());

		logger.debug("getUserScrapContSubTree ended");
		return result;
	}

	/**
	 * 2023-05-22 기민혁(스크랩함 스크랩 기능) - 스크랩함 관리창에서 문서함 이름 수정
	 */
	@RequestMapping(value = "/ezBoard/updateUserScrapCont.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String updateUserScrapCont(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model , @RequestBody String xmlPara) throws Exception{
		logger.debug("updateUserScrapCont started");

		userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);

		String ScrapContID = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
		String OwnUserID = xmlDom.getDocumentElement().getChildNodes().item(1).getTextContent();
		String ParentScrapContID = xmlDom.getDocumentElement().getChildNodes().item(2).getTextContent();
		String UserScrapContName = xmlDom.getDocumentElement().getChildNodes().item(3).getTextContent();
		String Description = xmlDom.getDocumentElement().getChildNodes().item(4).getTextContent();

		String result = ezBoardService.updateUserScrapCont(ScrapContID, OwnUserID, ParentScrapContID, UserScrapContName, Description, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());

		logger.debug("updateUserScrapCont ended");
		return result;
	}

	/**
	 * 2023-05-22 기민혁(스크랩함 스크랩 기능) - 스크랩함 관리창에서 문서함 삭제
	 */
	@RequestMapping(value = "/ezBoard/deleteUserScrapCont.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String deleteUserScrapCont(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model , @RequestBody String xmlPara) throws Exception{
		logger.debug("deleteUserScrapCont started");

		userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);

		String pScrapContID = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
		String pMode = xmlDom.getDocumentElement().getChildNodes().item(1).getTextContent();

		String result = ezBoardService.deleteUserScrapCont(pScrapContID, pMode, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());

		logger.debug("deleteUserScrapCont ended");
		return result;
	}

	/**
	 * 2023-05-22 기민혁(스크랩함 스크랩 기능) - 게시판 List에서 스크랩함 관리창 호출
	 */
	@RequestMapping(value = "/ezBoard/selUserScrapCont.do", produces = "text/xml;charset=utf-8", method = RequestMethod.GET)
	public String selUserScrapCont(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("selUserScrapCont started");

		userInfo = commonUtil.userInfo(loginCookie);
		String itemID =  request.getParameter("itemID");
		String boardID =  request.getParameter("boardID");
		String userScrapCont = ezBoardService.getUserScrapContTree(userInfo.getId(), "ROOT", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getLocale());
		model.addAttribute("userScrapCont", userScrapCont);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("itemID", itemID);
		model.addAttribute("boardID", boardID);

		logger.debug("selUserScrapCont ended");
		return "ezBoard/boardSelUserScrapCont";
	}

	/**
	 * 2023-05-22 기민혁(스크랩함 스크랩 기능) - 스크랩함 폴더에 게시물 data insert
	 */
	@RequestMapping(value = "/ezBoard/setUserScrapItemList.do", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> setUserScrapItemList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, Model model) throws Exception{
		logger.debug("setUserScrapItemList start.");

		userInfo = commonUtil.userInfo(loginCookie);
		String itemListID =  request.getParameter("itemListID");
		String boardID =  request.getParameter("boardID");
		String userScrapContID = request.getParameter("userScrapContID");

		//이미 추가되어있는 게시물 count
		int OverlapItemCount = ezBoardService.getOverlapItemCount(userInfo.getId(),itemListID,boardID,userScrapContID,userInfo.getCompanyID(),userInfo.getTenantId());

		//tbl_userscrapcontlist에 데이터 insert
		String result = ezBoardService.setUserScrapContItem(userInfo.getId(),itemListID,boardID,userScrapContID,userInfo.getCompanyID(),userInfo.getTenantId());
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("OverlapItemCount", OverlapItemCount);
		map.put("result", result);

		logger.debug("setUserScrapItemList ended.");

		return map;
	}


	/**
	 * 2023-05-22 기민혁(스크랩함 스크랩 기능) - 스크랩함에 있는 게시물 표출
	 */
	@RequestMapping(value = "/ezBoard/getBoardScrapContItemListView.do", method = RequestMethod.GET)
	public String getBoardScrapContItemListView(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("getBoardScrapContItemListView started");

		userInfo = commonUtil.userInfo(loginCookie);

		int page = StringUtils.isNotBlank(request.getParameter("page")) ? Integer.parseInt(request.getParameter("page")) : 1;
		String useOcs = ezCommonService.getTenantConfig("USE_OCS", userInfo.getTenantId());
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String useRunTime = ezCommonService.getTenantConfig("USERUNTIME", userInfo.getTenantId());
		String scrapContID = request.getParameter("scrapContID");
		String scrapContTitle = request.getParameter("scrapContTitle");

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("page", page);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("useRunTime", useRunTime);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("use_oneLineCount", "YES");
		model.addAttribute("scrapContID",scrapContID);
		model.addAttribute("scrapContTitle", commonUtil.htmlUnescape(scrapContTitle));

		logger.debug("getBoardScrapContItemListView ended");
		return "ezBoard/boardScrapContItemListView";
	}

	/**
	 * 2023-05-22 기민혁(스크랩함 스크랩 기능) - 게시판함의 게시물 List 스크랩 해제
	 */
	@RequestMapping(value = "/ezBoard/deleteScrapContItemList.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String deleteScrapContItemList(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("deleteScrapContItemList started");

		userInfo = commonUtil.userInfo(loginCookie);
		String userID = userInfo.getId();
		String itemList = request.getParameter("itemList");
		String companyID = userInfo.getCompanyID();
		int tenantID = userInfo.getTenantId();
		String scrapContID = request.getParameter("scrapContID");

		String result = ezBoardService.deleteScrapContItemList(userID, itemList, companyID, tenantID, scrapContID);

		logger.debug("deleteScrapContItemList ended");
		return result;
	}

	/**
	 * 2023-05-22 기민혁(스크랩함 스크랩 기능) - 스크랩함 의견창 호출
	 */
	@RequestMapping(value = "/ezBoard/boardOpinion.do", method = RequestMethod.GET)
	public String boardOpinion(HttpServletRequest req, Model model){
		logger.debug("boardOpinion started");

		if (req.getParameter("type") != null) {
			String type = req.getParameter("type");
			model.addAttribute("type", type);
		}

		if (req.getParameter("formURL") != null) {
			String formURL = req.getParameter("formURL");
			model.addAttribute("formURL", formURL);
		}

		if (req.getParameter("formDocType") != null) {
			String formDocType = req.getParameter("formDocType");
			model.addAttribute("formDocType", formDocType);
		}

		logger.debug("boardOpinion ended");
		return "ezBoard/boardOpinion";
	}

	/**
	 * 2023-05-22 기민혁 - 게시판 알러트 호출
	 */
	@RequestMapping(value = "/ezBoard/boardAlert.do", method = RequestMethod.GET)
	public String boardAlert() throws Exception{
		logger.debug("boardAlert start");
		return "ezBoard/boardAlert";
	}

	/**
	 * 2024-10-10 전인하 - 게시판 > 마이게시판 하위 스크랩 > 스크랩 추가 다중선택 동작
	 * 이미 인서트되어있는 스크랩은 패스하고, 없는 것만 인서트한 뒤 성공 수, 실패 수를 따로 반환
	 */
	@RequestMapping(value = "/ezBoard/setScrapItemAll.do", method = RequestMethod.GET)
	@ResponseBody
	public JSONObject setScrapItemAll(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("setScrapItem started");

		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);

		String userID = userInfo.getId();
		String itemID = request.getParameter("itemIDList");
		String[] itemIDList = itemID.split(";");
		String boardID = request.getParameter("boardID");
		String companyID = userInfo.getCompanyID();
		int tenantID = userInfo.getTenantId();
		
		JSONObject result = new JSONObject();
		
		String resultCode = "true";
		int successCount = 0;
		if (itemID.length() > 0) {
			for (String id : itemIDList) {
				resultCode = ezBoardService.getScrapItemCount(userID, id, boardID, companyID, tenantID);

				if ("true".equals(resultCode)) {
					resultCode = ezBoardService.setScrapItem(userID, id, boardID, companyID, tenantID);
					successCount += 1;
				} else if ("error".equals(resultCode)) {
					break;
				}
			}
		}
		
		if ("error".equals(resultCode)) {
			result.put("status", "error");
		} else {
			result.put("status", "success");
			result.put("failCount", itemIDList.length - successCount);
		}

		logger.debug("setScrapItem ended");
		return result;
	}
	
	public Map<String, ArrayList<String>> getScrapContBoardListReadView_FG(LoginVO userInfo, BoardVO boardVO) throws Exception {
		BoardPropertyVO scrapContBoardInfo;
		ArrayList<String> scrapContBoardListView_FG = new ArrayList<String>();
		ArrayList<String> scrapContBoardListRead_FG = new ArrayList<String>();
		Map<String, ArrayList<String>> returnVal = new HashMap<>();
		
		List<HashMap<String, Object>> userScrapContBoardList = ezBoardService.getUserScrapContBoardList(userInfo, boardVO.getScrapContID());
		if (userScrapContBoardList != null && userScrapContBoardList.size() > 0) {
			for (HashMap<String, Object> userScrapContBoard : userScrapContBoardList) {
				String boardID = (String) userScrapContBoard.get("BOARDID");
				scrapContBoardInfo = getBoardInfo(boardID, userInfo);
				if (scrapContBoardInfo.getListView_FG().equals("true")) {
					scrapContBoardListView_FG.add(boardID);
				}

				if (scrapContBoardInfo.getRead_FG().equals("true")) {
					scrapContBoardListRead_FG.add(boardID);
				}
				scrapContBoardInfo = null;
			}
		}
		returnVal.put("scrapContBoardListView_FG", scrapContBoardListView_FG);
		returnVal.put("scrapContBoardListRead_FG", scrapContBoardListRead_FG);
		return returnVal;
	}
	
	public Map<String, ArrayList<String>> getScrapBoardListReadView_FG(LoginVO userInfo) throws Exception {
		BoardPropertyVO scrapBoardInfo = new BoardPropertyVO();
		ArrayList<String> scrapBoardListView_FG = new ArrayList<String>();
		ArrayList<String> scrapBoardListRead_FG = new ArrayList<String>();
		Map<String, ArrayList<String>> result = new HashMap<>();
	
		List<HashMap<String, Object>> userScrapBoardList = ezBoardService.getUserScrapBoardList(userInfo.getId(), userInfo.getTenantId());
		if (userScrapBoardList != null && userScrapBoardList.size() > 0) {
			for (HashMap<String, Object> userScrapBoard : userScrapBoardList) {
				String boardID = (String) userScrapBoard.get("BOARDID");
				scrapBoardInfo =  getBoardInfo(boardID, userInfo);
				if (scrapBoardInfo.getListView_FG().equals("true")) {
					scrapBoardListView_FG.add(boardID);
				}
	
				if(scrapBoardInfo.getRead_FG().equals("true")){
					scrapBoardListRead_FG.add(boardID);
				}
				scrapBoardInfo = null;
			}
		}
		result.put("scrapBoardListRead_FG", scrapBoardListRead_FG);
		result.put("scrapBoardListView_FG", scrapBoardListView_FG);
		
		return result;
	}
	
	/**
	 * 동영상게시판 동영상수정
	 */
	@RequestMapping(value = "/ezBoard/modifyThumbnailItem.do", method = RequestMethod.GET)
	public String modifyThumbnailItem(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		logger.debug("modifyThumbnailItem started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String movieID = request.getParameter("movieID");
		int page = Integer.parseInt(request.getParameter("page"));
		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		String guBun = request.getParameter("guBun");
		String thumbUrl = "";
		String thumbnailPath = "";
		int imageCnt = 10;
		int pStartRow = Math.addExact(Math.multiplyExact(Math.subtractExact(page, 1), imageCnt), 1);
		int pEndRow = Math.multiplyExact(page, imageCnt);
		
		List<BoardThumbnailVO> thumbnail = ezBoardService.thumbnailViewDB(itemID, boardID, pStartRow, pEndRow, userInfo.getTenantId());
		
		BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
		
		String filePath = thumbnail.get(0).getFilePath();
		int idx = filePath.lastIndexOf(commonUtil.separator);
		
		thumbUrl = filePath.substring(0, idx + 1) + filePath.substring(idx + 1);
		String movieVal = thumbUrl.split("/")[7];
		thumbnailPath = "/ezBoard/getBoardThumbnailInfo.do?type=BOARDTHUM&boardID=" + boardID + "&fileName=" + "s_" + thumbUrl.split("/")[7].substring(0, thumbUrl.split("/")[7].lastIndexOf(".")) + "." + thumbnail.get(0).getThumbnailExt();
		
		model.addAttribute("movieID", movieID);
		model.addAttribute("thumbnailPath", thumbnailPath);
		model.addAttribute("boardID", boardID);
		model.addAttribute("boardInfo", boardInfo);
		model.addAttribute("itemID", itemID);
		model.addAttribute("guBun", guBun);
		model.addAttribute("addThumbnail", thumbnail.get(0).getAddThumbnail());
		model.addAttribute("thumbnailExt", thumbnail.get(0).getThumbnailExt());
		model.addAttribute("movieVal", movieVal);
		model.addAttribute("imageName", thumbnail.get(0).getImageName());
		
		logger.debug("modifyThumbnailItem ended");
		return "ezBoard/boardModifyThumbnailItem";
	}
	
	@RequestMapping(value = "/ezBoard/movieViewList.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String movieViewList(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("movieViewList started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		String itemID = request.getParameter("itemID");
		String boardID = request.getParameter("boardID");
		String realPath = commonUtil.getRealPath(request);
		String g_ImageUrl = "";
		int imageCnt = 10;
		int page = Integer.parseInt(request.getParameter("page")); // page = 0인 경우, photoViewDB에서 분기 체크하여 모든 이미지를 가져오도록 함
		int pStartRow = Math.addExact(Math.multiplyExact(Math.subtractExact(page, 1), imageCnt), 1);
		int pEndRow = Math.multiplyExact(page, imageCnt);
		
		List<BoardThumbnailVO> movieViewList = ezBoardService.thumbnailViewDB(itemID, boardID, pStartRow, pEndRow, userInfo.getTenantId());
		
		StringBuffer sb = new StringBuffer();
		
		sb.append("<DATA>");
		
		for (int k = 0; k < movieViewList.size(); k++) {
			int idx = movieViewList.get(k).getFilePath().lastIndexOf(commonUtil.separator);
			g_ImageUrl = movieViewList.get(k).getFilePath().substring(0, idx + 1) + movieViewList.get(k).getFilePath().substring(idx + 1);
			
			sb.append("<ROW>");
			sb.append("<IMAGEID>" + movieViewList.get(k).getImageID() + "</IMAGEID>");
			sb.append("<FILEPATH>" + commonUtil.cleanValue(g_ImageUrl) + "</FILEPATH>");
			sb.append("<FILECONTENT>" + commonUtil.cleanValue(movieViewList.get(k).getFileContent()) + "</FILECONTENT>");
			sb.append("<FLAG>" + movieViewList.get(k).getFlag() + "</FLAG>");
			sb.append("<IMAGENAME>" + commonUtil.cleanValue(movieViewList.get(k).getImageName()) + "</IMAGENAME>");
			sb.append("<ADDTHUMBNAIL>" + commonUtil.cleanValue(movieViewList.get(k).getAddThumbnail()) + "</ADDTHUMBNAIL>");
			sb.append("<THUMBNAILEXT>" + commonUtil.cleanValue(movieViewList.get(k).getThumbnailExt()) + "</THUMBNAILEXT>");
			
			String filePath = commonUtil.detectPathTraversal(movieViewList.get(k).getFilePath());
			String orgpDirPath = realPath + filePath;
			String despPath = orgpDirPath.replace("/files/upload_board", "/files/upload_board/tempUploadFile");
			
			File file = new File(orgpDirPath);
			File file2 = new File(despPath);
			File file3 = new File(despPath.replace("s_", ""));
			
			if (file.exists() && !file2.exists()) {
				FileUtils.copyFile(file, file2);
				FileUtils.copyFile(file, file3);
			}
			
			sb.append("</ROW>");
		}
		
		sb.append("</DATA>");

		logger.debug("movieViewList ended");
		return sb.toString();
	}

	// 2024-09-30 조수빈 - 게시글 목록에서 첨부파일 바로 다운로드
	@RequestMapping(value = "/ezBoard/selectToDownloadFiles.do", method = RequestMethod.GET)
	public String selectToDownloadFiles(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("selectToDownloadFiles started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String boardID = request.getParameter("boardID") == null ? "" : request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		boolean readFlag = false;

		// 2024-10-04 조수빈 - 마이게시판, 승인 게시판에서 조회하는 경우를 위해 추가
		if ("".equals(boardID)) {
			List<BoardVO> applyUserList = ezBoardAdminService.checkApplyUser(userInfo.getCompanyID(), userInfo.getTenantId());

			for (BoardVO vo: applyUserList) {
				if (vo.getApprUserId().toLowerCase().indexOf(userInfo.getId().toLowerCase()) > -1) {
					readFlag = true;
				}
			}
		}

		if (null != boardID && !"".equals(boardID)) {
			readFlag = accessCheck(boardID, itemID, null, userInfo, "");
		}

		if (!readFlag) {
			return "main/warning";
		}

		model.addAttribute("attachList", ezBoardService.brdGetItemAttachmentInfo(itemID, userInfo.getTenantId()));

		logger.debug("selectToDownloadFiles ended");
		return "/ezBoard/selectToDownloadFiles";
	}
	
	/**
	 * 게시판 최근게시물 리스트 표출 Method
	 */
	public String getAllNewItemList(BoardVO boardVO, LoginVO userInfo) throws Exception {
		logger.debug("getAllNewItemList started");

		String orderOption1 = "";
		String orderOption2 = "";
		String strMultiData = commonUtil.getMultiData(boardVO.getLang(), userInfo.getTenantId());
		String anonyMsg = "";

		BoardListVO boardListVO = new BoardListVO();

		List<BoardListHeaderVO> headerList = ezBoardService.getListHeader(userInfo, boardVO);

		int i = 0;
		int hlength = headerList.size();
		Map<String, String> orderByMap = new HashMap<String, String>();
		
		for (i = 0; i < hlength; i++) {
			if (boardVO.getOrderCell() != null && !boardVO.getOrderCell().equals("") && boardVO.getOrderCell().equals(headerList.get(i).getName())) {
				orderByMap.put("orderByCol", headerList.get(i).getColName().toUpperCase());
				if (boardVO.getOrderOption().equals("")) {
					orderByMap.put("orderByColDesc", "N");
					if (headerList.get(i).getName().indexOf("BOARDNAME") > -1) {
						orderOption1 = headerList.get(i).getColName().replace("BOARDNAME", "B.BOARDNAME") + " ";
					} else {
						orderOption1 = headerList.get(i).getColName() + " ";
					}
				} else {
					orderByMap.put("orderByColDesc", "Y");
					if (headerList.get(i).getColName().indexOf("BOARDNAME") > -1) {
						orderOption1 = headerList.get(i).getColName().replace("BOARDNAME", "B.BOARDNAME") + " DESC ";
					} else {
						orderOption1 = headerList.get(i).getColName() + " DESC ";
					}
				}
			}
		}

		String fieldName = "";
		String fieldValue = "";

		BoardConfigVO boardConfigVO = ezBoardService.getPersonalCount(userInfo);

		// 새게시물 카운트 시 companyID 조건 추가
		int boardCount = ezBoardService.getAllNewItemListCount(userInfo);
		int startRow = 1;
		int endRow = 0;
		int personalCount_ = boardConfigVO.getListCount();

		boardConfigVO.setPageCnt(boardCount);
		boardConfigVO.setTotalCnt(boardCount);

		startRow = (personalCount_ * (boardVO.getPageNum() - 1)) + 1;
		endRow = (personalCount_ * boardVO.getPageNum());

		boardListVO.setUserID(userInfo.getId());
		boardListVO.setWriterCompanyID(userInfo.getCompanyID());
		boardListVO.setTenantID(userInfo.getTenantId());
		boardListVO.setStartRow(startRow);
		boardListVO.setEndRow(endRow);
		boardListVO.setTotalCount(boardCount);
		boardListVO.setOrderBySub(orderOption1);
		boardListVO.setOrderByMain(orderOption2);

		// 새게시물 표출 시 companyID 조건 추가
		List<HashMap<String, Object>> boardList = ezBoardService.getAllNewItemList(boardListVO, orderByMap);

		int dlength = boardList.size();
		StringBuffer resultXML = new StringBuffer();

		resultXML.append("<DOCLIST>");
		resultXML.append("<TOTALCNT>" + boardCount + "</TOTALCNT>");
		resultXML.append("<PAGECNT>" + boardCount + "</PAGECNT>");
		resultXML.append("<PERSONALCNT>" + personalCount_ + "</PERSONALCNT>");
		resultXML.append("<PREVIEWTYPE>" + boardConfigVO.getPreview() + "</PREVIEWTYPE>");
		resultXML.append("<PREVIEWWLIST>" + boardConfigVO.getPreviewWList() + "</PREVIEWWLIST>");
		resultXML.append("<PREVIEWWCONTENT>" + boardConfigVO.getPreviewWContent() + "</PREVIEWWCONTENT>");
		resultXML.append("<PREVIEWHLIST>" + boardConfigVO.getPreviewHList() + "</PREVIEWHLIST>");
		resultXML.append("<PREVIEWHCONTENT>" + boardConfigVO.getPreviewHContent() + "</PREVIEWHCONTENT>");
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");

		for (BoardListHeaderVO vo:headerList) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + vo.getName() + "</NAME>");
			resultXML.append("<WIDTH>" + vo.getWidth() + "</WIDTH>");
			resultXML.append("<COLNAME>" + vo.getColName() + "</COLNAME>");
			resultXML.append("</HEADER>");
		}

		resultXML.append("</HEADERS>");
		resultXML.append("<ROWS>");

		/* 2018-11-28 홍승비 - 새게시물 리스트의 익명게시물 부서칼럼 '익명'으로 표출 */
		anonyMsg = egovMessageSource.getMessage("ezBoard.t249", userInfo.getLocale()).split(";")[0];

		for (int j = 0; j < dlength; j++) {
			resultXML.append("<ROW>");

			/* 2019-08-02 홍승비 - 다국어 환경에서 부서명 '익명'처리되지 않는 오류 수정 */
			if (String.valueOf(boardList.get(j).get("GUBUN")).equals("2")) {
				boardList.get(j).replace("WRITERDEPTNAME", anonyMsg);
				boardList.get(j).replace("WRITERDEPTNAME2", anonyMsg);
			}

			for (i = 0; i < hlength; i++) {
				resultXML.append("<CELL>");
				fieldName = headerList.get(i).getColName().toUpperCase();

				if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME") || fieldName.equals("BOARDNAME")) {
					fieldName = fieldName + strMultiData;
				}
				if (fieldName.equals("WRITEDATE")) {
					fieldValue = commonUtil.getDateStringInUTC((String)boardList.get(j).get(fieldName), userInfo.getOffset(), false);
					fieldValue = fieldValue.substring(0, fieldValue.length()-3);
				} else {
					fieldValue = commonUtil.cleanValue(String.valueOf(boardList.get(j).get(fieldName)));
				}

				resultXML.append("<VALUE>" + fieldValue + "</VALUE>");

				if (i == 0) {
					resultXML.append("<DATA1>" + boardList.get(j).get("BOARDID") + "</DATA1>");
					resultXML.append("<DATA2>" + boardList.get(j).get("ITEMID") + "</DATA2>");
					resultXML.append("<DATA3>" + boardList.get(j).get("WRITERID") + "</DATA3>");
					resultXML.append("<DATA4>" + boardList.get(j).get("IMPORTANCE") + "</DATA4>");
					resultXML.append("<DATA5>1</DATA5>");
					resultXML.append("<DATA6>" + commonUtil.cleanValue((String)boardList.get(j).get("ABSTRACT")) + "</DATA6>");
					resultXML.append("<DATA7>N</DATA7>");
					resultXML.append("<DATA8>" + boardList.get(j).get("ITEMLEVEL") + "</DATA8>");
					resultXML.append("<DATA9>" + boardList.get(j).get("NOTICE") + "</DATA9>");
					resultXML.append("<DATA10>" + boardList.get(j).get("GUBUN") + "</DATA10>");
					resultXML.append("<DATA11>" + boardList.get(j).get("ONELINECNT") + "</DATA11>");

					if (globals.getProperty("Globals.DbType").equals("oracle")) {
						resultXML.append("<DATA12>" + commonUtil.cleanValue((String)boardList.get(j).get("TO_CHAR(MAINCONTENT)")) + "</DATA12>");
					} else if (globals.getProperty("Globals.DbType").equals("tibero")) {
						resultXML.append("<DATA12>" + commonUtil.cleanValue((String)boardList.get(j).get("TO_CHAR(MAINCONTENT)")) + "</DATA12>");
					} else {
						resultXML.append("<DATA12>" + commonUtil.cleanValue((String)boardList.get(j).get("MAINCONTENT")) + "</DATA12>");
					}

					resultXML.append("<TITLE>" + commonUtil.cleanValue((String)boardList.get(j).get("TITLE")) + "</TITLE>");
					/* 2019-07-04 홍승비 - 게시판 미독건수 읽음표시 처리용 boardGroupID 추가 */
					resultXML.append("<BOARDGROUPID>" + boardList.get(j).get("BOARDGROUPID") + "</BOARDGROUPID>");
					resultXML.append("<EXT>" +  commonUtil.cleanValue((String)boardList.get(j).get("EXT"))  + "</EXT>");
					resultXML.append("<FILEPATH>" +  commonUtil.cleanValue((String)boardList.get(j).get("FILEPATH"))  + "</FILEPATH>");
					resultXML.append("<ITEMREAD_FG>" + (accessCheck((String)boardList.get(j).get("BOARDID"), (String)boardList.get(j).get("ITEMID"),
							"GENERAL", userInfo, "") ? "Y" : "N") + "</ITEMREAD_FG>");
				}
				resultXML.append("</CELL>");
			}
			resultXML.append("</ROW>");
		}
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		resultXML.append("</DOCLIST>");

		logger.debug("getAllNewItemList ended");
		return resultXML.toString();
	}
	
	@Transactional
	@RequestMapping(value = "/ezBoard/saveItemStarRating.do", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> saveItemStarRating(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("saveItemStarRating started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String itemID = request.getParameter("itemID");
		int updateRating = Integer.parseInt(request.getParameter("updateRating"));
		String isReRated = request.getParameter("isReRated");

		Map<String, Object> result = new HashMap<>();
		
		try {
			Map<String, Object> resultData = ezBoardService.saveItemStarRating(itemID, isReRated, updateRating, userInfo);
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
	 * 식단 조회 화면 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/mealPlanView.do", method = RequestMethod.GET)
	public String mealPlanView(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, String selectDate) throws Exception {
		logger.debug("mealPlanView started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("isAdmin", getBoardInfo("{MMMMMMMM-MMMM-MMMM-MMMM-MMMMMMMMMMMM}", userInfo).getBoardAdmin_FG());
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("selectDate", (null != selectDate && !"".equals(selectDate)) ? selectDate : "");
		
		logger.debug("mealPlanView ended");
		return "ezBoard/mealPlanView";
	}
	
	/**
	 * 식단 데이터 반환 Method
	 */
	@RequestMapping(value = "/ezBoard/getMealPlanList.do", method = RequestMethod.POST)
	public String getMealPlanList(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, String startDate) throws Exception {
		logger.debug("getMealPlanList started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		Map<String, Object> map = new HashMap<>();
		map.put("startDate", startDate);
		map.put("companyID", userInfo.getCompanyID());
		map.put("tenantID", userInfo.getTenantId());
		
		List<MealDataVO> mealDataList = ezBoardService.getMealPlanList(map);
		
		model.addAttribute("mealDataList", mealDataList);
		
		logger.debug("getMealPlanList ended");
		return "json";
	}
	
	/**
	 * 식단 작성 화면 표출 Method
	 */
	@RequestMapping(value = "/ezBoard/mealPlanWrite.do", method = RequestMethod.POST)
	public String mealPlanWrite(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo, String startDate, String selectDate) throws Exception {
		logger.debug("mealPlanWrite started");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		if (!"true".equalsIgnoreCase(getBoardInfo("{MMMMMMMM-MMMM-MMMM-MMMM-MMMMMMMMMMMM}", userInfo).getBoardAdmin_FG())) {
			return "main/error";
		}
		
		model.addAttribute("startDate", startDate);
		model.addAttribute("selectDate", selectDate);
		model.addAttribute("companyID", userInfo.getCompanyID());
		model.addAttribute("tenantID", userInfo.getTenantId());
		
		logger.debug("mealPlanWrite ended");
		return "ezBoard/mealPlanWrite";
	}
	
	/**
	 * 식단 데이터 저장 Method
	 */
	@RequestMapping(value = "/ezBoard/saveMealPlan.do", method = RequestMethod.POST)
	public String saveMealPlan(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("saveMealPlan started");
		
		ObjectMapper om = new ObjectMapper();
		
		userInfo = commonUtil.userInfo(loginCookie);
		List<MealDataVO> mealInputList = om.readValue(request.getParameter("mealInputList"), new TypeReference<List<MealDataVO>>() {});
		
		if (!"true".equalsIgnoreCase(getBoardInfo("{MMMMMMMM-MMMM-MMMM-MMMM-MMMMMMMMMMMM}", userInfo).getBoardAdmin_FG())) {
			return "main/error";
		}
		
		String result = ezBoardService.saveMealPlan(mealInputList);
		
		model.addAttribute("result", result);
		
		logger.debug("saveMealPlan ended");
		return "json";
	}

	/**
	 * 협업 연계 - 오늘의 식단
	 */
	@CrossOrigin(origins = "*")
	@GetMapping(value = "/rest/MenuSchedule", produces = "application/json;charset=utf-8")
	@ResponseBody
	@SuppressWarnings("unchecked")
	public JSONObject restMenuList(HttpServletRequest request) {
		logger.debug("restMenuList started");
		
		org.json.simple.JSONObject returnJson = new org.json.simple.JSONObject();
		String companyID = request.getParameter("companyID");
		String date = request.getParameter("date");
		int tenantID = Integer.parseInt(request.getParameter("tenantID"));
		
		Map<String, Object> map = new HashMap<>();
		map.put("companyID", companyID);
		map.put("date", date);
		map.put("tenantID", tenantID);

		try {
			// 식단 사용 여부 확인
			if (!"YES".equals(ezCommonService.getTenantConfig("useMealPlan", tenantID))) {
				logger.error("restMenuList error : MealPlan not used.");
				
				returnJson.put("RTNVALUE", "NOT_USED");
				
				logger.debug("restMenuList result : " + returnJson);
				logger.debug("restMenuList ended");
				
				return returnJson;
			}
			
			returnJson = ezBoardService.getMenuSchedule(map, returnJson);
		} catch (Exception e) {
			logger.error("restMenuList exception : " + e.getMessage());
			returnJson.put("RTNVALUE", "CODE_ERROR");
		}

		logger.debug("restMenuList result : " + returnJson);
		logger.debug("restMenuList ended");
		
		return returnJson;
	}

	/**
	 * 게시판 > 게시글보기 > 재게시 실행
	 */
	@RequestMapping(value = "/ezBoard/repostItem.do", method = RequestMethod.POST, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String repostItem(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		logger.debug("repostItem started");

		userInfo = commonUtil.userInfo(loginCookie);

		int tenantID = userInfo.getTenantId();

		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		String userID = request.getParameter("userID");
		String hasReply = request.getParameter("hasReply");

		ezBoardService.repostItem(boardID, itemID, userID, tenantID, hasReply);

		logger.debug("rePostItem ended, userID = " + userInfo.getId());

		return "SUCCESS";
	}

	@GetMapping("/ezBoard/modifyHistory")
	public String modifyHistory(@CookieValue("loginCookie")String loginCookie, HttpServletRequest request, LoginVO userInfo, Model model) throws Exception {
		logger.info("modifiyHistory started");

		userInfo = commonUtil.userInfo(loginCookie);

		String boardID = request.getParameter("boardID");
		String itemID = request.getParameter("itemID");
		String companyID = userInfo.getCompanyID();
		int tenantID = userInfo.getTenantId();

		BoardListVO itemInfo = ezBoardService.getItemInfo("", itemID, userInfo.getLang(), tenantID);
		itemInfo.setWriteDate(commonUtil.getDateStringInUTC(itemInfo.getWriteDate(), userInfo.getOffset(), false));
		model.addAttribute("itemInfo", itemInfo);
		model.addAttribute("endDate", itemInfo.getEndDate() != null && itemInfo.getEndDate().substring(0, 4).equals("9999") ? "영구게시" : itemInfo.getEndDate());
		model.addAttribute("history", ezBoardService.getModifiedHistoryOfItem(boardID, userInfo.getOffset(), itemID, companyID, tenantID));

		logger.info("modifiyHistory ended");
		return "ezBoard/modifyHistory";
	}

	@RequestMapping(value = {"/ezBoard/getBoardTitle.do"}, produces = "text/plain; charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getBoardTitle(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getBoardTitle started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String contentLocation = request.getParameter("href");

		logger.debug("getBoardTitle ended.");
		return ezBoardService.getBoardTitle(contentLocation, userInfo.getTenantId());
	}
}
