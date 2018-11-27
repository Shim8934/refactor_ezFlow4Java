package egovframework.ezEKP.ezSurvey.web;

import java.util.List;
import java.util.Locale;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezSurvey.service.EzSurveyService;
import egovframework.ezEKP.ezSurvey.vo.SimpleDeptVO;
import egovframework.ezEKP.ezSurvey.vo.SimpleUserVO;
import egovframework.ezEKP.ezSurvey.vo.SurveyGeneralVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@SuppressWarnings("unchecked")
@RestController
public class EzSurveyGWController {
	private static final Logger logger = LoggerFactory.getLogger(EzSurveyGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzSurveyService surveyService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@RequestMapping(value="/rest/ezsurvey/company-tree/comp", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getCompanyTree(HttpServletRequest request) {
		String userId     = request.getParameter("userId")    != null ? request.getParameter("userId")    : "";
		String companyId  = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		String deptId     = request.getParameter("deptId")    != null ? request.getParameter("deptId")    : "";
		String serverName = request.getHeader("host-name")    != null ? request.getHeader("host-name")    : "";
		JSONObject result = new JSONObject();
		
		if (userId.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		logger.debug("Company Id: " + companyId + " || serverName: " + serverName + " || User Id: " + userId);
		
		try {
			LoginVO userInfo      = commonUtil.getUserForGw(userId, serverName);
			String primary        = userInfo.getPrimary();
			int tenantId          = userInfo.getTenantId();
			deptId                = deptId.equals("")    ? userInfo.getDeptID()    : deptId;
			companyId             = companyId.equals("") ? userInfo.getCompanyID() : companyId;
			SimpleDeptVO sCompany = new SimpleDeptVO();
			
			if (deptId.equals("")) {
				List<SimpleDeptVO> deptList = surveyService.getAllSubDepts(companyId, 1, primary, tenantId);
				sCompany.setSubDepts(deptList);
			}
			else {
				String deptPath  = surveyService.getDeptPath(deptId, tenantId);
				String[] path    = deptPath.split(",");
				sCompany         = surveyService.getSimpleCompany(companyId, 0, primary, tenantId);
				
				surveyService.getAllDepts(sCompany, path, primary, tenantId, 1, 1);
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("tree", sCompany);
			result.put("node", deptId);
		}
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezsurvey/sub-tree/{deptid}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getSubTree(@PathVariable(value="deptid") String deptId, HttpServletRequest request) {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name")                  : "";
		int level         = request.getParameter("level")  != null ? Integer.parseInt(request.getParameter("level")) : -1;
		String userId     = request.getParameter("userId") != null ? request.getParameter("userId")                  : "";
		JSONObject result = new JSONObject();
		
		logger.debug("deptId: " + deptId + " || level: " + level + " || serverName: " + serverName + " || User Id: " + userId);
		
		if (deptId.equals("") || serverName.equals("") || level == -1 || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo            = commonUtil.getUserForGw(userId, serverName);
			List<SimpleDeptVO> subDepts = surveyService.getAllSubDepts(deptId, level + 1, userInfo.getPrimary(), userInfo.getTenantId());
			result.put("status", "ok");
			result.put("code", 0);
			result.put("subNodes", subDepts);
		}
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezsurvey/dept-member/{deptid}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getDeptMembers(@PathVariable(value="deptid") String deptId, Locale locale, HttpServletRequest request) {
		String serverName = request.getHeader("host-name")      != null ? request.getHeader("host-name")                        : "";
		String userId     = request.getParameter("userId")      != null ? request.getParameter("userId")                        : "";
		int currentPage   = request.getParameter("currentPage") != null ? Integer.parseInt(request.getParameter("currentPage")) : -1;
		
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || UserId: " + userId + "|| currentPage: " + currentPage);
		
		if (serverName.equals("") || userId.equals("") || currentPage == -1) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo               = commonUtil.getUserForGw(userId, serverName);
			int tenantId                   = userInfo.getTenantId();
			String primary                 = userInfo.getPrimary();
			int startPoint                 = (currentPage - 1) * 50;
			int totalUsers                 = surveyService.getTotalDeptMembers(deptId, tenantId);
			int totalPages                 = (totalUsers + 49) / 50;
			
			List<SimpleUserVO> memberList = surveyService.getDeptMemberList(deptId, primary, startPoint, 50, tenantId);
			
			result.put("currentPage", currentPage);
			result.put("totalPages",  totalPages);
			result.put("memberList",  memberList);
			result.put("memberCount", totalUsers);
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezsurvey/list-type/userid/{userid}/get", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getUserListType(@PathVariable(value="userid") String userId, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || UserId: " + userId);
		
		if (serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			String listType  = ezOrganService.getListType(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
			
			result.put("listType", listType);
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezsurvey/search-member", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getSearchMember(Locale locale, HttpServletRequest request) {
		String serverName = request.getHeader("host-name")      != null ? request.getHeader("host-name")                        : "";
		String userId     = request.getParameter("userId")      != null ? request.getParameter("userId")                        : "";
		String srchOption = request.getParameter("srchOption")  != null ? request.getParameter("srchOption")                    : "";
		String srchValue  = request.getParameter("srchValue")   != null ? request.getParameter("srchValue")                     : "";
		int currentPage   = request.getParameter("currentPage") != null ? Integer.parseInt(request.getParameter("currentPage")) : -1;
		
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || UserId: " + userId + " || srchOption : " + srchOption + "|| srchValue" + srchValue + "|| currentPage: " + currentPage);
		
		if (serverName.equals("") || userId.equals("") || srchOption.equals("") || srchValue.equals("") || currentPage == -1) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo               = commonUtil.getUserForGw(userId, serverName);
			int tenantId                   = userInfo.getTenantId();
			String primary                 = userInfo.getPrimary();
			String sqlQuery                = "";
			
			switch(srchOption) {
				case "displayname": sqlQuery = primary.equals("1") ? srchOption : "displayname2" ; break;
				case "description": sqlQuery = primary.equals("1") ? srchOption : "description2" ; break;
				default: sqlQuery = srchOption;
			}
			
			int startPoint                 = (currentPage - 1) * 50;
			int totalUsers                 = surveyService.getTotalSearchMembers(sqlQuery, srchValue, tenantId);
			int totalPages                 = (totalUsers + 49) / 50;
			List<SimpleUserVO> memberList  = surveyService.getSearchMemberList(primary, startPoint, 50, sqlQuery, srchValue, tenantId);
			
			result.put("currentPage", currentPage);
			result.put("totalPages",  totalPages);
			result.put("memberList",  memberList);
			result.put("memberCount", totalUsers);
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezsurvey/attachfile/file-upload", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject postFileUploadGW(@RequestParam("data") String dataList, @RequestParam("files") List<MultipartFile> multiFileLists, Locale locale, HttpServletRequest request) throws Exception {
		JSONParser jp          = new JSONParser();
		JSONObject jsonObject  = (JSONObject) jp.parse(dataList);
		JSONArray nameArray    = jsonObject.get("nameArray")    != null ? (JSONArray) jsonObject.get("nameArray") : null;
		String serverName      = request.getHeader("host-name") != null ? request.getHeader("host-name")          : "";
		JSONObject result      = new JSONObject();
		
		logger.debug("serverName: " + serverName);
		
		if (nameArray == null || serverName.equals("") || nameArray.size() != multiFileLists.size() || multiFileLists.size() != 1) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			int tenantId    = loginService.getTenantId(serverName);
			String realPath = request.getServletContext().getRealPath("");
			String filePath = surveyService.saveUploadFile(multiFileLists, nameArray, realPath, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("path", filePath);
		}
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value = "/rest/ezsurvey/attachfile/file-download", method=RequestMethod.GET, produces = {MediaType.APPLICATION_OCTET_STREAM_VALUE})
	public void getFileDownload(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String filePath   = request.getParameter("filePath")   != null ? request.getParameter("filePath")  : "";
		String fileName   = request.getParameter("fileName")   != null ? request.getParameter("fileName")  : "";
		String userId     = request.getParameter("userId")     != null ? request.getParameter("userId")    : "";
		String serverName = request.getHeader("host-name")     != null ? request.getHeader("host-name")    : "";
		String userAgent  = request.getParameter("userAgent")  != null ? request.getParameter("userAgent") : "";
		
		logger.debug("serverName: " + serverName + " ||  filePath: " + filePath + " || UserId: " + userId + " || File Name: " + fileName);
		
		if (filePath.equals("") || fileName.equals("") || serverName.equals("") || userId.equals("")) {
			logger.debug("Invalid arguments!!!!!!");
			return;
		}
		
		//Get absolute path of the application
		String realPath = request.getServletContext().getRealPath("");
		
		surveyService.getDownloadedFile(fileName, filePath, realPath, userAgent, request, response);
		
		logger.debug("File Download Finish!");
		return;
	}
	
	@RequestMapping(value="/rest/ezsurvey/attachfile/file-delete", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject delFileUploadGW(Locale locale, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name")   != null ? request.getHeader("host-name")   : "";
		String filePath   = request.getParameter("filePath") != null ? request.getParameter("filePath") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " filePath: " + filePath);
		
		if (serverName.equals("") || filePath.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			int tenantId      = loginService.getTenantId(serverName);
			String realPath   = request.getServletContext().getRealPath("");
			surveyService.deleteAttachFile(filePath, realPath, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezsurvey/config/id/{userid}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getUserPreviewConfig(@PathVariable(value="userid") String userId, HttpServletRequest request) {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("UserId: " + userId + " || serverName: " + serverName);
		
		if (serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo            = commonUtil.getUserForGw(userId, serverName);
			int tenantId                = userInfo.getTenantId();
			String companyId            = userInfo.getCompanyID();
			SurveyGeneralVO userConfig  = surveyService.getUserPreviewConfig(userId, userInfo.getCompanyID(), userInfo.getTenantId());
			
			if (userConfig == null) {
				userConfig = new SurveyGeneralVO(userId, companyId, "off", 10, 50, 50, 50, 50, tenantId);
			}
			else {
				userConfig.setPreviewHpercent(100 - userConfig.getContentHpercent());
				userConfig.setPreviewWpercent(100 - userConfig.getContentWpercent());
			}
			
			result.put("config", userConfig);
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezsurvey/config/id/{userid}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject saveUserConfig(@PathVariable(value="userid") String userId, HttpServletRequest request) {
		String serverName    = request.getHeader("host-name")    != null ? request.getHeader("host-name")    : "";
		String prevMode      = request.getParameter("prevMode")  != null ? request.getParameter("prevMode")  : "";
		int listCount        = request.getParameter("listCount") != null ? Integer.parseInt(request.getParameter("listCount")) : -1;
		int contentWPrev     = request.getParameter("contentW")  != null ? Integer.parseInt(request.getParameter("contentW"))  : -1;
		int contentHPrev     = request.getParameter("contentH")  != null ? Integer.parseInt(request.getParameter("contentH"))  : -1;
		JSONObject result    = new JSONObject();
		
		logger.debug("UserId: " + userId + " || serverName: " + serverName + " || Preview Mode: " + prevMode + " || List count: " + listCount + " || ContentHPreview: " + contentHPrev + " || ContentWPreview: " + contentWPrev);
		
		if (serverName.equals("") || userId.equals("") || listCount == -1 || prevMode.equals("") || (!prevMode.equals("off") && (contentWPrev == -1 || contentHPrev == -1))) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		if (prevMode.equals("off")) {
			contentWPrev = 50;
			contentHPrev = 50;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			surveyService.saveUserConfig(prevMode, listCount, contentWPrev, contentHPrev, userId, userInfo.getCompanyID(), userInfo.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
}
