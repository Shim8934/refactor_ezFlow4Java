package egovframework.ezEKP.ezCabinet.web;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;

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
import egovframework.ezEKP.ezCabinet.vo.UserCapacityVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezWebFolder.vo.SimpleUserVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@SuppressWarnings("unchecked")
@RestController
public class EzCabinetGWController_m {
	private static final Logger logger = LoggerFactory.getLogger(EzCabinetGWController_m.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzCabinetService cabinetService;
	
	@Autowired
	private EzCabinetAdminService cabinetAdminService;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Autowired
	private EzCabinetService_h cabinetService_m;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@RequestMapping(value="/rest/ezcabinet/relate-item/save/apprv", method=RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject saveRelatedApproval(Locale locale, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name")        != null ? request.getHeader("host-name")        : "";
		String divContent = request.getParameter("divContent")    != null ? request.getParameter("divContent")    : "";
		String userId     = request.getParameter("userId")        != null ? request.getParameter("userId")   : "";
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || divContent: " + divContent + " || userId: " + userId); 
		
		if (serverName.equals("") || divContent.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo       = commonUtil.getUserForGw(userId, serverName);
			JSONArray forwardList  = new JSONArray();
			
			//Save receiver list
			
		}
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
		
	
}
