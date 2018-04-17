package egovframework.ezEKP.ezPMS.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import egovframework.ezMobile.ezCommon.web.MCommonGWController;
import egovframework.let.utl.fcc.service.CommonUtil;

@RestController
public class EzPMSGWController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MCommonGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/projects/userId/{userId}", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getProjectList(@PathVariable String userId, HttpServletRequest request) throws Exception {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/userId/"+userId+"] started.");
		
		JSONObject result = new JSONObject();
		
		try{
			String serverName = request.getHeader("x-user-host");
			String projectName = request.getParameter("projectName");
			String planStartDate = request.getParameter("planStartDate");
			String overview = request.getParameter("overview");
			
			int count = 5;
			
			List<String> list = new ArrayList<>();
			list.add(projectName);
			list.add(serverName);
			list.add(planStartDate);
			list.add(overview);
			
			JSONObject data = new JSONObject();
			data.put("count", count);
			data.put("list", list);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
			
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/projects/userId/"+userId+"] ended.");
		return result;
	}

}
