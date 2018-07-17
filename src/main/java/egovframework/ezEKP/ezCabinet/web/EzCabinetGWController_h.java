package egovframework.ezEKP.ezCabinet.web;

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

import egovframework.ezEKP.ezCabinet.service.EzCabinetService;
import egovframework.ezEKP.ezCabinet.service.EzCabinetService_h;
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
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@RequestMapping(value="/rest/ezcabinet/userinfo/{userid}", method=RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getUserInfo(@PathVariable(value="userid") String userId, HttpServletRequest request, Locale locale) {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || UserId: " + userId);
		
		if (serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try{
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			result.put("data", userInfo);
			result.put("status", "ok");
			result.put("code", 0);
			
		}catch(Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
}
