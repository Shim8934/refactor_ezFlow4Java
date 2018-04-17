package egovframework.ezEKP.ezPMS.web;

import java.util.Properties;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import egovframework.ezMobile.ezCommon.web.MCommonGWController;
import egovframework.let.utl.fcc.service.CommonUtil;

@RestController
public class EzPMSGWController2 {

	private static final Logger LOGGER = LoggerFactory.getLogger(EzPMSGWController2.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@RequestMapping(value = "/rest/ezPMS/users/{userId}/test", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject test(@PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/users/"+userId+"] started.");
		
		JSONObject result = new JSONObject();
		result.put("test", "ok");
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/users/"+userId+"] ended.");
		return result;
	}

}
