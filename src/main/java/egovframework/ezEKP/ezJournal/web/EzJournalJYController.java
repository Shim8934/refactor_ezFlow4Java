package egovframework.ezEKP.ezJournal.web;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.JsonUtil;

@Controller
public class EzJournalJYController extends EgovFileMngUtil {

	private static final Logger logger = LoggerFactory.getLogger(EzJournalJYController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Autowired
	private EzCommonService ezCommonService;
	
	/**
	 * 업무일지 작성 화면 호출
	 */
	@RequestMapping(value="/ezJournal/journalNewItem.do")
	public String journalNewItem(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("journalNewItem started");
		
		// 여기만 우선 userInfo 사용! userName 받아오는 문제때문..
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String offset = userInfo.getOffset();
		String nowDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), offset, false);
		nowDate = nowDate.substring(0, 10);
		nowDate = nowDate.replace("-", "");
		String mode = request.getParameter("mode");
		String typeId = request.getParameter("typeId");
		String useEditor = commonUtil.getTenantConfigRest("EDITOR", userInfo.getId(), request);
		String hasAttach = "";
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("userId", userInfo.getId());
		param.put("used", "use");
		
		String restUrl = "/rest/ezjournal/types";
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray typeList = (JSONArray) result.get("data");
			model.addAttribute("typeList", typeList);
		}
		
		model.addAttribute("nowDate", nowDate);
		model.addAttribute("typeId", typeId);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("mode", mode);
		model.addAttribute("info", userInfo);
		
		logger.debug("journalNewItem ended");
		
		return "/ezJournal/journalNewItem";
	}
	
	
	/**
	 * 업무일지 일지함의 양식리스트 가져오기
	 */
	@RequestMapping(value = "/ezJournal/getFormList.do")
	public String getFormList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) {
		logger.debug("getFormList started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String typeId = request.getParameter("typeId");
		if (typeId == null || typeId.equals("")) {
			typeId = "basic";
		}
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		String restUrl = "/rest/ezjournal/types/" + typeId + "/forms";
		
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
	
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray formList = (JSONArray) result.get("data");
			model.addAttribute("formList", formList);
			logger.debug("formList : " + formList);
		}
		
		logger.debug("getFormList ended");
		return "/ezJournal/journalFormList";
	}
	
	/**
	 * 수신자 선택화면 호출
	 */
	@RequestMapping(value = "/ezJournal/selectReceiver.do")
	public String selectReceiver(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) {
		logger.debug("selectReceiver started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		JSONObject result = commonUtil.getJsonFromRestApi("/rest/ezjournal/depts", param, request, "get", null);
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray deptList = (JSONArray) result.get("data");
			
			for (int i = 0; i < deptList.size(); i++) {
				JSONObject dept = (JSONObject) deptList.get(i);
				
				if (dept.get("isComp").equals("comp")) {
					dept.put("icon", "icon-company");
				} else {
					dept.put("icon", "icon-dept");
				}
				
				if (dept.get("myDept").equals("yes")) {
					JSONObject state = new JSONObject();
					state.put("selected", "true");
					dept.put("state", state);
				}
			}
			model.addAttribute("deptList", deptList);
			model.addAttribute("userId", userInfo.getId());
		}		
		logger.debug("selectReceiver ended");
		return "/ezJournal/journalSelectReceiver";
	}
	
	/**
	 * 수신자 즐겨찾기 저장 화면 호출 
	 */
	@RequestMapping(value = "/ezJournal/receiverLineName.do")
	public String receiverLineName(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) {
		logger.debug("receiverLineName started");
	
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String userId = userInfo.getId();
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("userId", userId);
		
		logger.debug("receiverLineName ended");
		return "/ezJournal/journalReceiverLineName";
	}
	
	/**
	 * 수신자 즐겨찾기 저장  
	 */
	@RequestMapping(value = "/ezJournal/saveReceiverFavorite.do")
	public String saveReceiverFavorite(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) {
		logger.debug("saveReceiverFavorite started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String userId = userInfo.getId();
		
		String receiverList = request.getParameter("receiverLine");
		String favoriteName = request.getParameter("favoriteName");
		String type = request.getParameter("type");
		String favoriteId = request.getParameter("favoriteId");
		logger.debug("receiverLine : " + receiverList + ",favoriteName : " + favoriteName + ",type : " + type + ",favoriteId : " + favoriteId);
		
		JSONObject param = new JSONObject();
		
		param.put("userId", userId);
		param.put("favoriteName", favoriteName);
		param.put("receiverList", receiverList);
		param.put("favoriteId", favoriteId);
		
		String restUrl = "";
		JSONObject result = new JSONObject();
		
		if (type.trim().equals("mod")) {
			restUrl = "/rest/ezjournal/users/" + userId + "/favorites/" + favoriteId;
			result = commonUtil.getJsonFromRestApi(restUrl, null, request, "put", param);
		} else {
			restUrl = "/rest/ezjournal/users/" + userId + "/favorites";
			result = commonUtil.getJsonFromRestApi(restUrl, null, request, "post", param);
		}
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			
		}
		
		logger.debug("saveReceiverFavorite ended");
		return "json";
	}
	
	/**
	 * 수신자 즐겨찾기 리스트 가져오기
	 */
	@RequestMapping(value = "/ezJournal/getFavoriteList.do")
	public String getFavoriteList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) {
		logger.debug("getFavoriteList started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String userId = request.getParameter("userId");
		if (userId == null || userId.equals("")) {
			userId = userInfo.getId();
		}
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		
		String restUrl = "/rest/ezjournal/users/" + userId + "/favorites";
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray favoriteList = (JSONArray) result.get("data");
			model.addAttribute("favoriteList", favoriteList);
			logger.debug("favoriteList : " + favoriteList);
		}
		
		logger.debug("getFavoriteList started");
		return "/ezJournal/journalFavoriteList";
	}
	
	/**
	 * 즐겨찾기 아이디에 해당하는 수신자 리스트 가져오기
	 */
	@RequestMapping(value = "/ezJournal/getFavoriteUser.do")
	public String getFavoriteUser(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) {
		logger.debug("getFavoriteUser started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String userId = request.getParameter("userId");
		if (userId == null || userId.equals("")) {
			userId = userInfo.getId();
		}
		String favoriteId = request.getParameter("favoriteId");
		logger.debug("favoriteId : " + favoriteId);
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		
		String restUrl = "/rest/ezjournal/users/" + userId + "/favorites/" + favoriteId + "/users";
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray userList = (JSONArray) result.get("data");
			model.addAttribute("userList", userList);
			logger.debug("userList : " + userList);
		}
		logger.debug("getFavoriteUser ended");
		return "/ezJournal/journalFavoriteUser";
	}
	
	/**
	 * 즐겨찾기 수신자 적용
	 */
	@RequestMapping(value = "/ezJournal/applyFavoriteUser.do")
	@ResponseBody
	public String applyFavoriteUser(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) {
		logger.debug("applyFavoriteUser started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String userId = request.getParameter("userId");
		if (userId == null || userId.equals("")) {
			userId = userInfo.getId();
		}
		String favoriteId = request.getParameter("favoriteId");
		logger.debug("favoriteId : " + favoriteId);
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		
		String restUrl = "/rest/ezjournal/users/" + userId + "/favorites/" + favoriteId + "/users";
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray userList = (JSONArray) result.get("data");
			logger.debug("userList : " + userList);
			return JsonUtil.ListToJson(userList);
		}
		logger.debug("applyFavoriteUser ended");
		return JsonUtil.OneStringToJson("json");
	}
	
	/**
	 * 즐겨찾기 삭제
	 */
	@RequestMapping(value = "/ezJournal/deleteFavorite.do")
	@ResponseBody
	public String deleteFavorite(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) {
		logger.debug("deleteFavorite started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String userId = request.getParameter("userId");
		if (userId == null || userId.equals("")) {
			userId = userInfo.getId();
		}
		String favoriteId = request.getParameter("favoriteId");
		logger.debug("favoriteId : " + favoriteId);
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		
		String restUrl = "/rest/ezjournal/users/" + userId + "/favorites/" + favoriteId;
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request, "delete", null);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			
		}
		logger.debug("deleteFavorite ended");
		return JsonUtil.OneStringToJson("json");
	}
	
	/**
	 * 업무일지 양식 폼 호출
	 */
	@RequestMapping(value = "/ezJournal/journalGetForm.do", produces="application/json; charset=utf-8")
	@ResponseBody
	public String journalGetForm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("journalGetForm started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String formId = request.getParameter("formId");
		String typeId = request.getParameter("typeId");
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		String restUrl = "/rest/ezjournal/types/" + typeId + "/forms/" + formId;
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONObject jsonResult = (JSONObject) result.get("data");
			param.clear();
			param.put("formName", jsonResult.get("formName"));
			param.put("formContent", jsonResult.get("formContent"));
			logger.debug("resultparam 확인 : " + param);
			return JsonUtil.MapToJson(param);
		}

		logger.debug("journalGetForm ended");
		return JsonUtil.OneStringToJson("json");
	}
	
	/**
	 * 업무일지 마지막 사용양식 아이디 가져오기
	 */
	@RequestMapping(value = "/ezJournal/journalGetLastForm.do", produces="application/json; charset=utf-8")
	@ResponseBody
	public String journalGetLastForm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("journalGetLastForm started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String formId = "last";
		String typeId = request.getParameter("typeId");
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("isGetForm", "isGetForm");
		
		String restUrl = "/rest/ezjournal/types/" + typeId + "/forms/" + formId;
		JSONObject result = commonUtil.getJsonFromRestApi(restUrl, param, request, "get", null);
		
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			String lastId = result.get("data").toString();
			logger.debug("lastFormId : " + lastId);
			return JsonUtil.OneStringToJson(lastId);
		}
		
		logger.debug("journalGetLastForm ended");
		return JsonUtil.OneStringToJson("json");
	}
	
	/**
	 * 일지작성 > 첨부파일 리스트 호출 
	 */
	@RequestMapping(value = "/ezJournal/dragAndDrop.do")
	public String journalDragAndDrop(@CookieValue("loginCookie") String loginCookie, Model model,  HttpServletRequest request) throws Exception {
		
		logger.debug("journalDragAndDrop started");

        LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
        String attachFileNameMaxLength = commonUtil.getTenantConfigRest("attachFileNameMaxLength", userInfo.getId(), request);
		
		if (attachFileNameMaxLength.equals("")) {
			attachFileNameMaxLength = "100";
		}
		
		String mode = "";
		String journalId = "";
		
		if (request.getParameter("mode") != null && !request.getParameter("mode").equals("")) {
			mode = request.getParameter("mode");
		}
		
		if (request.getParameter("journalId") != null && !request.getParameter("journalId").equals("")) {
			mode = request.getParameter("journalId");
		}
        
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("attachFileNameMaxLength", attachFileNameMaxLength);
		model.addAttribute("mode", mode);
		model.addAttribute("journalId", journalId);
		
		logger.debug("journalDragAndDrop ended");
		return "ezJournal/journalDragAndDrop";
	}	
	
	/**
	 * 일지작성 > 첨부파일 업로드
	 */
	@RequestMapping(value = "/ezJournal/uploadJournalAttach.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String uploadJournalAttach(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie) throws Exception{
		
		logger.debug("uploadJournalAttach started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		List<MultipartFile> multiFile = request.getFiles("fileToUpload"); 
		int cnt = multiFile.size();
		
		String realPath = request.getServletContext().getRealPath("");
		String[] pFileName = new String[cnt];
        Long[] fileSize = new Long[cnt];        
        String[] resultUpload = new String[cnt];
        String[] sGUID = new String[cnt];
        String[] pUploadSN = new String[cnt];
        
        String useExtension = commonUtil.getTenantConfigRest("USE_FileExtension", userInfo.getId(), request);
        
        //2018-02-13 주홍선 mode와 circularID 가져오도록 주석 제거
        String mode = "";
		String journalId = "";

		if (request.getParameter("mode") != null && !request.getParameter("mode").equals("")) {
			mode = request.getParameter("mode");
		}
		
		if (request.getParameter("journalId") != null && !request.getParameter("journalId").equals("")) {
			journalId = request.getParameter("journalId");		
		}

		logger.debug("mode : " + mode + " | journalId : " + journalId);

        for (int i = 0; i < cnt; i++) {
            resultUpload[i] = "false";
            sGUID[i] = UUID.randomUUID().toString();
            pUploadSN[i] = "{" + sGUID[i] + "}";
        }

        if (StringUtils.isNotEmpty(multiFile.get(0).getOriginalFilename()) && StringUtils.isNotBlank(multiFile.get(0).getOriginalFilename())) {        	
            for (int i = 0; i < cnt; i++) {
                String _pFileName = multiFile.get(i).getOriginalFilename();
                if (_pFileName.indexOf(commonUtil.separator) > 0) {
                    _pFileName = _pFileName.split("/")[_pFileName.split("/").length - 1];
                }
                pFileName[i] = _pFileName;
            }
        }

        for (int i = 0; i < cnt; i++) {
            pFileName[i] = pFileName[i].replace("%2b", "+");
            pFileName[i] = pFileName[i].replace("%3b", ";");
        }
        
        String pDirPath = commonUtil.getUploadPath("upload_journal.ROOT", userInfo.getTenantId());

        pDirPath = realPath + pDirPath;
        if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
        	pDirPath = pDirPath + commonUtil.separator;
        }
        File file = new File(pDirPath + "uploadFile");
        File tempFile = new File(pDirPath + "tempUploadFile");

        if (!file.exists()) {
        	file.mkdir();
        }
        
        if (!tempFile.exists()) {
        	tempFile.mkdir();
        }

        StringBuffer strXML = new StringBuffer();
        strXML.append("<ROOT><NODES>");
        
        for (int i = 0; i < cnt; i++) {        	
        	fileSize[i] = multiFile.get(i).getSize();
            String extend = pFileName[i].substring(pFileName[i].lastIndexOf(".") + 1);
            String newFileName = pUploadSN[i];
            
            if (useExtension.toLowerCase().indexOf(extend.toLowerCase()) == -1 && !useExtension.equals("*")) {           	
				strXML.append("<DATA><![CDATA[" + newFileName + ";" + pFileName[i] + "]]></DATA>");
				strXML.append("<DATA2><![CDATA[" + pFileName[i] + "]]></DATA2>");
				strXML.append("<DATA3><![CDATA[" + fileSize[i] + "]]></DATA3>");
				strXML.append("<DATA4><![CDATA[]]></DATA4>");
				strXML.append("<DATA5><![CDATA[denied]]></DATA5>");
            } else {
//            	if (mode.equals("temp")) {
            	writeUploadedFile(multiFile.get(i), newFileName + ";" + pFileName[i], pDirPath + "tempUploadFile");            		
//            	} else {
//            		writeUploadedFile(multiFile.get(i), newFileName + ";" + pFileName[i], pDirPath + "uploadFile" + commonUtil.separator + circularID + "_uploadFile");
//            	}
            	
				strXML.append("<DATA><![CDATA[" + newFileName + ";" + pFileName[i] + "]]></DATA>");
				strXML.append("<DATA2><![CDATA[" + pFileName[i] + "]]></DATA2>");
				strXML.append("<DATA3><![CDATA[" + fileSize[i] + "]]></DATA3>");
				strXML.append("<DATA4><![CDATA[]]></DATA4>");
				strXML.append("<DATA5><![CDATA[OK]]></DATA5>");
            }
        }
        strXML.append("</NODES></ROOT>");
        
        logger.debug("uploadJournalAttach ended");
        
        return strXML.toString();
    }
	
	/**
	 * 일지작성 > 닫기 클릭시 임시첨부파일 삭제
	 */
	@RequestMapping(value = "/ezJournal/tempUploadFileDelete.do")
	public String tempUploadFileDelete(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, Model model) throws Exception {
		
		logger.debug("tempUploadFileDelete started");
		
		//2018-02-13 주홍선 loginSimpleVO 쿠키에서 가져오도록 변경
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);

		String pDirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_circular.ROOT", loginSimpleVO.getTenantId());
		String fileList = request.getParameter("fileList");
		//2018-02-13 주홍선 주석제거
		String mode = "";
		String circularID = "";
		String filePath = "";
		
		logger.debug("fileList : " + fileList);
		
		if (request.getParameter("mode") != null && !request.getParameter("mode").equals("")) {
			mode = request.getParameter("mode");
		}
		
		if (request.getParameter("circularID") != null && !request.getParameter("circularID").equals("")) {
			circularID = request.getParameter("circularID");
		}

		if (mode.equals("temp")) {
			filePath = "uploadFile" + commonUtil.separator + circularID + "_uploadFile";
		} else {
			filePath = "tempUploadFile";
		}
		
		logger.debug("filePath : " + filePath);

		if (fileList.length() != 0) {
			String[] data = fileList.split(","); 
			
			for (int i=0; i<data.length; i++) {
				String sGUID = data[i].split(";")[0];
				String fileName = data[i].split(";")[1];
				
				File file = new File(pDirPath + commonUtil.separator + filePath + commonUtil.separator + sGUID + ";" + fileName);
				
				file.delete();
			}			
		}

        logger.debug("tempUploadFileDelete ended");
        
        return "json";
    }
}
