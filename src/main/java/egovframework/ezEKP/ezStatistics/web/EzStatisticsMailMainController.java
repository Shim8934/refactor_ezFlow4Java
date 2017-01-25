package egovframework.ezEKP.ezStatistics.web;

import java.util.List;
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
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
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
public class EzStatisticsMailMainController {
	
	private static final Logger logger = LoggerFactory.getLogger(EzStatisticsMailMainController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private EzEmailUtil ezEmailUtil;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	/**
	 * 통계 메일 메인 화면 표시 함수
	 */
	@RequestMapping(value="/ezStatistics/statisticsMailMain.do")
	public String statisticsMailMain(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception{
		//관리자 권한체크
		LoginVO user = commonUtil.checkAdmin(loginCookie);
		
		if (user == null) {
			return "cmm/error/adminDenied";
		}		
				
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(user.getPrimary(), user.getTenantId());
		
		StringBuilder listCompany = new StringBuilder();
		for (OrganDeptVO vo : list) {
			if ((user.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(user.getCompanyID()))
					&& !vo.getCn().equals("Top")) {
				listCompany.append("<option value='" + vo.getCn() + "'>");
				listCompany.append(vo.getDisplayName());
				listCompany.append("</option>");
			}
		}
		
		model.addAttribute("listCompany", listCompany.toString());
		
		return "ezStatistics/statisticsMailMain";
	}

	/**
	 * 통계 메일 메인 데이터 반환 함수
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezStatistics/getMailMain.do",method=RequestMethod.POST,
			produces="text/xml; charset=utf-8")
	@ResponseBody
	public String getMailMain(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Locale locale, Model model) throws Exception {
        //관리자 권한체크
		LoginVO user = commonUtil.checkAdmin(loginCookie);
		
		if (user == null) {
			return "cmm/error/adminDenied";
		}
        	    
		logger.debug("getMailMain started");		
		logger.debug("bodyData=" + bodyData);
		
		Document doc = commonUtil.convertStringToDocument(bodyData);
		String sDate = doc.getElementsByTagName("SDATE").item(0).getTextContent();
		String eDate = doc.getElementsByTagName("EDATE").item(0).getTextContent();
		String company = doc.getElementsByTagName("COMPANY").item(0).getTextContent();
		
		String tenantIdParam = "tenantId=" + user.getTenantId();
		String sDateParam = "sDate=" + sDate + "01";
		String eDateParam = "eDate=" + eDate + "12";
		String searchIdParam = "searchId=" + company;
		String typeParam = "type=0";
		String userLangParam = "userLang=" + user.getPrimary();
		
		String inputParams = tenantIdParam + "&" + sDateParam + "&" + eDateParam + "&" + searchIdParam
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
		
		logger.debug("getMailMain ended");
		
		return returnData;				
	}
	
	/**
	 * 직원정보 검색 화면 호출(부서명 2개 이상일 경우)
	 */
	@RequestMapping(value="/ezStatistics/statisticsCheckName2.do")
	public String mailCheckName2(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model) throws Exception {
		return "ezStatistics/statisticsCheckName2";
	}
}
