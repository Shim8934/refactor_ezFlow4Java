package egovframework.ezEKP.ezStatistics.web;

import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;

import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

/** 
 * @Description [Controller] 통계
 * @author 오픈솔루션팀 이동호
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.06.27    이동호             신규작성
 *
 * @see
 */

@Controller
public class EzStatisticsMailUserController {
	
	private static final Logger logger = LoggerFactory.getLogger(EzStatisticsMailUserController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private EzEmailUtil ezEmailUtil;
	
	/**
	 * 개인별 통계 현황 표시 함수
	 */
	@RequestMapping(value="/ezStatistics/statisticsMailUser.do")
	public String statisticsMailUser(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception{	
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		model.addAttribute("deptID", userInfo.getDeptID());
		return "ezStatistics/statisticsMailUser";
	}

	/**
	 * 개인별 통계 현황 데이터 반환 함수
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezStatistics/getMailUser.do",method=RequestMethod.POST,
			produces="text/xml; charset=utf-8")
	@ResponseBody
	public String getMailUser(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Locale locale, Model model) throws Exception {
		logger.debug("getMailUser started");		
		logger.debug("bodyData=" + bodyData);
		
		Document doc = commonUtil.convertStringToDocument(bodyData);
		String sDate = doc.getElementsByTagName("SDATE").item(0).getTextContent();
		String eDate = doc.getElementsByTagName("EDATE").item(0).getTextContent();
		String userId = doc.getElementsByTagName("USERID").item(0).getTextContent();
		
		String sDateParam = "sDate=" + sDate + "01";
		String eDateParam = "eDate=" + eDate + "12";
		String searchIdParam = "searchId=" + userId;
		String typeParam = "type=3";
		String userLangParam = "userLang=1";
		
		String inputParams = sDateParam + "&" + eDateParam + "&" + searchIdParam
								+ "&" + typeParam + "&" + userLangParam;

		logger.debug("inputParams=" + inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/ezEmailAccess/statMailAnalysis";			
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

		logger.debug("response=" + response);		
		
		JSONArray resultArray = null;
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);

			String resultCode = (String)responseObj.get("resultCode");

			if (resultCode.equalsIgnoreCase("OK")) {
				resultArray = (JSONArray)responseObj.get("result");
			}				
		}						
		
		StringBuilder sb = new StringBuilder();
		
		sb.append("<DATA>");

		if (resultArray != null && resultArray.size() > 0) {
			for (int i = 0; i < resultArray.size(); i++) {
				sb.append("<ROW>");
				
				Map<String, String> rowObject = (Map<String, String>)resultArray.get(i);
				
				for (String colName : rowObject.keySet()) {
					String colValue = rowObject.get(colName);
					sb.append("<" + colName + ">");	
					sb.append(colValue);
					sb.append("</" + colName + ">");
				}
				
				sb.append("</ROW>");
			}
		}
		
		sb.append("</DATA>");
		
		String returnData = sb.toString();
		
		logger.debug("getMailUser ended");
		
		return returnData;				
	}
	
}
