package egovframework.ezEKP.ezEmail.service.impl;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.google.gson.JsonArray;

import egovframework.ezEKP.ezEmail.service.EzEmailAdminLetterService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailLetterVO;

@Service("EzEmailAdminLetterService")
public class EzEmailAdminLetterServiceImpl implements EzEmailAdminLetterService {
	private static final Logger logger = LoggerFactory.getLogger(EzEmailServiceImpl.class);

	@Autowired
    private Properties config;
	
	@Autowired
    private EzEmailUtil ezEmailUtil;
	
	/**
	 * 편지지 추가 (수아)
	 * @param displayname, displayname2, letterBoxNo (편지지 이름, 편지지 이름 영문, 편지지함 번호)
	 * */
	@Override
	public void addLetter(String displayname, String displayname2,
			String letterBoxNo) throws Exception {
		logger.debug("addLetter started. displayname=" + displayname + ",displayname2=" + displayname2 + ",letterBoxNo=" + letterBoxNo);
		
		String displaynameStr = "displayname=" + URLEncoder.encode(displayname, "UTF-8");
		String displayname2Str = "displayname2=" + URLEncoder.encode(displayname2, "UTF-8");
		String letterBoxNoStr = "letterBoxNo=" + URLEncoder.encode(letterBoxNo, "UTF-8");
		String inputParams = displaynameStr + "&" + displayname2Str + "&" + letterBoxNoStr;
		logger.debug("inputParams="+inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaLetter/setLetter", inputParams);
		logger.debug("strJson="+strJson);
		
		if (!strJson.equals("")){
			JSONParser parser = new JSONParser();
			JSONObject object = (JSONObject)parser.parse(strJson);
			
			// resonCode -> reasonCode 수정하기
			if (object.get("resultCode").equals("ERROR") || ((Long)object.get("reasonCode")).intValue() == -1) { 
				throw new Exception("JGwServer ERROR");
			}
		}
		
        logger.debug("addLetter ended.");
	}
	
	/**
	 * 편지지 수정 - 편지지 이름 (수아)
	 * @param displayname, displayname2, letterNo (편지지 이름, 편지지 이름 영문, 편지지 번호)
	 */
	@Override
	public void updateDisplayNameLetter(String displayname,
			String displayname2, String letterNo) throws Exception {
		logger.debug("updateDisplayNameLetter started. displayname=" + displayname + ",displayname2=" + displayname2 + ",letterNo=" + letterNo);
		
		String displaynameStr = "displayname=" + URLEncoder.encode(displayname, "UTF-8");
		String displayname2Str = "displayname2=" + URLEncoder.encode(displayname2, "UTF-8");
		String letterNoStr = "letterNo=" + URLEncoder.encode(letterNo, "UTF-8");
		String inputParams = displaynameStr + "&" + displayname2Str + "&" + letterNoStr;
		logger.debug("inputParams="+inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaLetter/updateDisplayNameLetter", inputParams);
		logger.debug("strJson="+strJson);
		
		if (!strJson.equals("")){
			JSONParser parser = new JSONParser();
			JSONObject object = (JSONObject)parser.parse(strJson);
			
			if (object.get("resultCode").equals("ERROR") || ((Long)object.get("reasonCode")).intValue() == -1) {
				throw new Exception("JGwServer ERROR");
			}
		}
		
        logger.debug("updateDisplayNameLetter ended.");
	}
	
	/**
	 * 편지지 수정 - 편지지 순서 (수아)
	 * @param letterOrder, letterNo (편지지 순서, 편지지 번호)
	 */
	@Override
	public void updateOrderLetter(String letterOrder, String letterNo)
			throws Exception {
		logger.debug("updateOrderLetter started. letterOrder=" + letterOrder +  ",letterNo=" + letterNo);
		
		String letterOrderStr = "letterOrder=" + URLEncoder.encode(letterOrder, "UTF-8");
		String letterNoStr = "letterNo=" + URLEncoder.encode(letterNo, "UTF-8");
		String inputParams = letterOrderStr + "&" + letterNoStr;
		logger.debug("inputParams="+inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaLetter/updateOrderLetter", inputParams);
		logger.debug("strJson="+strJson);
		
		if (!strJson.equals("")){
			JSONParser parser = new JSONParser();
			JSONObject object = (JSONObject)parser.parse(strJson);
			
			if (object.get("resultCode").equals("ERROR") || ((Long)object.get("reasonCode")).intValue() == -1) {
				throw new Exception("JGwServer ERROR");
			}
		}
		
        logger.debug("updateOrderLetter ended.");
	}

	/**
	 * 편지지 수정 - 편지지함 (수아)
	 * @param letterNo, letterBoxNo (편지지 번호, 편지지함 번호)
	 */
	@Override
	public void updateBoxLetter(String letterNo, String letterBoxNo)
			throws Exception {
		logger.debug("updateBoxLetter started. letterBoxNo=" + letterBoxNo +  ",letterNo=" + letterNo);
		
		String letterBoxNoStr = "letterBoxNo=" + URLEncoder.encode(letterBoxNo, "UTF-8");
		String letterNoStr = "letterNo=" + URLEncoder.encode(letterNo, "UTF-8");
		String inputParams = letterBoxNoStr + "&" + letterNoStr;
		logger.debug("inputParams="+inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaLetter/updateBoxLetter", inputParams);
		logger.debug("strJson="+strJson);
		
		if (!strJson.equals("")){
			JSONParser parser = new JSONParser();
			JSONObject object = (JSONObject)parser.parse(strJson);
			
			if (object.get("resultCode").equals("ERROR") || ((Long)object.get("reasonCode")).intValue() == -1) {
				throw new Exception("JGwServer ERROR");
			}
		}
		
        logger.debug("updateBoxLetter ended.");
	}

	/**
	 * 편지지 삭제 (수아)
	 * @param letterNo (편지지 번호)
	 */
	@Override
	public void deleteLetter(String letterNo) throws Exception {
		logger.debug("deleteLetter started. letterNo=" + letterNo);
		
		String letterNoStr = "letterNo=" + URLEncoder.encode(letterNo, "UTF-8");
		String inputParams = letterNoStr;
		logger.debug("inputParams="+inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaLetter/deleteLetter", inputParams);
		logger.debug("strJson="+strJson);
		
		if (!strJson.equals("")){
			JSONParser parser = new JSONParser();
			JSONObject object = (JSONObject)parser.parse(strJson);
			
			if (object.get("resultCode").equals("ERROR") || ((Long)object.get("reasonCode")).intValue() == -1) {
				throw new Exception("JGwServer ERROR");
			}
		}
		
        logger.debug("deleteLetter ended.");
	}

	/**
	 * 편지지 목록 조회 (수아)
	 * @param letterBoxNo (편지지함 번호)
	 */
	@Override
	public JSONArray selectAllLeter(String letterBoxNo) throws Exception {
		logger.debug("selectAllLeter started. letterBoxNo=" + letterBoxNo);
		
		String letterBoxNoStr = "letterBoxNo=" + URLEncoder.encode(letterBoxNo, "UTF-8");
		String inputParams = letterBoxNoStr;
		logger.debug("inputParams="+inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaLetter/selectAllLetter", inputParams);
		logger.debug("strJson="+strJson);
		
		JSONArray test = new JSONArray();
		
		if (!strJson.equals("")){
			JSONParser parser = new JSONParser();
			JSONObject object = (JSONObject)parser.parse(strJson);
			
			test = (JSONArray) object.get("resultLetterList");
			
			if (object.get("resultCode").equals("ERROR") || ((Long)object.get("reasonCode")).intValue() == -1 || test.size() <= 0) {
				throw new Exception("JGwServer ERROR");
			}
		}
		
        logger.debug("selectAllLeter ended.");
        
		return test;
	}

	/**
	 * 편지지 개별 조회 (수아)
	 * @param letterNo (편지지 번호)
	 */
	@Override
	public JSONObject selectDetailLetter(String letterNo) throws Exception {
		logger.debug("selectDetailLetter started. letterNo=" + letterNo);
		
		String letterNoStr = "letterNo=" + URLEncoder.encode(letterNo, "UTF-8");
		String inputParams = letterNoStr;
		logger.debug("inputParams="+inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaLetter/selectDetailLetter", inputParams);
		logger.debug("strJson="+strJson);
		
		JSONObject test = new JSONObject();
		
		if (!strJson.equals("")){
			JSONParser parser = new JSONParser();
			JSONObject object = (JSONObject)parser.parse(strJson);
			
			test = (JSONObject) object.get("resultLetter");
			
			if (object.get("resultCode").equals("ERROR") || ((Long)object.get("reasonCode")).intValue() == -1 || test.size() <= 0) {
				throw new Exception("JGwServer ERROR");
			}
		}
		
        logger.debug("selectDetailLetter ended.");
        
		return test;
	}
}
