package egovframework.ezEKP.ezEmail.service.impl;

import java.net.URLEncoder;
import java.util.Properties;

import egovframework.let.utl.fcc.service.CommonUtil;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;







import egovframework.ezEKP.ezEmail.service.EzEmailAdminLetterService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;

@Service("EzEmailAdminLetterService")
public class EzEmailAdminLetterServiceImpl extends EgovAbstractServiceImpl implements EzEmailAdminLetterService {
	private static final Logger logger = LoggerFactory.getLogger(EzEmailServiceImpl.class);

	@Autowired
    private Properties config;

	@Autowired
	private CommonUtil commonUtil;

	@Autowired
    private EzEmailUtil ezEmailUtil;
	
	/**
	 * 전체 편지지함 목록 조회(기본)
	 * @param companyId, companyId
	 */
	@Override
	public JSONArray selectAllLetterBox(String companyId, String tenantId) throws Exception {
		logger.debug("selectAllLeterBox started.");
		logger.debug("companyId=" + companyId + ",tenantId=" + tenantId);
		
		String tenantStr = "companyId=" + URLEncoder.encode(companyId, "UTF-8");
		String companyIdStr = "tenantId=" + URLEncoder.encode(tenantId, "UTF-8");
		String inputParams = companyIdStr + "&" + tenantStr;
		
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/JMochaLetter/getAllLetterBox", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONArray json = new JSONArray();
		
		if (!strJson.equals("")){
			JSONParser parser = new JSONParser();
			JSONObject object = (JSONObject)parser.parse(strJson);
			
			json = (JSONArray) object.get("result");
			
			if (object.get("resultCode").equals("ERROR") || ((Long)object.get("reasonCode")).intValue() == -1 || json.size() <= 0) {
				//throw new Exception("JGwServer ERROR");
			}
		}
		
		logger.debug("selectAllLeterBox ended.");
		
		return json;
	}
	
	/**
	 * 선택한 편지지함 조회
	 * @param letterBoxNo
	 */
	@Override
	public JSONObject selectOneLetterBox(String letterBoxNo) throws Exception {
		logger.debug("selectOneLetterBox started. letterBoxNo=" + letterBoxNo);
		
		String letterBoxNoStr = "letterBoxNo=" + URLEncoder.encode(letterBoxNo, "UTF-8");
		String inputParams = letterBoxNoStr;
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/JMochaLetter/getOneLetterBox", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONObject json = new JSONObject();
		
		if (!strJson.equals("")){
			JSONParser parser = new JSONParser();
			JSONObject object = (JSONObject)parser.parse(strJson);
			
			json = (JSONObject) object.get("result");
			
			if (object.get("resultCode").equals("ERROR") || ((Long)object.get("reasonCode")).intValue() == -1 || json.size() <= 0) {
				throw new Exception("JGwServer ERROR");
			}
		}
		
        logger.debug("selectOneLetterBox ended.");
        
		return json;
	}
	
	/**
	 * 편지지함명 조회
	 * @param letterBoxNo
	 */
	@Override
	public JSONObject selectLetterBoxName(String letterBoxNo, String userLang) throws Exception {
		logger.debug("selectLetterBoxName started. letterBoxNo=" + letterBoxNo + ",userLang=" + userLang);
		
		String letterBoxNoStr = "letterBoxNo=" + URLEncoder.encode(letterBoxNo, "UTF-8");
		String userLangStr = "userLang=" + URLEncoder.encode(userLang, "UTF-8");
		String inputParams = letterBoxNoStr + "&" + userLangStr;
		
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/JMochaLetter/getLetterBoxName", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONObject json = new JSONObject();
		
		if (!strJson.equals("")){
			JSONParser parser = new JSONParser();
			JSONObject object = (JSONObject)parser.parse(strJson);
			
			json = (JSONObject) object.get("result");
			
			if (object.get("resultCode").equals("ERROR") || ((Long)object.get("reasonCode")).intValue() == -1 || json.size() <= 0) {
				throw new Exception("JGwServer ERROR");
			}
		}
		
        logger.debug("selectLetterBoxName ended.");
        
		return json;
	}
	
	/**
	 * 편지지함 추가
	 * @param parentLetterboxNo, displayname, displayname2, companyId, tenantId
	 */
	@Override
	public void insertLetterBox(String parentLetterboxNo, String displayname,
			String displayname2, String companyId, String tenantId) throws Exception {
		logger.debug("insertLetterBox started.");
		logger.debug("parentLetterboxNo=" + parentLetterboxNo + ",displayname=" + displayname + ",displayname2=" + displayname2 + ",companyId" + companyId + ",tenantId=" + tenantId);

		displayname = displayname != null ? commonUtil.convertTagSymbols(displayname) : displayname;
		displayname2 = displayname2 != null ? commonUtil.convertTagSymbols(displayname2) : displayname2;

		String tenantStr = "tenantId=" + URLEncoder.encode(tenantId, "UTF-8");
		String parentLetterBoxNoStr = "parentLetterboxNo=" + URLEncoder.encode(parentLetterboxNo, "UTF-8");
		String displayNameStr = "displayname=" + URLEncoder.encode(displayname, "UTF-8");
		String displayName2Str = "displayname2=" + URLEncoder.encode(displayname2, "UTF-8");
		String companyIdStr = "companyId=" + URLEncoder.encode(companyId, "UTF-8");
		String inputParams = parentLetterBoxNoStr + "&" + displayNameStr + "&" + displayName2Str + "&" + companyIdStr + "&" + tenantStr;
		logger.debug(inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/JMochaLetter/insertLetterBox", inputParams);
		logger.debug("strJson=" + strJson);
		
		if (!strJson.equals("")){
			JSONParser parser = new JSONParser();
			JSONObject object = (JSONObject)parser.parse(strJson);
			
			if (object.get("resultCode").equals("ERROR") || ((Long)object.get("reasonCode")).intValue() == -1) {
				throw new Exception("JGwServer ERROR");
			}
		}
		
		logger.debug("insertLetterBox ended.");
		
	}
	
	/**
	 * 편지지함 삭제 
	 * @param letterBoxNo
	 */
	@Override
	public void deleteLetterBox(String letterBoxNo) throws Exception {
		logger.debug("deleteLetterBox started. letterBoxNo=" + letterBoxNo);
		
		String letterBoxNoStr = "letterBoxNo=" + URLEncoder.encode(letterBoxNo, "UTF-8");
		String inputParams = letterBoxNoStr;
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/JMochaLetter/deleteLetterBox", inputParams);
		logger.debug("strJson=" + strJson);
		
		if (!strJson.equals("")){
			JSONParser parser = new JSONParser();
			JSONObject object = (JSONObject)parser.parse(strJson);
			
			if (object.get("resultCode").equals("ERROR") || ((Long)object.get("reasonCode")).intValue() == -1) {
				throw new Exception("JGwServer ERROR");
			}
		}
		
        logger.debug("deleteLetterBox ended.");
		
	}
	
	/**
	 * 편지지함 수정
	 * @param letterBoxNo, parentLetterboxNo, displayname, displayname2, companyId, tenantId
	 */
	@Override
	public void updateLetterBox(String letterBoxNo,
			String parentLetterboxNo, String displayname,
			String displayname2, String companyId, String tenantId) throws Exception {
		
		logger.debug("updateLetterBox started.");
		logger.debug("letterBoxNo=" + letterBoxNo + ",parentLetterboxNo=" + parentLetterboxNo 
				+ ",displayname=" + displayname + ",displayname2=" + displayname2 + ",companyId=" + companyId + ",tenantId=" + tenantId);

		displayname = displayname != null ? commonUtil.convertTagSymbols(displayname) : displayname;
		displayname2 = displayname2 != null ? commonUtil.convertTagSymbols(displayname2) : displayname2;

		String tenantStr = "tenantId=" + URLEncoder.encode(tenantId, "UTF-8");
		String letterBoxNoStr = "letterBoxNo=" + URLEncoder.encode(letterBoxNo, "UTF-8");
		String parentLetterBoxNoStr = "parentLetterboxNo=" + URLEncoder.encode(parentLetterboxNo, "UTF-8");
		String displayNameStr = "displayname=" + URLEncoder.encode(displayname, "UTF-8");
		String displayName2Str = "displayname2=" + URLEncoder.encode(displayname2, "UTF-8");
		String companyIdStr = "companyId=" + URLEncoder.encode(companyId, "UTF-8");
		String inputParams = letterBoxNoStr + "&" + parentLetterBoxNoStr + "&" + displayNameStr + "&" + displayName2Str + "&" + companyIdStr + "&" + tenantStr;
		logger.debug(inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/JMochaLetter/setLetterBox", inputParams);
		logger.debug("strJson=" + strJson);
		
		if (!strJson.equals("")){
			JSONParser parser = new JSONParser();
			JSONObject object = (JSONObject)parser.parse(strJson);
			
			if (object.get("resultCode").equals("ERROR") || ((Long)object.get("reasonCode")).intValue() == -1) {
				throw new Exception("JGwServer ERROR");
			}
		}
		
		logger.debug("updateLetterBox ended.");
		
	}

	/**
	 * 편지지 검색 (재은)
	 * @param searchStr, companyId, tenantId
	 */
	@Override
	public JSONArray searchLetter(String search, String companyId, String tenantId, String userLang) throws Exception {
		logger.debug("searchLetter started.");
		logger.debug("search=" + search +", companyId=" + companyId + ",tenantId=" + tenantId + ",userLang=" + userLang);
		
		String searchStr = "displayname=" + URLEncoder.encode(search, "UTF-8");
		String companyIdStr = "companyId=" + URLEncoder.encode(companyId, "UTF-8");
		String tenantStr = "tenantId=" + URLEncoder.encode(tenantId, "UTF-8");
		String userLangStr = "userLang=" + URLEncoder.encode(userLang, "UTF-8");
		
		String inputParams = searchStr + "&" + companyIdStr + "&" + tenantStr + "&" + userLangStr;
		logger.debug("inputParams="+inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/JMochaLetter/getLetterSearch", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONArray json = new JSONArray();
		
		if (!strJson.equals("")){
			JSONParser parser = new JSONParser();
			JSONObject object = (JSONObject)parser.parse(strJson);
			
			json = (JSONArray) object.get("result");
			
			if (object.get("resultCode").equals("ERROR") || ((Long)object.get("reasonCode")).intValue() == -1 || json.size() <= 0) {
				throw new Exception("JGwServer ERROR");
			}
		}
		
		logger.debug("searchLetter ended.");
		
		return json;
		
	}
	
	/**
	 * 편지지 순서 수정 (재은)
	 * @param letterOrder, letterNo
	 */
	public void updateLetterOrder(String letterOrder, String letterNo) throws Exception {
		logger.debug("updateLetterBox started.");
		logger.debug("letterOrder=" + letterOrder + ",letterNo=" + letterNo);
		
		String letterOrderStr = "letterOrder=" + URLEncoder.encode(letterOrder, "UTF-8");
		String letterNoStr = "letterNo=" + URLEncoder.encode(letterNo, "UTF-8");
		String inputParams = letterOrderStr + "&" + letterNoStr;
		logger.debug(inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/JMochaLetter/setLetterOrder", inputParams);
		logger.debug("strJson=" + strJson);
		
		if (!strJson.equals("")){
			JSONParser parser = new JSONParser();
			JSONObject object = (JSONObject)parser.parse(strJson);
			
			if (object.get("resultCode").equals("ERROR") || ((Long)object.get("reasonCode")).intValue() == -1) {
				throw new Exception("JGwServer ERROR");
			}
		}
		
		logger.debug("updateLetterBox ended.");
	}
	
	/**
	 * 편지지 편지지함 이동 (재은)
	 * @param letterNo, parentLetterBoxNo
	 */
	public void updateLetterMove(String letterNo, String parentLetterBoxNo) throws Exception {
		logger.debug("updateLetterMove started.");
		logger.debug("letterNo=" + letterNo + ", parentLetterBoxNo=" + parentLetterBoxNo);
		
		String letterNoStr = "letterNo=" + URLEncoder.encode(letterNo, "UTF-8");
		String parentLetterBoxNoStr = "parentLetterboxNo=" + URLEncoder.encode(parentLetterBoxNo, "UTF-8");
		
		String inputParams = letterNoStr + "&" + parentLetterBoxNoStr;
		logger.debug(inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/JMochaLetter/updateLetterMove", inputParams);
		logger.debug("strJson=" + strJson);
		
		if (!strJson.equals("")){
			JSONParser parser = new JSONParser();
			JSONObject object = (JSONObject)parser.parse(strJson);
			
			if (object.get("resultCode").equals("ERROR") || ((Long)object.get("reasonCode")).intValue() == -1) {
				throw new Exception("JGwServer ERROR");
			}
		}
		
		logger.debug("updateLetterMove ended.");
	}
	
	
	/**
	 * 편지지 추가 (수아)
	 * @param displayname, displayname2, letterBoxNo (편지지 이름, 편지지 이름 영문, 편지지함 번호, 편지지 아이디)
	 * */
	@Override
	public void addLetter(String displayname, String displayname2,
			String letterBoxNo, String letterId) throws Exception {
		logger.debug("addLetter started. displayname=" + displayname + ",displayname2=" + displayname2 + ",letterBoxNo=" + letterBoxNo + ",letterId="
				+ letterId);
		
		String displaynameStr = "displayname=" + URLEncoder.encode(displayname, "UTF-8");
		String displayname2Str = "displayname2=" + URLEncoder.encode(displayname2, "UTF-8");
		String letterBoxNoStr = "letterBoxNo=" + URLEncoder.encode(letterBoxNo, "UTF-8");
		String letterIdStr = "letterId=" + URLEncoder.encode(letterId, "UTF-8");
		String inputParams = displaynameStr + "&" + displayname2Str + "&" + letterBoxNoStr + "&" + letterIdStr;
		logger.debug("inputParams="+inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/JMochaLetter/setLetter", inputParams);
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
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/JMochaLetter/updateDisplayNameLetter", inputParams);
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
	 * 편지지 삭제 (수아)
	 * @param letterNo (편지지 번호)
	 */
	@Override
	public void deleteLetter(String letterNo) throws Exception {
		logger.debug("deleteLetter started. letterNo=" + letterNo);
		
		String letterNoStr = "letterNo=" + URLEncoder.encode(letterNo, "UTF-8");
		String inputParams = letterNoStr;
		logger.debug("inputParams="+inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/JMochaLetter/deleteLetter", inputParams);
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
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/JMochaLetter/selectAllLetter", inputParams);
		logger.debug("strJson="+strJson);
		
		JSONArray test = new JSONArray();
		
		if (!strJson.equals("")){
			JSONParser parser = new JSONParser();
			JSONObject object = (JSONObject)parser.parse(strJson);
			
			test = (JSONArray) object.get("result");
			
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
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/JMochaLetter/selectDetailLetter", inputParams);
		logger.debug("strJson="+strJson);
		
		JSONObject resultJsonObj = new JSONObject();
		
		if (!strJson.equals("")){
			JSONParser parser = new JSONParser();
			JSONObject object = (JSONObject)parser.parse(strJson);
			
			resultJsonObj = (JSONObject) object.get("result");
			
			if (object.get("resultCode").equals("ERROR") || ((Long)object.get("reasonCode")).intValue() == -1 || resultJsonObj.size() <= 0) {
				throw new Exception("JGwServer ERROR");
			}
		}
		
        logger.debug("selectDetailLetter ended.");
        
		return resultJsonObj;
	}
	
}
