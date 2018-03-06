package egovframework.ezEKP.ezAttitude.web;

import java.util.Properties;

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
import egovframework.ezEKP.ezAttitude.service.EzAttitudeService;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@RestController
public class EzAttitudeGWController {
	private static final Logger LOGGER = LoggerFactory.getLogger(EzAttitudeGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name="crypto")
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name = "EzAttitudeService")
	private EzAttitudeService ezAttitudeService;
	
	@RequestMapping(value = "/ezattitude/users/{userId}/attitude-list", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject userAttitudeMainList(@PathVariable String userId, HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /ezattitude/users/" + userId + "/attitude-list] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			
		} catch (Exception e) {
			
		}
		LOGGER.debug("G/W EzAttitude [GET /ezattitude/users/" + userId + "/attitude-list] ended.");
		return result;
	}
	
	@RequestMapping(value = "/ezattitude/attitude-list", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject AttitudeList (HttpServletRequest request) {
		LOGGER.debug("G/W EzAttitude [GET /ezattitude/attitude-list] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			
		} catch (Exception e) {
			
		}
		LOGGER.debug("G/W EzAttitude [GET /ezattitude/attitude-list] ended.");
		return result;
	}
}
