package egovframework.ezEKP.ezEmail.service.impl;

import java.net.URLEncoder;
import java.util.Properties;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezEmail.service.EzEmailUserAdminService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;

@Service("EzEmailUserAdminService")
public class EzEmailUserAdminServiceImpl implements EzEmailUserAdminService {

	private static final Logger logger = LoggerFactory.getLogger(EzEmailUserAdminServiceImpl.class);
	
	@Autowired
	private Properties config;
	
	@Autowired
	private EzEmailUtil ezEmailUtil;
	
	@Override
	public int addUser(String userEmailAddress, String password) throws Exception {
		logger.debug("addUser started. userEmailAddress=" + userEmailAddress);

		String userIdParam = "userEmailAddress=" + URLEncoder.encode(userEmailAddress, "UTF-8");
		String passwordParam = "password=" + URLEncoder.encode(password, "UTF-8");
		String inputParams = userIdParam + "&" + passwordParam;

		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/addUser";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

		logger.debug("response=" + response);

		String resultCode = "Error";
		int reasonCode = -100; // 웹서비스로부터 아무런 응답을 받지 못하거나 OK 응답이 오지 않은 경우를 의미
				
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);

			resultCode = (String)responseObj.get("resultCode");		
			
			if (resultCode.equals("OK")) {
				reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
			}
		}						
		
		logger.debug("addUser ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		
		return reasonCode;
	}

	@Override
	public int updateUserPassword(String userEmailAddress, String newPassword) throws Exception {
		logger.debug("updateUserPassword started. userEmailAddress=" + userEmailAddress);

		String userIdParam = "userEmailAddress=" + URLEncoder.encode(userEmailAddress, "UTF-8");
		String passwordParam = "password=" + URLEncoder.encode(newPassword, "UTF-8");
		String inputParams = userIdParam + "&" + passwordParam;

		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/updateUserPassword";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

		logger.debug("response=" + response);

		String resultCode = "Error";
		int reasonCode = -100; // 웹서비스로부터 아무런 응답을 받지 못하거나 OK 응답이 오지 않은 경우를 의미
				
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);

			resultCode = (String)responseObj.get("resultCode");		
			
			if (resultCode.equals("OK")) {
				reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
			}
		}						
		
		logger.debug("updateUserPassword ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		
		return reasonCode;		
	}

	@Override
	public boolean testUserPassword(String userEmailAddress, String password) throws Exception {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public int removeUser(String userEmailAddress) throws Exception {
		logger.debug("removeUser started. userEmailAddress=" + userEmailAddress);

		String userIdParam = "userEmailAddress=" + URLEncoder.encode(userEmailAddress, "UTF-8");
		String inputParams = userIdParam;

		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/removeUser";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

		logger.debug("response=" + response);

		String resultCode = "Error";
		int reasonCode = -100; 
				
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);

			resultCode = (String)responseObj.get("resultCode");		
			
			if (resultCode.equals("OK")) {
				reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
			}
		}						
		
		logger.debug("removeUser ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		
		return reasonCode;		
	}

	@Override
	public int retireUser(String userEmailAddress) throws Exception {
		logger.debug("retireUser started. userEmailAddress=" + userEmailAddress);

		String userIdParam = "userEmailAddress=" + URLEncoder.encode(userEmailAddress, "UTF-8");
		String inputParams = userIdParam;

		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/retireUser";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

		logger.debug("response=" + response);

		String resultCode = "Error";
		int reasonCode = -100; 
				
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);

			resultCode = (String)responseObj.get("resultCode");		
			
			if (resultCode.equals("OK")) {
				reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
			}
		}						
		
		logger.debug("retireUser ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		
		return reasonCode;		
	}
	
	@Override
	public int restoreUser(String userEmailAddress) throws Exception {
		logger.debug("restoreUser started. userEmailAddress=" + userEmailAddress);

		String userIdParam = "userEmailAddress=" + URLEncoder.encode(userEmailAddress, "UTF-8");
		String inputParams = userIdParam;

		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/restoreUser";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

		logger.debug("response=" + response);

		String resultCode = "Error";
		int reasonCode = -100; 
				
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);

			resultCode = (String)responseObj.get("resultCode");		
			
			if (resultCode.equals("OK")) {
				reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
			}
		}						
		
		logger.debug("restoreUser ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		
		return reasonCode;		
	}
	
	@Override
	public int addGroup(String groupEmailAddress) throws Exception {
		logger.debug("addGroup started. groupEmailAddress=" + groupEmailAddress);
		
		String inputParams = "groupEmail=" + URLEncoder.encode(groupEmailAddress, "UTF-8");

		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/addGroup";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

		logger.debug("response=" + response);

		String resultCode = "Error";
		int reasonCode = -100; 
				
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);

			resultCode = (String)responseObj.get("resultCode");		
			
			if (resultCode.equals("OK")) {
				reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
			}
		}
		
		logger.debug("addGroup ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		
		return reasonCode;
	}

	@Override
	public int removeGroup(String groupEmailAddress) throws Exception {
		logger.debug("removeGroup started. groupEmailAddress=" + groupEmailAddress);
		
		String inputParams = "groupEmail=" + URLEncoder.encode(groupEmailAddress, "UTF-8");

		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/delGroup";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

		logger.debug("response=" + response);

		String resultCode = "Error";
		int reasonCode = -100; 
				
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);

			resultCode = (String)responseObj.get("resultCode");		
			
			if (resultCode.equals("OK")) {
				reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
			}
		}
		
		logger.debug("removeGroup ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		
		return reasonCode;
	}
	
	@Override
	public int updateGroupAdd(String groupEmailAddress, String targetEmail) throws Exception {
		logger.debug("updateGroupAdd started");
		
		String groupEmailParam = "groupEmail=" + URLEncoder.encode(groupEmailAddress, "UTF-8");
		String targetEmailParam = "targetEmail=" + URLEncoder.encode(targetEmail, "UTF-8");
		
		String inputParams = groupEmailParam + "&" + targetEmailParam;

		logger.debug("inputParams=" + inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/updateGroupAdd";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

		logger.debug("response=" + response);
		
		String resultCode = "Error";
		int reasonCode = -100; 
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);

			resultCode = (String)responseObj.get("resultCode");		
			
			if (resultCode.equals("OK")) {
				reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
			}
		}
		
		logger.debug("updateGroupAdd ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		
		return reasonCode;
	}

	@Override
	public int updateGroupDel(String groupEmailAddress, String targetEmail) throws Exception {
		logger.debug("updateGroupDel started");
		
		String groupEmailParam = "groupEmail=" + URLEncoder.encode(groupEmailAddress, "UTF-8");
		String targetEmailParam = "targetEmail=" + URLEncoder.encode(targetEmail, "UTF-8");
		
		String inputParams = groupEmailParam + "&" + targetEmailParam;

		logger.debug("inputParams=" + inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/updateGroupDel";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

		logger.debug("response=" + response);
		
		String resultCode = "Error";
		int reasonCode = -100; 
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);

			resultCode = (String)responseObj.get("resultCode");		
			
			if (resultCode.equals("OK")) {
				reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
			}
		}
		
		logger.debug("updateGroupDel ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		
		return reasonCode;
	}

	@Override
	public int updateGroupMove(String oldGroupEmailAddress, String newGroupEmailAddress, String targetEmail)
			throws Exception {
		logger.debug("updateGroupMove started");
		
		String oldGroupEmailParam = "oldGroupEmail=" + URLEncoder.encode(oldGroupEmailAddress, "UTF-8");
		String newGroupEmailParam = "newGroupEmail=" + URLEncoder.encode(newGroupEmailAddress, "UTF-8");
		String targetEmailParam = "targetEmail=" + URLEncoder.encode(targetEmail, "UTF-8");
		
		String inputParams = oldGroupEmailParam + "&" + newGroupEmailParam + "&" + targetEmailParam;

		logger.debug("inputParams=" + inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/updateGroupMove";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

		logger.debug("response=" + response);
		
		String resultCode = "Error";
		int reasonCode = -100; 
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);

			resultCode = (String)responseObj.get("resultCode");		
			
			if (resultCode.equals("OK")) {
				reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
			}
		}
		
		logger.debug("updateGroupMove ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		
		return reasonCode;
	}

}
