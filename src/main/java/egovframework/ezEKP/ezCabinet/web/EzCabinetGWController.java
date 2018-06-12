package egovframework.ezEKP.ezCabinet.web;

import java.util.ArrayList;
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
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@RestController
public class EzCabinetGWController {
	private static final Logger logger = LoggerFactory.getLogger(EzCabinetGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
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
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			boolean check    = isCabinetAdmin(userInfo);
			
			if (check == true) {
				result.put("status", "ok");
				result.put("code", 0);
			}
			else {
				result.put("status", "error");
				result.put("code", 3);
			}
			
			
		} 
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezcabinet/company-list/{userid}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getCompanyList(@PathVariable(value="userid") String userId, HttpServletRequest request, Locale locale) {
		String serverName = request.getHeader("host-name")   != null ? request.getHeader("host-name") : "";
		String mode       = request.getParameter("mode")     != null ? request.getParameter("mode")   : "";
		JSONObject result = new JSONObject();
		logger.debug("serverName: " + serverName);
		
		if (serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			//Get list of companies
			List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
			
			if (userInfo.getRollInfo().indexOf("c=1")  > -1 && !mode.equals("normal")) {
				resultList = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
			}
			else {
				OrganDeptVO dept = ezOrganService.getDeptInfo(userInfo.getCompanyID(), userInfo.getPrimary(), userInfo.getTenantId());
				resultList.add(dept);
			}
			
			result.put("data", resultList);
			result.put("userCompany", userInfo.getCompanyID());
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
	
	private boolean isCabinetAdmin(LoginVO user) {
		return user.getRollInfo().contains("cb=1");
	}
}
