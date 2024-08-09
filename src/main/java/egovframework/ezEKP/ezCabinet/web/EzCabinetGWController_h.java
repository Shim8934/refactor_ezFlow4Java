package egovframework.ezEKP.ezCabinet.web;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections4.CollectionUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCabinet.service.EzCabinetAdminService;
import egovframework.ezEKP.ezCabinet.service.EzCabinetService;
import egovframework.ezEKP.ezCabinet.service.EzCabinetService_h;
import egovframework.ezEKP.ezCabinet.vo.CabinetAttachFileVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetColumnVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetItemVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetRelationItemVO;
import egovframework.ezEKP.ezCabinet.vo.SimpleUserInfoVO;
import egovframework.ezEKP.ezCabinet.vo.SimpleUserMailVO;
import egovframework.ezEKP.ezCabinet.vo.UserCapacityVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezWebFolder.vo.SimpleUserVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@SuppressWarnings("unchecked")
@RestController
public class EzCabinetGWController_h {
	private static final Logger logger = LoggerFactory.getLogger(EzCabinetGWController_h.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzCabinetService cabinetService;
	
	@Autowired
	private EzCabinetAdminService cabinetAdminService;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Autowired
	private EzCabinetService_h cabinetService_h;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@RequestMapping(value="/rest/ezCabinet/dept-member/{deptid:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
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
			int totalUsers                 = cabinetService_h.getTotalDeptMembers(deptId, tenantId);
			int totalPages                 = (totalUsers + 49) / 50;
			
			List<SimpleUserVO> memberList = cabinetService_h.getDeptMemberList(deptId, primary, startPoint, 50, tenantId);
			
			result.put("currentPage", currentPage);
			result.put("totalPages",  totalPages);
			result.put("memberList",  memberList);
			result.put("memberCount", totalUsers);
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
		}
		
		return result;
		
	}
	
	@RequestMapping(value="/rest/ezCabinet/shared-member/cabinetid/{cabinetId}/get", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getShareUserList(@PathVariable(value="cabinetId") String cabinetId,   HttpServletRequest request) throws Exception {
		String serverName     = request.getHeader("host-name")       != null ? request.getHeader("host-name")            : "";
		String userId         = request.getParameter("userId")       != null ? request.getParameter("userId")            : "";
		String searchOpt      = request.getParameter("searchOpt")    != null ? request.getParameter("searchOpt")         : "";
		String searchValue    = request.getParameter("searchValue")  != null ? request.getParameter("searchValue")       : "";
		String searchFlag     = request.getParameter("searchFlag")   != null ? request.getParameter("searchFlag")        : ""; // 공유자 검색 Flag
		
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || UserId: " + userId + " || searchOpt: " + searchOpt + " || searchValue: " + searchValue);
		
		if (serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			String primary   = userInfo.getPrimary();
			String sqlQuery  = "";
			
			/* 2024-07-31 홍승비 - 잘못된 검색 조건 설정 코드 수정, SQL Injection 대응은 쿼리단에서 $ 기호 제거로 처리함 */
			switch(searchOpt) {
				case "displayname": sqlQuery = "display_name"   ; break;
				case "description": sqlQuery = "department_name"; break;
				case "cn"         : sqlQuery = "cn"             ; break;
				default: sqlQuery = searchOpt;
			}
			
			List<SimpleUserVO> list = cabinetService_h.getShareUserList(cabinetId, userId, sqlQuery, searchValue, primary, userInfo.getTenantId(), searchFlag);
			
			result.put("shareList", list);
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezCabinet/shared-ancestor/cabinetid/{cabinetId}/get", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getAncestorShareUserList(@PathVariable(value="cabinetId") String cabinetId,   HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name")       != null ? request.getHeader("host-name")            : "";
		String userId     = request.getParameter("userId")       != null ? request.getParameter("userId")            : "";
		
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
			String primary   = userInfo.getPrimary();
			
			List<SimpleUserVO> list = cabinetService_h.getAncestorShareUserList(cabinetId, userId, primary, userInfo.getTenantId());
			
			result.put("shareList", list);
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezCabinet/list-type/userid/{userid:.+}/get", method= RequestMethod.GET, produces="application/json;charset=utf-8")
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
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezCabinet/list-type/userid/{userid:.+}/save", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject saveUserListType(@PathVariable(value="userid") String userId, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name")   != null ? request.getHeader("host-name")   : "";
		String listType   = request.getParameter("listType") != null ? request.getParameter("listType") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || UserId: " + userId + " || listType: " + listType);
		
		if (serverName.equals("") || userId.equals("") || listType.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			ezOrganService.setListType(listType, userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
			
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezCabinet/search-member", method= RequestMethod.GET, produces="application/json;charset=utf-8")
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
			
			/* 2024-07-31 홍승비 - 잘못된 검색 조건 설정 코드 수정, SQL Injection 대응은 쿼리단에서 $ 기호 제거로 처리함 */
			switch(srchOption) {
				case "displayname": sqlQuery = primary.equals("1") ? srchOption : "displayname2" ; break;
				case "description": sqlQuery = primary.equals("1") ? srchOption : "description2" ; break;
				default: sqlQuery = srchOption;
			}
			
			int startPoint                 = (currentPage - 1) * 50;
			int totalUsers                 = cabinetService_h.getTotalSearchMembers(sqlQuery, srchValue, tenantId);
			int totalPages                 = (totalUsers + 49) / 50;
			List<SimpleUserVO> memberList  = cabinetService_h.getSearchMemberList(primary, startPoint, 50, sqlQuery, srchValue, tenantId);
			
			result.put("currentPage", currentPage);
			result.put("totalPages",  totalPages);
			result.put("memberList",  memberList);
			result.put("memberCount", totalUsers);
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
		}
		
		return result;
		
	}
	
	@RequestMapping(value="/rest/ezCabinet/shared-member/cabinetId/{cabinetId}/save", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject saveShareUserList(@PathVariable(value="cabinetId") String cabinetId, HttpServletRequest request) throws Exception {
		String serverName     = request.getHeader("host-name")   != null ? request.getHeader("host-name")   : "";
		String userId         = request.getParameter("userId")   != null ? request.getParameter("userId")   : "";
		String userList       = request.getParameter("userList") != null ? request.getParameter("userList") : "";
		JSONParser jp         = new JSONParser();
		JSONObject result     = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || UserId: " + userId + " || userList" + userList);
		
		if (serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo          = commonUtil.getUserForGw(userId, serverName);
			JSONArray listUsers       = (JSONArray)jp.parse(userList);
			result                    = cabinetService_h.saveShareUserList(listUsers, cabinetId, userInfo);
		} 
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezCabinet/shared-member/cabinetId/{cabinetId}/modify", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject modifyShareUserList(@PathVariable(value="cabinetId") String cabinetId, HttpServletRequest request) throws Exception {
		String serverName     = request.getHeader("host-name")   != null ? request.getHeader("host-name")   : "";
		String userId         = request.getParameter("userId")   != null ? request.getParameter("userId")   : "";
		String userList       = request.getParameter("userList") != null ? request.getParameter("userList") : "";
		String actMode        = request.getParameter("mode")     != null ? request.getParameter("mode")     : "";
		JSONParser jp         = new JSONParser();
		JSONObject result     = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || UserId: " + userId + " || userList" + userList + " || Mode: " + actMode);
		
		if (serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo          = commonUtil.getUserForGw(userId, serverName);
			JSONArray listUsers       = (JSONArray)jp.parse(userList);
			result                    = cabinetService_h.modifyShareUserList(listUsers, actMode, cabinetId, userInfo);
		} 
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezCabinet/check-permission", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject checkFileCreator(HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name")       != null ? request.getHeader("host-name")                       : "";
		String userId     = request.getParameter("userId")       != null ? request.getParameter("userId")                       : "";
		String cabinetId  = request.getParameter("cabinetId")    != null ? request.getParameter("cabinetId")                    : "";
		String itemId     = request.getParameter("itemId")       != null ? request.getParameter("itemId")                       : "";
		int permission    = request.getParameter("permission")   != null ? Integer.parseInt(request.getParameter("permission")) : -1;
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || UserId: " + userId + " || Item Id: " + itemId + " || Cabinet Id: " + cabinetId + " || Permission: " + permission);
		
		if (serverName.equals("") || userId.equals("") || (itemId.equals("") && cabinetId.equals("")) || permission == -1) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			result.put("reason", 3);
			return result;
		}
		
		try {
			LoginVO userInfo          = commonUtil.getUserForGw(userId, serverName);
			List<Integer> itemList    = new ArrayList<>();
			List<Integer> cabinetList = new ArrayList<>();
			
			if (!itemId.equals("")) {
				itemList.add(Integer.parseInt(itemId));
			}
			
			if (!cabinetId.equals("")) {
				cabinetList.add(Integer.parseInt(cabinetId));
			}
			
			result = cabinetService.checkPermission(cabinetList, itemList, permission, userInfo);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezCabinet/file-detail/itemId/{itemId}/get", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getFileDetail(@PathVariable(value="itemId") String itemId, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name") : "";
		String userId     = request.getParameter("userId") != null ? request.getParameter("userId") : "";
		
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || UserId: " + userId );
		
		if (serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo         = commonUtil.getUserForGw(userId, serverName);
			String primary           = userInfo.getPrimary();
			int tenantId             = userInfo.getTenantId();
			String offset            = commonUtil.getMinuteUTC(userInfo.getOffset());
			CabinetItemVO fileDetail = cabinetService_h.getFileDetail(itemId, primary, offset, tenantId);
			
			if(fileDetail.getItemType() != 0 && fileDetail.getItemType() != 2) {
				//Get more information
				getColumnInformation(result, Integer.parseInt(itemId), fileDetail.getItemType(), primary, tenantId);
			}
			
			List<CabinetAttachFileVO> attachFileList    = cabinetService_h.getAttachFileList(itemId, tenantId);
			List<CabinetRelationItemVO> relatedFileList = cabinetService_h.getRelatedFileList(itemId, tenantId);
			
			result.put("fileDetail", fileDetail);
			result.put("attachFileList", attachFileList);
			result.put("relatedFileList", relatedFileList);
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezCabinet/file-info/itemId/{itemId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject cabinetItemInfo(@PathVariable(value="itemId") String itemId, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name") : "";
		String userId     = request.getParameter("userId") != null ? request.getParameter("userId") : "";
		
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || UserId: " + userId );
		
		if (serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo         = commonUtil.getUserForGw(userId, serverName);
			String primary           = userInfo.getPrimary();
			int tenantId             = userInfo.getTenantId();
			String offset            = commonUtil.getMinuteUTC(userInfo.getOffset());
			CabinetItemVO fileDetail = cabinetService_h.getFileDetail(itemId, primary, offset, tenantId);
			
			if(fileDetail.getItemType() != 0 && fileDetail.getItemType() != 2) {
				//Get more columns information
				getColumnInformation(result, Integer.parseInt(itemId), fileDetail.getItemType(), primary, tenantId);
			}
			
			//Check item privilege
			int userPermission = cabinetService_h.checkItemPermission(fileDetail.getCabinetId(), userInfo);
			
			result.put("permission", userPermission);
			result.put("item"      , fileDetail);
			result.put("status"    , "ok");
			result.put("code"      , 0);
		} 
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/item/id/{itemId}/modify", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject modifyItem(@RequestBody JSONObject itemInf, @PathVariable(value="itemId") String itemId, Locale locale, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name")     != null ? request.getHeader("host-name")     : "";
		String title      = itemInf.get("title")      != null ? itemInf.get("title").toString()      : "";
		String summary    = itemInf.get("summary")    != null ? itemInf.get("summary").toString()    : "";
		String fileArray  = itemInf.get("fileArray")  != null ? itemInf.get("fileArray").toString()  : "";
		String relatedArr = itemInf.get("relatedArr") != null ? itemInf.get("relatedArr").toString() : "";
		String userId     = itemInf.get("userId")     != null ? itemInf.get("userId").toString()     : "";
		JSONObject result = new JSONObject();
		JSONParser jp     = new JSONParser();
		
		logger.debug("ServerName: " + serverName + " || Item Id: " + itemId + " || title: " + title + " ||  summary: " + summary + " ||  userId: " + userId + " || fileArray: " + fileArray + " || relatedArr: " + relatedArr);
		
		if (serverName.equals("") || title.equals("") || userId.equals("") || itemId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo        = commonUtil.getUserForGw(userId, serverName);
			int currentItemId       = Integer.parseInt(itemId);
			
			//Add checking permission here
			List<Integer> itemList  = new ArrayList<>(Arrays.asList(currentItemId));
			JSONObject permission   = cabinetService.checkPermission(new ArrayList<>(), itemList, 1, userInfo);
			
			if ((int)permission.get("code") == 1) {
				result.put("status", "error");
				result.put("code", 3);
				return result;
			}
			
			JSONArray attacheFiles  = (JSONArray) jp.parse(fileArray);
			JSONArray relatedFiles  = (JSONArray) jp.parse(relatedArr);
			String realPath         = request.getServletContext().getRealPath("");
			UserCapacityVO capacity = cabinetAdminService.getUserCapacity(userId, userInfo.getCompanyID(), userInfo.getPrimary(), userInfo.getTenantId());
			
			if (capacity.getCapacityType() == 1) {
				//Check save condition
				long totalAttachSize = 0;
				long itemSize        = cabinetService.getTotalItemsSize(new ArrayList<Integer>(Arrays.asList(Integer.parseInt(itemId))), userInfo);
				
				if (attacheFiles.size() > 0) {
					for (int i = 0; i < attacheFiles.size(); i++) {
						JSONObject fileObj = (JSONObject)attacheFiles.get(i);
						String filePath    = (String)fileObj.get("path");
						File file          = new File(realPath + commonUtil.detectPathTraversal(filePath));
						totalAttachSize    = totalAttachSize + file.length();
					}
				}
				
				long totalUsed = Long.parseLong(capacity.getTotalUsed());
				long totalCap  = capacity.getTotalCapacity() * 1048576;
				
				if (totalAttachSize > (totalCap - totalUsed + itemSize)) {
					logger.debug("Not enough storage to upload these files!");
					result.put("status", "error");
					result.put("code", 4);
					return result;
				}
			}
			
			result = cabinetService_h.modifyItem(currentItemId, attacheFiles, relatedFiles, title, summary, realPath, userInfo);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/relate-item/save/board", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject saveBoarditem(@RequestBody JSONObject boardItemInf, Locale locale, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name")            : "";
		String userId     = boardItemInf.get("userId")     != null ? boardItemInf.get("userId").toString()     : "";
		String mode       = boardItemInf.get("mode")       != null ? boardItemInf.get("mode").toString()       : "";
		String cabinetId  = boardItemInf.get("cabinet")    != null ? boardItemInf.get("cabinet").toString()    : "";
		String title      = boardItemInf.get("title")      != null ? boardItemInf.get("title").toString()      : "";
		String summary    = boardItemInf.get("summary")    != null ? boardItemInf.get("summary").toString()    : "";
		String boardTitle = boardItemInf.get("boardTitle") != null ? boardItemInf.get("boardTitle").toString() : "";
		String writer     = boardItemInf.get("writer")     != null ? boardItemInf.get("writer").toString()     : "";
		String dateTime   = boardItemInf.get("dateTime")   != null ? boardItemInf.get("dateTime").toString()   : "";
		String attach     = boardItemInf.get("attach")     != null ? boardItemInf.get("attach").toString()     : "";
		String content    = boardItemInf.get("content")    != null ? boardItemInf.get("content").toString()    : "";
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || userId: " + userId + " || mode: " + mode + " || cabinetId: " + cabinetId + " || title: " + title  + " || summary: "+ summary + " || boardTitle: " + boardTitle + " || writer: " + writer + " || dateTime: " + dateTime + " || attach: " + attach  + " || content: " + content);
		
		if (serverName.equals("") || userId.equals("") || mode.equals("") || (mode.equals("1") && cabinetId.equals("")) || title.equals("") || boardTitle.equals("") || writer.equals("") || dateTime.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int dstCabinetId = cabinetId.equals("") ? -1 : Integer.parseInt(cabinetId);
			String realPath  = request.getServletContext().getRealPath("");
			result           = cabinetService_h.saveBoardItem(realPath, mode, dstCabinetId, title, summary, boardTitle, writer, attach, content, dateTime, locale, userInfo);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	private void getColumnInformation(JSONObject result, int itemId, int itemType, String primary, int tenantId) throws Exception {
		//Get related columns
		List<CabinetColumnVO> columnList = cabinetService.getAllRelatedColumnsOfItem(itemId, primary, tenantId);

		// 2023-05-11 이사라 : NullPointerException 시큐어코딩
		//if (columnList != null && columnList.size() > 0) {
		if (CollectionUtils.isNotEmpty(columnList)) {
			result.put("columns", columnList);
		} else {
			throw new NullPointerException("columnList is null");
		}
		
		//Check file type
		switch(itemType) {
			case 1 : getMoreEmailDetail(result, columnList, primary, tenantId)    ; break;
			case 3 : getMoreBoardDetail(result, columnList, primary, tenantId)    ; break;
			case 4 : getMoreScheduleDetail(result, columnList, primary, tenantId) ; break;
			case 5 : getMoreTodoDetail(result, columnList, primary, tenantId)     ; break;
			case 6 : getMoreOptionDetail(result, columnList, primary, tenantId)   ; break;
			case 7 : getMoreCommuintyDetail(result, columnList, primary, tenantId); break;
			case 8 : getMoreAddressDetail(result, columnList, primary, tenantId)  ; break;
			case 9 : getMoreJournalDetail(result, columnList, primary, tenantId)  ; break;
			case 11: getMoreResourceDetail(result, columnList, primary, tenantId) ; break;
			default: break;
		}
	}
	
	private void getMoreJournalDetail(JSONObject result, List<CabinetColumnVO> columnList, String primary, int tenantId) throws Exception {
		CabinetColumnVO writerColumn = columnList.stream().filter(column -> column.getColumnId().equals("jourWriter")).collect(Collectors.toList()).get(0);
		
		String writerId              = writerColumn.getColumnValue();
		SimpleUserInfoVO writerVO    = cabinetService.getSimpleUserInfo(writerId, primary, tenantId);
		
		if (writerVO == null) {
			writerVO = new SimpleUserInfoVO(writerId, writerId);
		}
		
		result.put("writerVO", writerVO);
	}
	
	private void getMoreCommuintyDetail(JSONObject result, List<CabinetColumnVO> columnList, String primary, int tenantId) throws Exception {
		CabinetColumnVO writerColumn = columnList.stream().filter(column -> column.getColumnId().equals("commuWriter")).collect(Collectors.toList()).get(0);
		CabinetColumnVO typeColumn   = columnList.stream().filter(column -> column.getColumnId().equals("commuType")).collect(Collectors.toList()).get(0);
		
		String writerId              = writerColumn.getColumnValue();
		SimpleUserInfoVO writerVO    = cabinetService.getSimpleUserInfo(writerId, primary, tenantId);
		
		if (writerVO == null) {
			writerVO = new SimpleUserInfoVO(writerId, writerId);
		}
		
		result.put("commuType", typeColumn.getColumnValue());
		result.put("writerVO", writerVO);
	}
	
	private void getMoreTodoDetail(JSONObject result, List<CabinetColumnVO> columnList, String primary, int tenantId) throws Exception {
		CabinetColumnVO creatorColumn = columnList.stream().filter(column -> column.getColumnId().equals("creator")).collect(Collectors.toList()).get(0);
		List<CabinetColumnVO> share   = columnList.stream().filter(column -> column.getColumnId().equals("sharelist")).collect(Collectors.toList());
		String creatorId              = creatorColumn.getColumnValue();
		SimpleUserInfoVO creatorVO    = cabinetService.getSimpleUserInfo(creatorId, primary, tenantId);
		
		if (creatorVO == null) {
			creatorVO = new SimpleUserInfoVO(creatorId, creatorId);
		}
		
		if (share != null && share.size() > 0 && share.get(0).getColumnValue() != null && !share.get(0).getColumnValue().equals("")) {
			List<String> shareIds            = Arrays.asList(share.get(0).getColumnValue().split(";"));
			List<SimpleUserInfoVO> listShare = cabinetService.getUsersInfoFromIdList(shareIds, primary, tenantId);
			result.put("shares", listShare);
		}
		
		result.put("creator"  , creatorVO);
	}
	
	private void getMoreScheduleDetail(JSONObject result, List<CabinetColumnVO> columnList, String primary, int tenantId) throws Exception {
		CabinetColumnVO creatorColumn = columnList.stream().filter(column -> column.getColumnId().equals("creator")).collect(Collectors.toList()).get(0);
		List<CabinetColumnVO> attend  = columnList.stream().filter(column -> column.getColumnId().equals("attendant")).collect(Collectors.toList());
		String creatorId              = creatorColumn.getColumnValue();
		SimpleUserInfoVO creatorVO    = cabinetService.getSimpleUserInfo(creatorId, primary, tenantId);
		
		if (creatorVO == null) {
			creatorVO = new SimpleUserInfoVO(creatorId, creatorId);
		}
		
		if (attend != null && attend.size() > 0 && !attend.get(0).getColumnValue().equals("")) {
			List<String> attendIds            = Arrays.asList(attend.get(0).getColumnValue().split(";"));
			List<SimpleUserInfoVO> listAttend = cabinetService.getUsersInfoFromIdList(attendIds, primary, tenantId);
			result.put("attend", listAttend);
		}
		
		result.put("creator", creatorVO);
	}
	
	private void getMoreOptionDetail(JSONObject result, List<CabinetColumnVO> columnList, String primary, int tenantId) throws Exception {
		CabinetColumnVO writerColumn = columnList.stream().filter(column -> column.getColumnId().equals("optionWriter")).collect(Collectors.toList()).get(0);
		
		String writerId              = writerColumn.getColumnValue();
		SimpleUserInfoVO writerVO    = cabinetService.getSimpleUserInfo(writerId, primary, tenantId);
		
		if (writerVO == null) {
			writerVO = new SimpleUserInfoVO(writerId, writerId);
		}
		
		result.put("writerVO",  writerVO);
	}
	
	private void getMoreResourceDetail(JSONObject result, List<CabinetColumnVO> columnList, String primary, int tenantId) throws Exception {
		CabinetColumnVO creatorColumn = columnList.stream().filter(column -> column.getColumnId().equals("creator")).collect(Collectors.toList()).get(0);
		
		String creatorId              = creatorColumn.getColumnValue();
		SimpleUserInfoVO creatorVO    = cabinetService.getSimpleUserInfo(creatorId, primary, tenantId);
		
		if (creatorVO == null) {
			creatorVO = new SimpleUserInfoVO(creatorId, creatorId);
		}
		
		result.put("creator", creatorVO);
	}
	
	private void getMoreBoardDetail(JSONObject result, List<CabinetColumnVO> columnList, String primary, int tenantId) throws Exception {
		CabinetColumnVO writerColumn = columnList.stream().filter(column -> column.getColumnId().equals("boardWriter")).collect(Collectors.toList()).get(0);
		CabinetColumnVO typeColumn   = columnList.stream().filter(column -> column.getColumnId().equals("boardType")).collect(Collectors.toList()).get(0);
		
		String writerId              = writerColumn.getColumnValue();
		SimpleUserInfoVO writerVO    = cabinetService.getSimpleUserInfo(writerId, primary, tenantId);
		
		if (writerVO == null) {
			writerVO = new SimpleUserInfoVO(writerId, "");
		}
		
		result.put("boardType", typeColumn.getColumnValue());
		result.put("writerVO" , writerVO);
	}
	
	private void getMoreAddressDetail(JSONObject result, List<CabinetColumnVO> columnList, String primary, int tenantId) throws Exception {
		CabinetColumnVO addressType   = columnList.stream().filter(column -> column.getColumnId().equals("addresstype")).collect(Collectors.toList()).get(0);
		CabinetColumnVO creatorColumn = columnList.stream().filter(column -> column.getColumnId().equals("creator")).collect(Collectors.toList()).get(0);
		CabinetColumnVO modifyColumn  = columnList.stream().filter(column -> column.getColumnId().equals("modifier")).collect(Collectors.toList()).get(0);
		
		String creatorId              = creatorColumn.getColumnValue();
		String modifierId             = modifyColumn.getColumnValue();
		SimpleUserInfoVO creator      = cabinetService.getSimpleUserInfo(creatorId, primary, tenantId);
		SimpleUserInfoVO modifier     = cabinetService.getSimpleUserInfo(modifierId, primary, tenantId);
		
		if (creator == null) {
			creator = new SimpleUserInfoVO(creatorId, creatorId);
		}
		
		if (modifier == null) {
			modifier = new SimpleUserInfoVO(modifierId, modifierId);
		}
		
		result.put("creator" ,    creator);
		result.put("modifier",    modifier);
		result.put("addresstype", addressType.getColumnValue());
	}
	
	private void getMoreEmailDetail(JSONObject result, List<CabinetColumnVO> columnList, String primary, int tenantId) throws Exception {
		CabinetColumnVO sender    = columnList.stream().filter(column -> column.getColumnId().equals("sender")).collect(Collectors.toList()).get(0);
		CabinetColumnVO receivers = columnList.stream().filter(column -> column.getColumnId().equals("receiver")).collect(Collectors.toList()).get(0);
		
		if (sender == null || sender.getColumnValue().equals("") || receivers == null || receivers.getColumnValue().equals("")) {
			logger.debug("Invalid data!");
			throw new Exception();
		}
		
		List<String> senderMail     = new ArrayList<>();
		SimpleUserMailVO senderUser = new SimpleUserMailVO();
		String senderEmail          = sender.getColumnValue();
		senderMail.add(senderEmail);
		List<SimpleUserMailVO> listSender = cabinetService.getUserInfoFromEmail(senderMail, primary, tenantId);
		
		if (listSender != null && listSender.size() > 0) {
			senderUser = listSender.get(0);
		}
		else {
			//Cannot find this sender user
			senderUser.setUserEmail(senderEmail);
			senderUser.setUserName(senderEmail);
		}
		
		result.put("sender", senderUser);
		
		List<String> receiverMail           = Arrays.asList(receivers.getColumnValue().split(";"));
		List<SimpleUserMailVO> listReceiver = cabinetService.getUserInfoFromEmail(receiverMail, primary, tenantId);
		result.put("receivers", listReceiver);
		
		List<CabinetColumnVO> forwards = columnList.stream().filter(column -> column.getColumnId().equals("forward")).collect(Collectors.toList());
		
		if (forwards != null && forwards.size() > 0 && !forwards.get(0).getColumnValue().equals("")) {
			List<String> forwardMail           = Arrays.asList(forwards.get(0).getColumnValue().split(";"));
			List<SimpleUserMailVO> listForward = cabinetService.getUserInfoFromEmail(forwardMail, primary, tenantId);
			result.put("forwards", listForward);
		}
	}
	
	@RequestMapping(value="/rest/ezcabinet/relate-item/save/option", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject saveOptionitem(@RequestBody JSONObject optionItemInf, Locale locale, HttpServletRequest request) throws Exception {
		String serverName  = request.getHeader("host-name")  != null ? request.getHeader("host-name")             : "";
		String userId      = optionItemInf.get("userId")     != null ? optionItemInf.get("userId").toString()     : "";
		String mode        = optionItemInf.get("mode")       != null ? optionItemInf.get("mode").toString()       : "";
		String cabinetId   = optionItemInf.get("cabinet")    != null ? optionItemInf.get("cabinet").toString()    : "";
		String title       = optionItemInf.get("title")      != null ? optionItemInf.get("title").toString()      : "";
		String summary     = optionItemInf.get("summary")    != null ? optionItemInf.get("summary").toString()    : "";
		String optionTitle = optionItemInf.get("optionTitle")!= null ? optionItemInf.get("optionTitle").toString(): "";
		String writer      = optionItemInf.get("writer")     != null ? optionItemInf.get("writer").toString()     : "";
		String date        = optionItemInf.get("date")       != null ? optionItemInf.get("date").toString()       : "";
		String content     = optionItemInf.get("content")    != null ? optionItemInf.get("content").toString()    : "";
		String attach      = optionItemInf.get("attach")     != null ? optionItemInf.get("attach").toString()     : "";
		
		JSONObject result = new JSONObject();
		
		logger.debug("mode: " + mode + " || cabinetId: " + cabinetId + " || title: " + title + " || summary: " + summary + " || optionTitle: " + optionTitle + " || writer: " + writer + " || date: "  + date + " || content : " + content +  " || attach: " + attach);
		
		if (serverName.equals("") || userId.equals("") || mode.equals("") || (mode.equals("1") && cabinetId.equals("")) || title.equals("") || optionTitle.equals("") || writer.equals("") || date.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int dstCabinetId = cabinetId.equals("") ? -1 : Integer.parseInt(cabinetId);
			String realPath  = request.getServletContext().getRealPath("");
			result           = cabinetService_h.saveOptionItem(realPath, mode, dstCabinetId, title, summary, optionTitle, writer, date, content, attach, locale, userInfo);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/relate-item/save/community", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject saveCommunityitem(@RequestBody JSONObject commuItemInf, Locale locale, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name")!= null ? request.getHeader("host-name")           : "";
		String userId     = commuItemInf.get("userId")    != null ? commuItemInf.get("userId").toString()    : "";
		String mode       = commuItemInf.get("mode")      != null ? commuItemInf.get("mode").toString()      : "";
		String cabinetId  = commuItemInf.get("cabinet")   != null ? commuItemInf.get("cabinet").toString()   : "";
		String title      = commuItemInf.get("title")     != null ? commuItemInf.get("title").toString()     : "";
		String summary    = commuItemInf.get("summary")   != null ? commuItemInf.get("summary").toString()   : "";
		String commuTitle = commuItemInf.get("commuTitle")!= null ? commuItemInf.get("commuTitle").toString(): "";
		String writer     = commuItemInf.get("writer")    != null ? commuItemInf.get("writer").toString()    : "";
		String date       = commuItemInf.get("date")      != null ? commuItemInf.get("date").toString()      : "";
		String endDate    = commuItemInf.get("endDate")   != null ? commuItemInf.get("endDate").toString()   : "";
		String content    = commuItemInf.get("content")   != null ? commuItemInf.get("content").toString()   : "";
		String attach     = commuItemInf.get("attach")    != null ? commuItemInf.get("attach").toString()    : "";
		
		JSONObject result = new JSONObject();
		
		logger.debug("mode: " + mode + " || cabinetId: " + cabinetId + " || title: " + title + " || summary: " + summary  + " || commuTitle: " + commuTitle +  " || writer: " + writer + " || date: "  + date + " || endDate: " + endDate + " || content : " + content +  " || attach: " + attach);
		
		if (serverName.equals("") || userId.equals("") || mode.equals("") || (mode.equals("1") && cabinetId.equals(""))|| title.equals("") || commuTitle.equals("") || writer.equals("") || date.equals("") || endDate.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int dstCabinetId = cabinetId.equals("") ? -1 : Integer.parseInt(cabinetId);
			String realPath  = request.getServletContext().getRealPath("");
			result           = cabinetService_h.saveCommunityItem(realPath, mode, dstCabinetId, title, summary, commuTitle, writer, date, endDate, content, attach, locale, userInfo);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/relate-item/save/photo-community", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject savePhotoCommunityitem(@RequestBody JSONObject commuItemInf, Locale locale, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name")!= null ? request.getHeader("host-name")            : "";
		String userId     = commuItemInf.get("userId")    != null ? commuItemInf.get("userId").toString()     : "";
		String mode       = commuItemInf.get("mode")      != null ? commuItemInf.get("mode").toString()       : "";
		String cabinetId  = commuItemInf.get("cabinet")   != null ? commuItemInf.get("cabinet").toString()    : "";
		String title      = commuItemInf.get("title")     != null ? commuItemInf.get("title").toString()      : "";
		String summary    = commuItemInf.get("summary")   != null ? commuItemInf.get("summary").toString()    : "";
		String commuTitle = commuItemInf.get("commuTitle")!= null ? commuItemInf.get("commuTitle").toString() : "";
		String writer     = commuItemInf.get("writer")    != null ? commuItemInf.get("writer").toString()     : "";
		String content    = commuItemInf.get("content")   != null ? commuItemInf.get("content").toString()    : "";
		
		JSONObject result = new JSONObject();
		
		logger.debug("mode: " + mode + " || cabinetId: " + cabinetId + " || title: " + title + " || summary: " + summary + " || commuTitle: " + commuTitle + " || writer: " + writer + " || content : " + content);
		
		if (serverName.equals("") || userId.equals("") || mode.equals("") || (mode.equals("1") && cabinetId.equals(""))|| title.equals("") || commuTitle.equals("") || writer.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int dstCabinetId = cabinetId.equals("") ? -1 : Integer.parseInt(cabinetId);
			String realPath  = request.getServletContext().getRealPath("");
			result           = cabinetService_h.savePhotoCommunityitem(realPath, mode, dstCabinetId, title, summary, commuTitle, writer, content, locale, userInfo);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
}
