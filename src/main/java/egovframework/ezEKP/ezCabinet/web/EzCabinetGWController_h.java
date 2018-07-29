package egovframework.ezEKP.ezCabinet.web;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
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
	
	@RequestMapping(value="/rest/ezCabinet/dept-member/{deptid}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
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
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
		}
		
		return result;
		
	}
	
	@RequestMapping(value="/rest/ezCabinet/shared-member/cabinetId/{cabinetId}/get", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getShareUserList(@PathVariable(value="cabinetId") String cabinetId,   HttpServletRequest request) throws Exception {
		String serverName     = request.getHeader("host-name")       != null ? request.getHeader("host-name")            : "";
		String userId         = request.getParameter("userId")       != null ? request.getParameter("userId")            : "";
		String searchOpt      = request.getParameter("searchOpt")    != null ? request.getParameter("searchOpt")         : "";
		String searchValue    = request.getParameter("searchValue")  != null ? request.getParameter("searchValue")       : "";
		
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || UserId: " + userId + " || searchOpt: " + searchOpt + " || searchValue: " + searchValue);
		
		if (serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo          = commonUtil.getUserForGw(userId, serverName);
			String primary = userInfo.getPrimary();
			String sqlQuery                = "";
			
			switch(searchOpt) {
				case "displayname": sqlQuery = primary.equals("1") ? searchOpt : "displayname2" ; break;
				case "description": sqlQuery = primary.equals("1") ? searchOpt : "description2" ; break;
				default: sqlQuery = searchOpt;
			}
			
			List<SimpleUserVO> list = cabinetService_h.getShareUserList(cabinetId, userId, sqlQuery, searchValue, primary, userInfo.getTenantId());
			
			result.put("shareList", list);
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
	
	@RequestMapping(value="/rest/ezCabinet/list-type/userid/{userid}/get", method= RequestMethod.GET, produces="application/json;charset=utf-8")
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
	
	@RequestMapping(value="/rest/ezCabinet/list-type/userid/{userid}/save", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
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
			e.printStackTrace();
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
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
		}
		
		return result;
		
	}
	
	@RequestMapping(value="/rest/ezCabinet/shared-member/cabinetId/{cabinetId}/save", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject saveShareUserList(@PathVariable(value="cabinetId") String cabinetId,   HttpServletRequest request) throws Exception {
		String serverName     = request.getHeader("host-name")       != null ? request.getHeader("host-name")            : "";
		String userId         = request.getParameter("userId")       != null ? request.getParameter("userId")            : "";
		String userList       = request.getParameter("userList")     != null ? request.getParameter("userList")          : "";
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
			e.printStackTrace();
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
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezCabinet/file-detail/itemId/{itemId}/get", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getFileDetail(@PathVariable(value="itemId") String itemId,   HttpServletRequest request) throws Exception {
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
			
			if(fileDetail.getItemType() != 0) {
				//Get related columns
				List<CabinetColumnVO> columnList = cabinetService.getAllRelatedColumnsOfItem(itemId, primary, tenantId);
				if (columnList != null && columnList.size() > 0) {
					result.put("columns", columnList);
				}
				
				//Check if is email type
				if (fileDetail.getItemType() == 1) {
					CabinetColumnVO sender = columnList.stream().filter(column -> column.getColumnId().equals("sender")).collect(Collectors.toList()).get(0);
					CabinetColumnVO receivers = columnList.stream().filter(column -> column.getColumnId().equals("receiver")).collect(Collectors.toList()).get(0);
					
					if (sender == null || sender.getColumnValue().equals("") || receivers == null || receivers.getColumnValue().equals("")) {
						logger.debug("Invalid data!");
						result.put("status", "error");
						result.put("code", 2);
					}
					
					List<String> senderMail = new ArrayList<>();
					senderMail.add(sender.getColumnValue());
					SimpleUserMailVO senderUser = cabinetService.getUserInfoFromEmail(senderMail, primary, tenantId).get(0);
					result.put("sender", senderUser);
					
					List<String> receiverMail           = Arrays.asList(receivers.getColumnValue().split(";"));
					List<SimpleUserMailVO> listReceiver = cabinetService.getUserInfoFromEmail(receiverMail, primary, tenantId);
					result.put("receivers", listReceiver);
					
					CabinetColumnVO forwards = columnList.stream().filter(column -> column.getColumnId().equals("forward")).collect(Collectors.toList()).get(0);
					
					if (forwards != null && !forwards.getColumnValue().equals("")) {
						List<String> forwardMail           = Arrays.asList(forwards.getColumnValue().split(";"));
						List<SimpleUserMailVO> listForward = cabinetService.getUserInfoFromEmail(forwardMail, primary, tenantId);
						result.put("forwards", listForward);
					}
				}
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
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezCabinet/file-info/itemId/{itemId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject cabinetItemInfo(@PathVariable(value="itemId") String itemId,   HttpServletRequest request) throws Exception {
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
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			String primary   = userInfo.getPrimary();
			int tenantId     = userInfo.getTenantId();
			String offset    = commonUtil.getMinuteUTC(userInfo.getOffset());
			
			CabinetItemVO fileDetail                    = cabinetService_h.getFileDetail(itemId, primary, offset, tenantId);
			
			result.put("itemType", fileDetail.getItemType());
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
	
	@RequestMapping(value="/rest/ezcabinet/item/id/{itemId}/modify", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject modifyItem(@PathVariable(value="itemId") String itemId, Locale locale, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name")     != null ? request.getHeader("host-name")     : "";
		String title      = request.getParameter("title")      != null ? request.getParameter("title")      : "";
		String summary    = request.getParameter("summary")    != null ? request.getParameter("summary")    : "";
		String fileArray  = request.getParameter("fileArray")  != null ? request.getParameter("fileArray")  : "";
		String relatedArr = request.getParameter("relatedArr") != null ? request.getParameter("relatedArr") : "";
		String userId     = request.getParameter("userId")     != null ? request.getParameter("userId")     : "";
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
			LoginVO userInfo          = commonUtil.getUserForGw(userId, serverName);
			
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
						File file          = new File(realPath + filePath);
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
			
			cabinetService_h.modifyItem(Integer.parseInt(itemId), attacheFiles, relatedFiles, title, summary, realPath, userInfo);
			
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
