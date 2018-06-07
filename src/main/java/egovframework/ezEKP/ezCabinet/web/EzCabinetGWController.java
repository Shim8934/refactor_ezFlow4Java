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
import egovframework.com.cmm.EgovMessageSource;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@RestController
public class EzCabinetGWController {
	private static final Logger logger = LoggerFactory.getLogger(EzCabinetGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezcabinet/check-admin/{userid}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject checkCabinetAdmin(@PathVariable(value="userid") String userId, HttpServletRequest request, Locale locale) {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || userId: " + userId);
		
		if (serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			result.put("reason", egovMessageSource.getMessage("ezCabinet.err1", locale));
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			boolean check    = isCabinetAdmin(userInfo);
			
			if (check == true) {
				result.put("data", "1");
			}
			else {
				result.put("data", "0");
				result.put("reason", egovMessageSource.getMessage("ezCabinet.t08", locale));
			}
			
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("reason", egovMessageSource.getMessage("ezCabinet.err2", locale));
		}
		
		return result;
	}
	
	private boolean isCabinetAdmin(LoginVO user) {
		return user.getRollInfo().contains("cb=1");
	}
}
