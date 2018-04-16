package egovframework.ezEKP.ezPMS.web;

import java.util.Properties;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import egovframework.ezMobile.ezCommon.web.MCommonGWController;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzPMSGWController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MCommonGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@RequestMapping(value = "/rest/ezPMS/projects/userId/{userId}", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONArray getProjectList(@PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/userId/"+userId+"] started.");
		
		
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/userId/"+userId+"] ended.");
		return null;
	}

}
