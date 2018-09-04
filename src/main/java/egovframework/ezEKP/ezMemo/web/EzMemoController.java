package egovframework.ezEKP.ezMemo.web;

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
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
	
	@Autowired
	private Properties config;
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	private SimpMessagingTemplate template;
	
	/**
	 * 메모 호출
	 * */
	@RequestMapping(value = "/ezMemo/memoMain.do")
	public String memoMain(@CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("memoMain started.");
		
		String brdID = "8";
		
		if (request.getParameter("brdID") != null) {
			brdID = request.getParameter("brdID");
		}
		
		model.addAttribute("folderId", "0");
		
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
	@RequestMapping(value = "/ezMemo/getMemoList.do")
	public String getMemoList(String layerFlag, String searchInput, String startDate, String endDate, String folderId, String orderOption, @CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getMemoList started.");

		searchInput = searchInput != null ? searchInput : "";		// 검색 사용 시 검색 단어
		startDate = startDate != null ? startDate : "";				// 검색 사용 시 시작일
		endDate = endDate != null ? endDate : "";					// 검색 사용 시 종료일
		folderId = folderId != null ? folderId : "0";					// 메모함 선택
		orderOption = orderOption != null ? orderOption : "1";	// 리스트설정(order, new, old)
		
		logger.debug("searchInput : " + searchInput + ", startDate : " + startDate + ", endDate : " + endDate + ", folderId : " + folderId + ", orderOption : " + orderOption);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		logger.debug("userId : " + userInfo.getId() + ", CompanyId : " + userInfo.getCompanyID() + ", tenantId : " + userInfo.getTenantId());
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("company_id",userInfo.getCompanyID());
		param.put("user_id",userInfo.getId());
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
				JSONArray memoList = (JSONArray) resultBody.get("memoList");
				String colorList = resultBody.get("colorList").toString();
				//folderId = resultBody.get("folderId").toString();
				
				model.addAttribute("memoList", memoList);
				model.addAttribute("colorList", colorList);
				//model.addAttribute("folderId", folderId);
				
				if (layerFlag != null) {
					model.addAttribute("layerFlag", layerFlag);
				}
		}
		
		logger.debug("getMemoList ended");
		return "json";
	}
	
	/**
	 * 메모븐류함 리스트 호출 method
	 * @param loginCookie
	 * @param modelMap
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezMemo/getMemoFoldersInfo.do")
	public String memoFoldersInfo(@CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("memoFoldersInfo started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/folders/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBody.get("status").toString();
		String memoCount = resultBody.get("memoCount").toString();
		
		if (status.equals("ok")) {		
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
	@RequestMapping(value = "/ezMemo/memoFolderManage.do")
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
	@RequestMapping(value = "/ezMemo/memoInputName.do")
	public String memoInputName(@CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("memoInputName started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/folders/names/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {			
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
	@RequestMapping(value = "/ezMemo/memoWrite.do")
	public String memoWrite(String layerFlag, String folderId, @CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("memoWrite started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String regDate = commonUtil.getTodayUTCTime("");
		
		folderId = request.getParameter("folderId");
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("company_id",userInfo.getCompanyID());
		param.put("user_id",userInfo.getId());
		param.put("tenant_id", userInfo.getTenantId());
		
		param.put("folder_id", folderId);
		param.put("write_date", regDate);
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/memo-list/" + folderId + "/memo/" + userInfo.getId(), param, request, "post", null);		
		
		String status = resultBody.get("status").toString();

		logger.debug("memoWrite ended");	
		
		if (status.equals("ok")) {		
			int memoId = Integer.parseInt(resultBody.get("memoId").toString());
			model.addAttribute("memoId", memoId);
			if (layerFlag != null) {
				model.addAttribute("layerFlag", layerFlag);
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
	@RequestMapping(value = "/ezMemo/memoModify.do")
	public String memoModify(String memoId, String contents, @CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("memoModify started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String regDate = commonUtil.getTodayUTCTime("");
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("company_id",userInfo.getCompanyID());
		param.put("user_id",userInfo.getId());
		param.put("tenant_id", userInfo.getTenantId());
		param.put("memo_id", memoId);
		param.put("write_date", regDate);
		param.put("contents", contents);
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/memo-list/memo/" + memoId, param, request, "put", null);		
		
		String status = resultBody.get("status").toString();
		
		logger.debug("memoModify ended.");
		
		if (status.equals("ok")) {		
			return "json";
		}
		else {
			return "error";
		}
	}
	// 모르겠어요...
	@RequestMapping(value = "/ezMemo/memoRead.do")
	public String memoRead(String memoId, @CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("memoRead started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("company_id",userInfo.getCompanyID());
		param.put("tenant_id", userInfo.getTenantId());
		param.put("user_id",userInfo.getId());
		param.put("memoId", memoId);
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/memo-detail/memo/" + memoId + "/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBody.get("status").toString();

		if ("ok".equals(status)) {
			model.addAttribute("memo", resultBody.get("data"));
		}
		
		logger.debug("memoRead ended.");
		return "ezMemo/memoRead";
	}
	
	/**
	 * 메모분류함 생성, 수정, 삭제 method
	 * @param loginCookie
	 * @param modelMap
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezMemo/memoFolderAction.do")
	public String memoFolderAction(@CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, Model model, String methodType, String folder_id) throws Exception {
		logger.debug("memoFolderAction started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		HashMap<String, Object> param = new HashMap<String, Object>();
		//param.put("company_id",userInfo.getCompanyID());
		//param.put("user_id",userInfo.getId());
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
	@RequestMapping(value = "/ezMemo/setLayerArea.do")
	public String setLayerArea(@CookieValue("loginCookie") String loginCookie,  String layerWidth, String layerHeight, HttpServletRequest request) throws Exception {
		logger.debug("setLayerArea started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();

		double width = Double.parseDouble(layerWidth);
		double height = Double.parseDouble(layerHeight);
		
		param.put("layer_width", width);
		param.put("layer_height", height);
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/setLayerArea/users/" + userInfo.getId(), param, request, "post", null);
		String status = resultBody.get("status").toString();
		
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
	@RequestMapping(value = "/ezMemo/setLayerPosition.do")
	public String setLayerPosition(@CookieValue("loginCookie") String loginCookie,  String layerTop, String layerLeft, HttpServletRequest request) throws Exception {
		logger.debug("setLayerPosition started");

		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		int topPIndex = layerTop.indexOf('p');
		int leftPIndex = layerLeft.indexOf('p');
		String top = layerTop.substring(0, topPIndex);
		String left = layerLeft.substring(0, leftPIndex);
		int topPositon = Integer.parseInt(top);
		int leftPosition = Integer.parseInt(left);

		param.put("layer_top", topPositon);
		param.put("layer_left", leftPosition);
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/setLayerPosition/users/" + userInfo.getId(), param, request, "post", null);
		String status = resultBody.get("status").toString();
		
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
	@RequestMapping(value = "/ezMemo/getMemoConfig.do")
	public String getMemoConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getMemoConfig started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/getMemoConfig/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if ("ok".equals(status)) {
			
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
	@RequestMapping(value = "/ezMemo/insertMemoConfig.do")
	public String insertMemoConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("insertMemoConfig started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		param.put("font_size", 14);
		param.put("use_date", 0);
		param.put("use_gadget", 0);
		param.put("default_color", 1);
		param.put("color_name", "#3498DB;#F3CA26;#E67E22;#27AE60;#9B59B6;#95A5A6;#9FD4F6;#F4E8B6;#F6C99F;#A5F1C5;#E9C1FA;#FFFFFF;");
		param.put("gadget_right", 0);
		param.put("gadget_bottom", 0);
		param.put("layer_left", 0);
		param.put("layer_top", 0);
		param.put("layer_width", 270);
		param.put("layer_height", 270);
		param.put("fold_status", 1);
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/createMemoConfig/users/" + userInfo.getId(), param, request, "post", null);
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
	@RequestMapping(value = "/ezMemo/hasMemoFolder.do")
	public String hasMemoFolder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("hasMemoFodler started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/folders/check/users/" +userInfo.getId(), param, request, "get", null);
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
	@RequestMapping("/ezMemo/memo-display.do")
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
	@RequestMapping(value = "/ezMemo/memoDetail.do")
	public String getMemoDetail(@CookieValue("loginCookie") String loginCookie, int memoId, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getMemoDetail started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("memoId", memoId);
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/memo-detail/memo/" + memoId + "/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBody.get("status").toString();

		if ("ok".equals(status)) {
			model.addAttribute("memo", resultBody.get("data"));
			model.addAttribute("memoList", resultBody.get("colorList").toString());
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
	@RequestMapping("/ezMemo/memoMove.do")
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
	@RequestMapping("/ezMemo/memoDelete.do")
	public String memoDelete(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, String memo_ids) throws Exception{
		logger.debug("memoDelete started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
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
	
	/**
	 * 다른 모듈에서 메모 추가
	 * @param loginCookie
	 * @param request
	 * @param model
	 * @param contents
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/ezMemo/otherModuleCopy.do")
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
	@RequestMapping("/ezMemo/memoColorModify.do")
	public String setMemoColor(@CookieValue("loginCookie") String loginCookie, String memoId, String colorId, HttpServletRequest request, Model model) throws Exception{
		logger.debug("setMemoColor start");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
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
	@RequestMapping("/ezMemo/reOrder.do")
	public String reOrder(@CookieValue("loginCookie") String loginCookie, String draggedElId, String compareElId, HttpServletRequest request, Model model) throws Exception {
		logger.debug("reOrder started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("draggedElId", draggedElId);
		param.put("compareElId", compareElId);
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/memo-order/draggedElId/" + draggedElId + "/compareElId/" + compareElId + "/users/" + userInfo.getId(), param, request, "post", null);
		String status = resultBody.get("status").toString();
		
		if ("ok".equals(status)) {
			model.addAttribute("status", 1);
		}
		logger.debug("reOrder ended");
		return "json";
	}
}
