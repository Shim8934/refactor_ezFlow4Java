package egovframework.ezEKP.ezMemo.web;

import java.net.URLDecoder;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.utl.fcc.service.CommonUtil;

/** 
 * @Description [Controller] 메모
 * @author 솔루션3팀 황윤호, 이석화, 김민성
 * @Modification Information
 *
 *    수정일       		수정자         				수정내용
 *    ----------    --------------    	-------------------
 *    2018.08.14	황윤호, 이석화, 김민성		신규작성
 *
 * @see
 */

@Controller
public class EzMemoController {
	private static final Logger logger = LoggerFactory.getLogger(EzMemoController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	/**
	 * 메모 메인페이지 호출
	 * */
	@RequestMapping(value = "/ezMemo/memoMainPage.do", method = RequestMethod.GET)
	public String memoMainPage(@CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("memoMainPage started.");

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
		
		logger.debug("memoMainPage ended");
		return "ezMemo/memoMainPage";
	}
	
	/**
	 * 메모 메인페이지 호출
	 * */
	@RequestMapping(value = "/ezMemo/memoConfig.do", method = RequestMethod.GET)
	public String memoConfig(@CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("memoConfig started.");
		
		logger.debug("memoConfig ended");
		return "ezMemo/memoConfig";
	}
	
	/**
	 * 메모 레프트 메뉴 호출
	 * */
	@RequestMapping(value = "/ezMemo/memoLeft.do", method = RequestMethod.GET)
	public String memoLeft(@CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("memoLeft started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/folders/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {		
			JSONArray folders = (JSONArray) resultBody.get("data");
			model.addAttribute("folders", folders);
		}
		
		logger.debug("memoLeft ended");
		return "ezMemo/memoLeft";
	}
	
	/**
	 * 메모 리스트 페이지 호출
	 * */
	@RequestMapping(value = "/ezMemo/memoMain.do", method = RequestMethod.GET)
	public String memoMain(@CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("memoMain started.");
		
		// String brdID = "8";
		String folderId = "0"; 
		String folderName = egovMessageSource.getMessage("ezMemo.t001"); 
		String configView = "false";
		
		/* if (request.getParameter("brdID") != null) {
			brdID = request.getParameter("brdID");
		} */
		
		if (request.getParameter("folderId") != null) {
			folderId = request.getParameter("folderId");
		}
		
		if (request.getParameter("folderName") != null) {
			folderName = URLDecoder.decode(request.getParameter("folderName"), "utf-8");
		}
		
		if (request.getParameter("configView") != null) {
			configView = request.getParameter("configView");
		}
		
		model.addAttribute("folderId", folderId);
		model.addAttribute("folderName", folderName);
		model.addAttribute("configView", configView);
		
		logger.debug("memoMain ended");
		return "ezMemo/memoMain";
	}
	
	/**
	 * 메모 리스트 호출 method
	 * @param loginCookie
	 * @param modelMap
	 * @param request
	 * @param model
	 * @param layerFlag
	 * @param searchInput
	 * @param startDate
	 * @param endDate
	 * @param folderId
	 * @param orderOption
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezMemo/getMemoList.do", method = RequestMethod.POST)
	public String getMemoList(String layerFlag, String searchInput, String startDate, String endDate, String folderId, String orderOption, @CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getMemoList started.");

		searchInput = searchInput != null ? searchInput : "";		// 검색 사용 시 검색 단어
		startDate = startDate != null ? startDate : "";				// 검색 사용 시 시작일
		endDate = endDate != null ? endDate : "";					// 검색 사용 시 종료일
		folderId = folderId != null ? folderId : "0";					// 메모함 선택
		orderOption = orderOption != null ? orderOption : "1";	// 리스트설정(order, new, old)
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		logger.debug("searchInput : " + searchInput + ", startDate : " + startDate + ", endDate : " + endDate + ", folderId : " + folderId + ", orderOption : " + orderOption);
		logger.debug("userId : " + userInfo.getId() + ", tenantId : " + userInfo.getTenantId());
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId",userInfo.getId());
		param.put("searchInput", searchInput);
		param.put("startDate", startDate);
		param.put("endDate", endDate);
		param.put("folder_id", folderId);
		param.put("tenant_id", userInfo.getTenantId());
		param.put("offset", userInfo.getOffset());
		param.put("orderOption", orderOption);

		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/memo-list/users/" + userInfo.getId(), param, request, "get", null);		
		
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {		
			model.addAttribute("status", "ok");
			JSONArray memoList = (JSONArray) resultBody.get("memoList");
				
			model.addAttribute("memoList", memoList);
				
			if (layerFlag != null) {
				model.addAttribute("layerFlag", layerFlag);
			}
		}
		
		logger.debug("getMemoList ended");
		return "json";
	}
	
	/**
	 * 메모분류함 리스트 호출 method
	 * @param loginCookie
	 * @param modelMap
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezMemo/getMemoFoldersInfo.do", method = RequestMethod.GET)
	public String memoFoldersInfo(@CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("memoFoldersInfo started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/folders/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBody.get("status").toString();
		String memoCount = resultBody.get("memoCount").toString();
		
		if (status.equals("ok")) {
			model.addAttribute("status", "ok");
			JSONArray folders = (JSONArray) resultBody.get("data");
			model.addAttribute("folders", folders);
			model.addAttribute("memoCount", memoCount);
		}
			
		logger.debug("memoFoldersInfo ended");
		return "json";
	}
	
	/**
	 * 메모분류함 이동 화면 호출 method
	 * @param loginCookie
	 * @param modelMap
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezMemo/memoFolderManage.do", method = RequestMethod.GET)
	public String memoFolderManage(@CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("memoFolderManage started");
		logger.debug("memoFolderManage ended");
		return "ezMemo/memoFolderManage";
	}
	
	/**
	 * 메모분류함 추가/수정 화면 호출 method
	 * @param loginCookie
	 * @param modelMap
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezMemo/memoInputName.do", method = RequestMethod.GET)
	public String memoInputName(@CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("memoInputName started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/folders/names/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {	
			model.addAttribute("status", "ok");
			String folderNameList = resultBody.get("data").toString();
			model.addAttribute("folderNameList", folderNameList);
		}
		logger.debug("memoInputName ended");
		return "ezMemo/memoInputName";

	}
	
	/**
	 * 메모 추가  method
	 * @param loginCookie
	 * @param modelMap
	 * @param request
	 * @param model
	 * @param layerFlag
	 * @param folderId
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezMemo/memoWrite.do", method = RequestMethod.POST)
	public String memoWrite(String layerFlag, String folderId, @CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("memoWrite started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String regDate = commonUtil.getTodayUTCTime("");
		
		folderId = request.getParameter("folderId");
		
		// 2020-11-10 김민성 - folderId 오버플로우 처리
		if(!commonUtil.isIntNumber(folderId)) {
			logger.debug("This foloderId is invalid.");	
			folderId = "0";
		}
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("tenant_id", userInfo.getTenantId());
		param.put("folder_id", folderId);
		param.put("write_date", regDate);
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/memo-list/" + folderId + "/memo/" + userInfo.getId(), param, request, "post", null);		
		
		String status = resultBody.get("status").toString();

		logger.debug("memoWrite ended");	
		
		if (status.equals("ok")) {	
			model.addAttribute("status", "ok");
			JSONObject memo = (JSONObject) resultBody.get("memo");
			model.addAttribute("memo", memo);
			if (layerFlag != null) {
				model.addAttribute("layerFlag", commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(layerFlag)));
			}
			return "json";
		}
		else {
			return "error";
		}
	}
	
	/**
	 * 메모 수정  method
	 * @param loginCookie
	 * @param modelMap
	 * @param request
	 * @param model
	 * @param memoId
	 * @param contents
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezMemo/memoModify.do", method = RequestMethod.POST)
	public String memoModify(String memoId, String contents, @CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("memoModify started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String regDate = commonUtil.getTodayUTCTime("");
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId",userInfo.getId());
		param.put("tenant_id", userInfo.getTenantId());
		param.put("memo_id", memoId);
		param.put("write_date", regDate);
		
		JSONObject jsonParam = new JSONObject();
		jsonParam.put("contents", contents);
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/memo-list/memo/" + memoId, param, request, "post", jsonParam);		
		
		String status = resultBody.get("status").toString();
		
		logger.debug("memoModify ended.");
		
		if (status.equals("ok")) {	
			model.addAttribute("status", "ok");
			return "json";
		}
		else {
			return "error";
		}
	}

	/**
	 * 메모 상세조회 method
	 * @param memoId
	 * @param loginCookie
	 * @param modelMap
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	/* 요청하는 데가 없어서 주석처리
	@RequestMapping(value = "/ezMemo/memoRead.do", method = RequestMethod.GET)
	public String memoRead(String memoId, @CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("memoRead started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("tenant_id", userInfo.getTenantId());
		param.put("user_id",userInfo.getId());
		param.put("memoId", memoId);
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/memo-detail/memo/" + memoId + "/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBody.get("status").toString();

		if ("ok".equals(status)) {
			model.addAttribute("status", "ok");
			model.addAttribute("memo", resultBody.get("data"));
		}
		
		logger.debug("memoRead ended.");
		return "ezMemo/memoRead";
	}
	*/
	/**
	 * 메모분류함 생성, 수정, 삭제 method
	 * @param loginCookie
	 * @param modelMap
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezMemo/memoFolderAction.do", method = RequestMethod.POST)
	public String memoFolderAction(@CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, Model model, String methodType, String folder_id) throws Exception {
		logger.debug("memoFolderAction started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		HashMap<String, Object> param = new HashMap<String, Object>();

		if (request.getParameter("folder_ids") != null) {	// 삭제
			param.put("folder_ids", request.getParameter("folder_ids"));
		}
		if (request.getParameter("folder_name") != null) {	// 수정
			param.put("folder_name", request.getParameter("folder_name"));
		}
		if (request.getParameter("folder_id") != null) {	// 추가, 수정
			param.put("folder_id", request.getParameter("folder_id"));
		}
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/folders/users/" + userInfo.getId(), param, request, methodType, null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {			
			model.addAttribute("status", status);
		}
		logger.debug("memoFolderAction ended.");
		return "json";
	}

	/**
	 * 레이어 높이, 넓이 정보 변경 method
	 * @param loginCookie
	 * @param request
	 * @param layerWidth
	 * @param layerHeight
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezMemo/setLayerArea.do", method = RequestMethod.POST)
	public String setLayerArea(@CookieValue("loginCookie") String loginCookie,  String layerWidth, String layerHeight, HttpServletRequest request, Model model) throws Exception {
		logger.debug("setLayerArea started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();

		int width = Integer.parseInt(layerWidth);
		int height = Integer.parseInt(layerHeight);
		
		param.put("layer_width", width);
		param.put("layer_height", height);
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/setLayerArea/users/" + userInfo.getId(), param, request, "put", null);
		String status = resultBody.get("status").toString();
		if (status.equals("ok")) {
			model.addAttribute("status", "ok");
		}
		logger.debug("setLayerArea ended");
		return "json";
	}
	
	/**
	 * 레이어 top, left 정보 변경 method
	 * @param loginCookie
	 * @param request
	 * @param layerTop
	 * @param layerLeft
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezMemo/setLayerPosition.do", method = RequestMethod.POST)
	public String setLayerPosition(@CookieValue("loginCookie") String loginCookie,  String layerTop, String layerLeft, HttpServletRequest request, Model model) throws Exception {
		logger.debug("setLayerPosition started");

		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		int topPositon = Integer.parseInt(layerTop);
		int leftPosition = Integer.parseInt(layerLeft);

		param.put("layer_top", topPositon);
		param.put("layer_left", leftPosition);
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/setLayerPosition/users/" + userInfo.getId(), param, request, "put", null);
		String status = resultBody.get("status").toString();
		if (status.equals("ok")) {
			model.addAttribute("status", "ok");
		}
		
		logger.debug("setLayerPosition ended");
		return "json";
	}
	
	/**
	 * 메모 설정 정보 호출 method
	 * @param loginCookie
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezMemo/getMemoConfig.do", method = RequestMethod.GET)
	public String getMemoConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getMemoConfig started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/getMemoConfig/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if ("ok".equals(status)) {
			model.addAttribute("status", "ok");
			JSONObject memoConfigVO = (JSONObject) resultBody.get("data");
			model.addAttribute("memoConfigVO", memoConfigVO);
			
		} 
		
		logger.debug("getMemoConfig ended");
		return "json";
	}
	
	/**
	 * 메모 설정 정보 추가 method
	 * @param loginCookie
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezMemo/insertMemoConfig.do", method = RequestMethod.POST)
	public String insertMemoConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("insertMemoConfig started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		param.put("font_size", 14);
		param.put("use_date", 1);
		param.put("use_gadget", 1);
		param.put("default_color", 1);
		param.put("gadget_right", 15);
		param.put("gadget_bottom", 15);
		param.put("layer_left", 0);
		param.put("layer_top", 56);
		param.put("layer_width", 340);
		param.put("layer_height", 380);
		param.put("fold_status", 1);
		param.put("full_mode", 1);
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/createMemoConfig/users/" + userInfo.getId(), param, request, "post", null);
		@SuppressWarnings("unused")
		String status = resultBody.get("status").toString();
		
		logger.debug("insertMemoConfig ended");
		return "json";
	}
	
	/**
	 * 메모분류함 존재 유무 확인 method
	 * @param loginCookie
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezMemo/hasMemoFolder.do", method = RequestMethod.GET)
	public String hasMemoFolder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("hasMemoFodler started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/folders/check/locale/" + userInfo.getLocale() + "/users/" +userInfo.getId(), param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if ("ok".equals(status)) {
			model.addAttribute("result", "ok");
		}
		
		logger.debug("hasMemoFodler ended");
		return "json";
	}
	
	/**
	 * 메모 상태 변경 method
	 * @param loginCookie
	 * @param request
	 * @param model
	 * @param memo_ids
	 * @param display
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezMemo/memo-display.do", method = RequestMethod.POST)
	public String setMemoDisplay(@CookieValue("loginCookie") String loginCookie, String memo_ids, String display, HttpServletRequest request, Model model) throws Exception{
		logger.debug("setMemoDisplay start");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("memo_ids", memo_ids);
		param.put("display", display);
	
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/memo-display/memo/" + memo_ids + "/users/" + userInfo.getId(), param, request, "post", null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			model.addAttribute("result", "ok");
		}
		
		logger.debug("setMemoDisplay ended");
		return "json";
	}

	/**
	 * 메모 상세 정보 호출 method
	 * @param loginCookie
	 * @param request
	 * @param model
	 * @param memoId
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezMemo/memoDetail.do", method = RequestMethod.GET)
	public String getMemoDetail(@CookieValue("loginCookie") String loginCookie, int memoId, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getMemoDetail started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("memoId", memoId);
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/memo-detail/memo/" + memoId + "/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBody.get("status").toString();

		if ("ok".equals(status)) {
			model.addAttribute("memo", resultBody.get("data"));
		}
		
		logger.debug("getMemoDetail ended");
		return "json";
	}

	/**
	 * 메모분류함 이동 수행 method
	 * @param loginCookie
	 * @param request
	 * @param model
	 * @param folder_id
	 * @param memo_ids
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezMemo/memoMove.do", method = RequestMethod.GET)
	public String memoMove(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, String folder_id, String memo_ids) throws Exception{
		logger.debug("memoMove started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("folder_id", folder_id);
		param.put("memo_ids", memo_ids);
	
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/move/folder/" + folder_id + "/users/" + userInfo.getId(), param, request, "put", null);
		String status = resultBody.get("status").toString();
		
		if ("ok".equals(status)) {
			model.addAttribute("result", "ok");
		}
		
		logger.debug("memoMove ended");
		return "json";
	}
	
	/**
	 * 메모 삭제 method
	 * @param loginCookie
	 * @param request
	 * @param model
	 * @param memo_ids
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezMemo/memoDelete.do", method = RequestMethod.POST)
	public String memoDelete(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, String memo_ids) throws Exception{
		logger.debug("memoDelete started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String regDate = commonUtil.getTodayUTCTime("");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("memo_ids", memo_ids);
		param.put("userId", userInfo.getId());
		param.put("delete_date", regDate);
	
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/memo-list/memo/" + memo_ids, param, request, "delete", null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			model.addAttribute("result", "ok");
		}
		
		logger.debug("memoDelete ended");
		return "json";
	}
	
	/** 사용하지 않는 기능
	 * 다른 모듈에서 메모 추가
	 * @param loginCookie
	 * @param request
	 * @param model
	 * @param contents
	 * @return
	 * @throws Exception
	 */
	/*
	@RequestMapping(value = "/ezMemo/otherModuleCopy.do", method = RequestMethod.POST)
	public String otherModuleCopy(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, String contents) throws Exception {
		logger.debug("otherModuleCopy started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("contents", contents);
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/moduleCopy/users/" + userInfo.getId(), param, request, "post", null);
		String status = resultBody.get("status").toString();
		
		if(status.equals("ok")){
			model.addAttribute("result", "ok");
		}
		
		logger.debug("otherModuleCopy ended");
		return "json";
	}
	*/
	/**
	 * 메모 색상 변경 method
	 * @param loginCookie
	 * @param request
	 * @param model
	 * @param memoId
	 * @param colorId
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezMemo/memoColorModify.do", method = RequestMethod.POST)
	public String setMemoColor(@CookieValue("loginCookie") String loginCookie, String memoId, String colorId, HttpServletRequest request, Model model) throws Exception{
		logger.debug("setMemoColor start");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		param.put("memo_id", memoId);
		param.put("userId", userInfo.getId());
		param.put("color_id", colorId);
	
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/memo-color/memo/" + memoId + "/users/" + userInfo.getId(), param, request, "put", null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			model.addAttribute("result", "ok");
		}
		
		logger.debug("setMemoColor end");
		return "json";
	}
	
	/**
	 * 메모 순서 변경 method
	 * @param loginCookie
	 * @param request
	 * @param model
	 * @param draggedElId
	 * @param compareElId
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezMemo/reOrder.do", method = RequestMethod.POST)
	public String reOrder(@CookieValue("loginCookie") String loginCookie, String draggedElId, String compareElId, HttpServletRequest request, Model model) throws Exception {
		logger.debug("reOrder started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("draggedElId", draggedElId);
		param.put("compareElId", compareElId);
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/memo-order/draggedElId/" + draggedElId + "/compareElId/" + compareElId + "/users/" + userInfo.getId(), param, request, "put", null);
		String status = resultBody.get("status").toString();
		
		if ("ok".equals(status)) {
			model.addAttribute("status", "ok");
		}
		logger.debug("reOrder ended");
		return "json";
	}
	
	/**
	 * 퀵메모 right, bottom 정보 변경 method
	 * @param loginCookie
	 * @param request
	 * @param layerTop
	 * @param layerLeft
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezMemo/setGadgetPosition.do", method = RequestMethod.POST)
	public String setGadgetPosition(@CookieValue("loginCookie") String loginCookie,  String gadgetBottom, String gadgetRight, HttpServletRequest request, Model model) throws Exception {
		logger.debug("setGadgetPosition started");

		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		int bottomPositon = (int)Double.parseDouble(gadgetBottom);
		int rightPosition = (int)Double.parseDouble(gadgetRight);
		
		param.put("gadget_bottom", bottomPositon);
		param.put("gadget_right", rightPosition);
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/setGadgetPosition/users/" + userInfo.getId(), param, request, "put", null);
		String status = resultBody.get("status").toString();
		
		if ("ok".equals(status)) {
			model.addAttribute("status", "ok");
		}
		logger.debug("setGadgetPosition ended");
		return "json";
	}
	
	/**
	 * 메모 레이어모드 창모드/전체 모드 저장
	 * @param loginCookie
	 * @param full_mode
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezMemo/setMemoLayerMode.do", method = RequestMethod.POST)
	public String setMemoLayerMode(@CookieValue("loginCookie") String loginCookie, String full_mode, HttpServletRequest request, Model model) throws Exception {
		logger.debug("setMemoLayerMode started");
		
		// 2020-11-10 김민성 - folderId 오버플로우 처리
		if(!commonUtil.isIntNumber(full_mode)) {
			logger.debug("This number is invalid.");	
			full_mode = "0";
		}
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("full_mode", full_mode);
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/setMemoLayerMode/users/" + userInfo.getId(), param, request, "put", null);
		String status = resultBody.get("status").toString();
		
		if ("ok".equals(status)) {
			model.addAttribute("status", "ok");
		}
		logger.debug("setMemoLayerMode ended");
		return "json";
	}
	
	/**
	 * 큰 메모의 넓이 정보 변경 method
	 * @param loginCookie
	 * @param request
	 * @param layerTop
	 * @param layerLeft
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezMemo/setDetailMemoArea.do", method = RequestMethod.POST)
	public String setDetailMemoArea(@CookieValue("loginCookie") String loginCookie,  int bigHeight, int bigWidth, HttpServletRequest request, Model model) throws Exception {
		logger.debug("setDetailMemoArea started");

		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		param.put("b_memo_height", bigHeight);
		param.put("b_memo_width", bigWidth);
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/setDetailMemoArea/users/" + userInfo.getId(), param, request, "put", null);
		String status = resultBody.get("status").toString();
		
		if ("ok".equals(status)) {
			model.addAttribute("status", "ok");
		}
		logger.debug("setDetailMemoArea ended");
		return "json";
	}
	
	/**
	 * 큰 메모의 위치 정보 변경 method
	 * @param loginCookie
	 * @param request
	 * @param layerTop
	 * @param layerLeft
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezMemo/setDetailMemoPosition.do", method = RequestMethod.POST)
	public String setDetailMemoPosition(@CookieValue("loginCookie") String loginCookie,  int bigTop, int bigLeft, HttpServletRequest request, Model model) throws Exception {
		logger.debug("setDetailMemoPosition started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		param.put("b_memo_top", bigTop);
		param.put("b_memo_left", bigLeft);
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/setDetailMemoPosition/users/" + userInfo.getId(), param, request, "put", null);
		String status = resultBody.get("status").toString();

		if ("ok".equals(status)) {
			model.addAttribute("status", "ok");
		}
		logger.debug("setDetailMemoPosition ended");
		return "json";
	}
	
	/**
	 * 큰 메모의 열림 상태 정보 변경 method
	 * @param loginCookie
	 * @param request
	 * @param layerTop
	 * @param layerLeft
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezMemo/setDetailMemoStatus.do", method = RequestMethod.POST)
	public String setDetailMemoStatus(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("setDetailMemoStatus started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		if(request.getParameter("memoId") == null || request.getParameter("openStatus") == null) {
			return "";
		}
		
		int memoId = Integer.parseInt(request.getParameter("memoId"));
		int openStatus = Integer.parseInt(request.getParameter("openStatus"));
		
		if (memoId > 0) {
			param.put("memo_id", memoId);
		}
		param.put("b_memo_status", openStatus);
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/setDetailMemoStatus/users/" + userInfo.getId(), param, request, "put", null);
		String status = resultBody.get("status").toString();

		if ("ok".equals(status)) {
			model.addAttribute("status", "ok");
		}
		logger.debug("setDetailMemoStatus ended");
		return "json";
	}
	
}
