package egovframework.ezEKP.ezMemo.web;

import java.util.HashMap;
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
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCircular.vo.CircularFolderVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezLadder.web.EzLadderController;
import egovframework.ezEKP.ezMemo.vo.MemoFolderVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

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
	public String memoMain(String order, String searchInput, String startDate, String endDate, @CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("memoMain started.");
		
		String brdID = "8";
		order = order != null ? order : "0";		// 메모함 선택
		searchInput = searchInput != null ? searchInput : "";		// 검색 사용 시 검색 단어
		startDate = startDate != null ? startDate : "";				// 검색 사용 시 시작일
		endDate = endDate != null ? endDate : "";					// 검색 사용 시 종료일
		
		if (request.getParameter("brdID") != null) {
			brdID = request.getParameter("brdID");
		}
		
		logger.debug("order : " + order + ", searchInput : " + searchInput + ", startDate : " + startDate + ", endDate : " + endDate);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("company_id",userInfo.getCompanyID());
		param.put("tenant_id", userInfo.getTenantId());
		param.put("user_Id",userInfo.getId());
		param.put("order", order);
		param.put("searchInput", searchInput);
		param.put("startDate", startDate);
		param.put("endDate", endDate);
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/memo-list/users/" + userInfo.getId(), param, request, "get", null);		
		
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {		
				JSONArray memoList = (JSONArray) resultBody.get("memoList");
				
				model.addAttribute("memoList", memoList);
		}
		
		
		logger.debug("memoMain ended");
		return "ezMemo/memoMain";
	}
	
	/**
	 * 메모함 정보 호출 method
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
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("company_id",userInfo.getCompanyID());
		param.put("user_Id",userInfo.getId());
		
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
	 * 메모함관리 화면 이동 method
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
	 * 메모함 추가/수정 화면 호출 method
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
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("company_id",userInfo.getCompanyID());
		param.put("user_id",userInfo.getId());
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/folders/names/users/" + userInfo.getId(), param, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {			
			String folderNameList = resultBody.get("data").toString();
			model.addAttribute("folderNameList", folderNameList);
		}
		logger.debug("memoInputName ended");
		return "ezMemo/memoInputName";

	}

	
	@RequestMapping(value = "/ezMemo/memoRead.do")
	public String memoDetailView(@CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("memoRead started.");
		
		logger.debug("memoRead ended.");
		return "ezMemo/memoRead";

	}
	
	/**
	 * 메모함 생성, 수정, 삭제
	 * @param loginCookie
	 * @param modelMap
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezMemo/memoFolderAction.do")
	public String memoFolderAdd(@CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, Model model, String methodType, String folder_id, String folder_name) throws Exception {
		logger.debug("memoFolderAction started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("company_id",userInfo.getCompanyID());
		param.put("user_id",userInfo.getId());
		param.put("folder_name",folder_name);
		if(!methodType.equals("post")) {
			param.put("folder_id", folder_id);
		}
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/folders/users/" + userInfo.getId(), param, request, methodType, null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {			
			String folderNameList = resultBody.get("data").toString();
			model.addAttribute("folderNameList", folderNameList);
		}
		logger.debug("memoFolderAction ended.");
		return "json";
	}

	@RequestMapping(value = "/ezMemo/setLayerArea.do")
	public String setLayerArea(@CookieValue("loginCookie") String loginCookie,  String layerWidth, String layerHeight, HttpServletRequest request) throws Exception {
		logger.debug("setLayerArea start");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("company_id",userInfo.getCompanyID());
		param.put("tenant_id", userInfo.getTenantId());
		param.put("user_id",userInfo.getId());

		double width = Double.parseDouble(layerWidth);
		double height = Double.parseDouble(layerHeight);
		
		param.put("layer_width", width);
		param.put("layer_height", height);
		
		JSONObject resultBody = commonUtil.getJsonFromMemoRestApi("/rest/ezMemo/setLayerArea/users/" + userInfo.getId(), param, request, "post", null);
		String status = resultBody.get("status").toString();
		
		logger.debug("상태: " + status);
		logger.debug("setLayerArea end");
		return status;
	}
	
	@RequestMapping(value = "ezMemo/setLayerPosition.do")
	public String setLayerPosition(@CookieValue("loginCookie") String loginCookie,  String layerTop, String layerLeft, HttpServletRequest request) throws Exception {
		logger.debug("setLayerPosition start");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("company_id",userInfo.getCompanyID());
		param.put("tenant_id", userInfo.getTenantId());
		param.put("user_id",userInfo.getId());
		
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
		
		logger.debug("상태: " + status);
		logger.debug("setLayerPosition end");
		return status;
	}
}
