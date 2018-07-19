package egovframework.ezEKP.ezCabinet.web;

import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCabinet.service.EzCabinetService;
import egovframework.ezEKP.ezCabinet.service.EzCabinetService_h;
import egovframework.ezEKP.ezCabinet.vo.CabinetShareVO;
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
	
	@RequestMapping(value="/rest/ezCabinet/share/cabinetId/{cabinetId}/get", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getShareUserList(@PathVariable(value="cabinetId") String cabinetId,   HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name")   != null ? request.getHeader("host-name")     : "";
		String userId     = request.getParameter("userId")   != null ? request.getParameter("userId")     : "";
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || UserId: " + userId);
		
		if (serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo          = commonUtil.getUserForGw(userId, serverName);
			List<CabinetShareVO> list = cabinetService_h.getShareUserList(cabinetId, userId, userInfo.getPrimary(), userInfo.getTenantId());
			
			result.put("data", list);
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
}
