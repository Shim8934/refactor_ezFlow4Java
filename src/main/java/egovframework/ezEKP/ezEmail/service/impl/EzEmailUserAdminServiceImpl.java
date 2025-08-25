package egovframework.ezEKP.ezEmail.service.impl;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailUserAdminService;
import egovframework.ezEKP.ezEmail.task.EzEmailAsync;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;

@Service("EzEmailUserAdminService")
public class EzEmailUserAdminServiceImpl implements EzEmailUserAdminService {

	private static final Logger logger = LoggerFactory.getLogger(EzEmailUserAdminServiceImpl.class);
	
	@Autowired
	private Properties config;
	
	@Autowired
	private EzEmailUtil ezEmailUtil;
	
	@Autowired
	private EzEmailAsync ezEmailAsync;
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	@Override
	public int addUser(String userEmailAddress, String password) throws Exception {
		logger.debug("addUser started. userEmailAddress=" + userEmailAddress);

		String userIdParam = "userEmailAddress=" + URLEncoder.encode(userEmailAddress, "UTF-8");
		String passwordParam = "password=" + URLEncoder.encode(password, "UTF-8");
		String inputParams = userIdParam + "&" + passwordParam;

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
	public int checkUserExists(String userEmailAddress) throws Exception {
		logger.debug("checkUserExists started. userEmailAddress=" + userEmailAddress);

		String userIdParam = "userEmailAddress=" + URLEncoder.encode(userEmailAddress, "UTF-8");
		String inputParams = userIdParam;

		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/checkUserExists";
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
		
		logger.debug("checkUserExists ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		
		return reasonCode;
	}
	
	@Override
	public int updateUserPassword(String userEmailAddress, String newPassword) throws Exception {
		logger.debug("updateUserPassword started. userEmailAddress=" + userEmailAddress);

		String userIdParam = "userEmailAddress=" + URLEncoder.encode(userEmailAddress, "UTF-8");
		String passwordParam = "password=" + URLEncoder.encode(newPassword, "UTF-8");
		String inputParams = userIdParam + "&" + passwordParam;

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
	public int checkAndUpdateUserPassword(String userEmailAddress, String curPassword, String newPassword) throws Exception {
        logger.debug("checkAndUpdateUserPassword started. userEmailAddress=" + userEmailAddress);

        String userIdParam = "userEmailAddress=" + URLEncoder.encode(userEmailAddress, "UTF-8");
        String curPasswordParam = "curPassword=" + URLEncoder.encode(curPassword, "UTF-8");
        String newPasswordParam = "newPassword=" + URLEncoder.encode(newPassword, "UTF-8");
        String inputParams = userIdParam + "&" + curPasswordParam + "&" + newPasswordParam;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/checkAndUpdateUserPassword";
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
        
        logger.debug("checkAndUpdateUserPassword ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return reasonCode;      	    
	}
	
	@Override
	public String getEncryptedUserPassword(String userEmailAddress) throws Exception {
		logger.debug("getEncryptedUserPassword started. userEmailAddress=" + userEmailAddress);

		String userIdParam = "userEmailAddress=" + URLEncoder.encode(userEmailAddress, "UTF-8");
		String inputParams = userIdParam;

		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getEncryptedUserPassword";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

		logger.debug("response=" + response);

		String resultCode = "Error";
		int reasonCode = -100; 
		String password = null;
				
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);

			resultCode = (String)responseObj.get("resultCode");		
			
			if (resultCode.equals("OK")) {
				reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
				
				if (reasonCode == 0) {
					JSONObject result = (JSONObject)responseObj.get("result");
					
					if (result != null) {
						password = (String)result.get("password");
					}					
				}
			}
		}						
		
		logger.debug("getEncryptedUserPassword ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		
		return password;		
	}
	
	@Override
	public int updateUserPasswordWithEncryptedPassword(String userEmailAddress, String encryptedPassword) throws Exception {
		logger.debug("updateUserPasswordWithEncryptedPassword started. userEmailAddress=" + userEmailAddress);

		String userIdParam = "userEmailAddress=" + URLEncoder.encode(userEmailAddress, "UTF-8");
		String passwordParam = "encryptedPassword=" + URLEncoder.encode(encryptedPassword, "UTF-8");
		String inputParams = userIdParam + "&" + passwordParam;

		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/updateUserPasswordWithEncryptedPassword";
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
		
		logger.debug("updateUserPasswordWithEncryptedPassword ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		
		return reasonCode;		
	}
	
	@Override
	public boolean testUserPassword(String userEmailAddress, String password) throws Exception {
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
	public int removeUserAllMailboxes(String userEmailAddress) throws Exception {
		logger.debug("removeUserAllMailboxes started. userEmailAddress=" + userEmailAddress);

		String userIdParam = "userEmailAddress=" + URLEncoder.encode(userEmailAddress, "UTF-8");
		String inputParams = userIdParam;

		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/removeUserAllMailboxes";
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
		
		logger.debug("removeUserAllMailboxes ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		
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

	@Override
	public List<String> getUserDistributionList(String userEmailAddress) {
		logger.debug("getUserDistributionList started.");
		
		ArrayList<String> returnData = new ArrayList<String>();
				
		try {
			String inputParams = "userEmailAddress=" + userEmailAddress;
			
			logger.debug("inputParams=" + inputParams);
			
			String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getUserDistribution";
			String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
			
			logger.debug("response=" + response);
			
			JSONArray resultArray = null;
			
			if (response != null) {
				JSONParser jsonParser = new JSONParser();
				JSONObject responseObj = (JSONObject)jsonParser.parse(response);

				String resultCode = (String)responseObj.get("resultCode");
				
				if (resultCode.equalsIgnoreCase("OK")) {
					resultArray = (JSONArray)responseObj.get("result");
					
					for (int i = 0; i < resultArray.size(); i++) {
						JSONObject distribution = (JSONObject)resultArray.get(i);
						String distributionName = (String)distribution.get("distributionName");
						
						logger.debug("distributionName=" + distributionName);
						
						returnData.add(distributionName);
					}					
				}
			}						
		} catch (ParseException e) {
			logger.error(e.getMessage(), e);
        } catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("getUserDistributionList ended.");
		
		return returnData;
	}
	
	@Override
	public int deleteAllUserDistributionForMember(String targetEmail, String domain) throws Exception {
		logger.debug("deleteAllUserDistributionForMember started.");
		logger.debug("targetEmail=" + targetEmail + ", domain=" + domain);
		
		int reasonCode = -100;
		
		try {
			String inputParams = "targetEmail=" + targetEmail + "&domain=" + domain;
			
			String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/deleteAllUserDistributionForMember";
			String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
			logger.debug("response=" + response);
			
			if (response != null) {
				JSONParser jsonParser = new JSONParser();
				JSONObject responseObj = (JSONObject)jsonParser.parse(response);
				String resultCode = (String)responseObj.get("resultCode");
				
				if (resultCode.equalsIgnoreCase("OK")) {
					reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
				}
			}	
		} catch (ParseException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("deleteAllUserDistributionForMember ended.");
		return reasonCode;
	}
	
	@Override
	public String getCopyrightText(int tenantId, String companyId) throws Exception {
		logger.debug("getCopyrightText started. tenantId=" + tenantId);

		String inputParams = "tenantId=" + tenantId + "&companyId=" + companyId;
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getCopyright";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);
		
		String resultCode = "Error";
		int reasonCode = -100; 
		String copyrightText = "";
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);

			resultCode = (String)responseObj.get("resultCode");
			
			if (resultCode.equals("OK")) {
				reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
				
				if (reasonCode == 0) {
					JSONObject result = (JSONObject)responseObj.get("result");
					
					if (result != null) {
						copyrightText = (String)result.get("copyrightText");
						copyrightText = copyrightText == null ? "" : copyrightText;
					}
				}
			}
		}
		
		logger.debug("getCopyrightText ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		return copyrightText;
	}
	
	@Override
	public int saveMailCopyright(String copyrightText, String useCopyright, int tenantId, String companyId) throws Exception {
		logger.debug("saveMailCopyright started. useCopyright=" + useCopyright + ",tenantId=" + tenantId + ", companyId=" + companyId);

		String inputParams = "tenantId=" + tenantId + "&copyrightText=" + URLEncoder.encode(copyrightText, "UTF-8") 
				+ "&useCopyright=" + useCopyright + "&companyId=" + companyId;
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/updateCopyright";
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
		
		logger.debug("saveMailCopyright ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		return reasonCode;		
	}
	
	@Override
	public void setMailCancelSend(int tenantId, String primary, String pMessageId, String pUserId, String pSubject, List<String> pInnerAddresses, Locale locale, String eachCancel) throws Exception {
		logger.debug("setMailCancelSend started.");
		logger.debug("tenantId=" + tenantId + ",primary=" + primary + ",pMessageId=" + pMessageId + ",pUserId=" + pUserId + ",pSubject=" + pSubject);
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String messageIdParam = "messageId=" + URLEncoder.encode(pMessageId, "UTF-8");
		String senderEmailParam = "senderEmail=" + URLEncoder.encode(pUserId + "@" + domainName, "UTF-8");
		String subjectParam = "subject=" + URLEncoder.encode(pSubject, "UTF-8");
		String primaryParam = "primary=" + primary;
		String tenantIdParam = "tenantId=" + tenantId;
		
		StringBuilder receiverEmailParam = new StringBuilder();
		
		for (String innerAddress : pInnerAddresses) {
			receiverEmailParam.append("&re=" + URLEncoder.encode(innerAddress, "UTF-8"));
		}
		
		String inputParams = messageIdParam + "&" + senderEmailParam + "&" + subjectParam + "&" + primaryParam + "&" + tenantIdParam;
		inputParams += receiverEmailParam.toString();
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/setMailRecall2", inputParams);
		logger.debug("strJson=" + strJson);
		
		//get recallIdx
		String recallIdx = "";
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
		
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
        	recallIdx = (String)object.get("result");
		}
		
		//회수처리 함수 호출(비동기)
		if (recallIdx != null && !recallIdx.equals("") && !recallIdx.equals("0")) {
			ezEmailAsync.cancelMailDelete(recallIdx, tenantId, locale, pUserId, eachCancel, recallIdx);
		} else {
			throw new Exception("Cannot get recallIdx. So, cannot call cancelMailDelete method(Async).");
		}
		
		logger.debug("setMailCancelSend ended.");
	}

	@Override
	public int removeUserMailSetting(String userEmailAddress) throws Exception {
		logger.debug("removeUserMailSetting started. userEmailAddress=" + userEmailAddress);

		String inputParams = "userEmailAddress=" + URLEncoder.encode(userEmailAddress, "UTF-8");

		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/removeUserMailSet";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

		logger.debug("response=" + response);

		String resultCode = "Error";
		int reasonCode = -100;

		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject) jsonParser.parse(response);

			resultCode = (String) responseObj.get("resultCode");

			if (resultCode.equals("OK")) {
				reasonCode = ((Long) responseObj.get("reasonCode")).intValue();
			}
		}

		logger.debug("retireUser ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);

		return reasonCode;
	}
	
	@Override
	public int checkUserPrimaryMail(String userEmailAddress, int tenantId) throws Exception {
		logger.debug("checkUserPrimaryMail started. userEmailAddress=" + userEmailAddress);

		String userIdParam = "userEmailAddress=" + URLEncoder.encode(userEmailAddress, "UTF-8") + "&tenantId="
				+ URLEncoder.encode(Integer.toString(tenantId), "UTF-8");
		String inputParams = userIdParam;

		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/checkUserPrimaryMail";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

		logger.debug("response=" + response);

		String resultCode = "Error";
		int reasonCode = -100; // 웹서비스로부터 아무런 응답을 받지 못하거나 OK 응답이 오지 않은 경우를 의미

		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject) jsonParser.parse(response);

			resultCode = (String) responseObj.get("resultCode");

			if (resultCode.equals("OK")) {
				reasonCode = ((Long) responseObj.get("reasonCode")).intValue();
			}
		}

		logger.debug("checkUserPrimaryMail ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);

		return reasonCode;
	}
}
