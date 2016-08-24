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
		int result = -100; 
				
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);

			resultCode = (String)responseObj.get("resultCode");		
			
			if (resultCode.equals("OK")) {
				result = ((Long)responseObj.get("result")).intValue();
			}
		}						
		
		logger.debug("addUser ended. resultCode=" + resultCode + ",result=" + result);
		
		return result;
	}

	@Override
	public int updateUserPassword(String userEmailAddress, String newPassword) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public boolean testUserPassword(String userEmailAddress, String password) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public int removeUser(String userEmailAddress) {
		// TODO Auto-generated method stub
		return 0;
	}

}
