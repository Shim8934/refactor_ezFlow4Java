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
	private EzCabinetService_h cabinetService_h;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@RequestMapping(value="/rest/ezCabinet/dept-member/{deptid}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getDeptMembers(@PathVariable(value="deptid") String deptId, Locale locale, HttpServletRequest request) {
		String serverName = request.getHeader("host-name")     != null ? request.getHeader("host-name")      : "";
		String userId     = request.getParameter("userId")     != null ? request.getParameter("userId")      : "";
		String srchOption = request.getParameter("srchOption") != null ? request.getParameter("srchOption")  : "";
		String srchValue  = request.getParameter("srchValue")  != null ? request.getParameter("srchOption")  : "";
		
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || UserId: " + userId + "|| SrchOption: " + srchOption + "|| srchValue: " + srchValue);
		
		if (serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo               = commonUtil.getUserForGw(userId, serverName);
			int tenantId                   = userInfo.getTenantId();
			String primary                 = userInfo.getPrimary();
			List<SimpleUserVO> memberList = cabinetService_h.getDeptMemberList(deptId, primary, srchOption, srchValue, tenantId);
			
			result.put("memberList", memberList);
			result.put("memberCount", memberList.size());
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
			int tenantId     = userInfo.getTenantId();
			String primary   = userInfo.getPrimary();
			
			List<CabinetShareVO> list = cabinetService_h.getShareUserList(cabinetId, userId, userInfo.getPrimary(), tenantId);
			
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
}
