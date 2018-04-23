package egovframework.ezEKP.ezStatistics.web;

import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

/**
 * @Description [Controller] 근태 통계
 * @author 오픈솔루션팀 김보미
 * @Modification Information
 *
 *    수정일        		수정자             수정내용
 *    ----------    ------    -------------------
 *    2018.04.12    김보미             신규작성
 *
 */

@Controller
public class EzStatisticsAttitudeController {
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	/**
	 * 개인별 근태 통계 리스트 화면 출력 메서드
	 */
	@RequestMapping(value = {"/ezStatistics/statisticsAttitudeUser.do" , "/ezStatistics/statisticsAttitudeMain.do"})
	public String statisticsAttitudeUser(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		//관리자 권한체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String topid = "";
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1) {
			topid = userInfo.getCompanyID();
		} else {
			topid = "Top";
		}
		
		model.addAttribute("companyId", topid);				
		model.addAttribute("deptID", userInfo.getDeptID());
		
		//회사리스트 - companyList
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/companies";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userInfo.getId());
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		JSONArray companyList = new JSONArray();
		JSONObject data = new JSONObject();
		String adminCompany = "";
		if (status.equals("ok")) {
		
			data = (JSONObject) resultBody.get("data");
			companyList = (JSONArray) data.get("list");
			adminCompany = (String) data.get("adminCompany");
			
			model.addAttribute("companyList", companyList);
			model.addAttribute("adminCompany", adminCompany);
		}
		
		//근태유형(구분) 리스트
		gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		url = gwServerUrl + "/rest/ezattitude/companies/" + adminCompany + "/attitudetypes";//TODO
		
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		entity = new HttpEntity<>(headers);
		
		builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userInfo.getId());
		
		result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		resultBody = (JSONObject) jp.parse(result.getBody());
				
		status = resultBody.get("status").toString();
		
		JSONArray typeList = new JSONArray();
		if (status.equals("ok")) {		
			typeList = (JSONArray) resultBody.get("data");
			
			model.addAttribute("typeList", typeList);
		}
		
		return "ezStatistics/statisticsAttitudeUser";
	}
	
	/**
	 * 부서별 근태 통계 리스트
	 */
	@RequestMapping(value="/ezStatistics/statisticsAttitudeDept.do")
	public String statisticsAttitudeDept(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		//관리자 권한체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String topid = "";
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1) {
			topid = userInfo.getCompanyID();
		} else {
			topid = "Top";
		}
		
		model.addAttribute("companyID", topid);		
		model.addAttribute("deptID", userInfo.getDeptID());
		
		//회사리스트 - companyList
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/companies";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userInfo.getId());
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		JSONArray companyList = new JSONArray();
		JSONObject data = new JSONObject();
		String adminCompany = "";
		if (status.equals("ok")) {
		
			data = (JSONObject) resultBody.get("data");
			companyList = (JSONArray) data.get("list");
			adminCompany = (String) data.get("adminCompany");
			
			model.addAttribute("companyList", companyList);
			model.addAttribute("adminCompany", adminCompany);
		}
		
		return "ezStatistics/statisticsAttitudeDept";
	}
	
	/**
	 * 회사선택시마다 조직도 변경
	 * @param loginCookie
	 * @param request
	 * @param model
	 * @return 
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezStatistics/deptList.do")
	@ResponseBody
	public JSONArray deptList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String companyId = request.getParameter("companyId");
		
		//조직도 회사,부서 리스트
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/organtree/depts";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", companyId)
				.queryParam("userId", userInfo.getId());
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();		
		
		JSONObject jObject = new JSONObject();
		JSONArray deptList = new JSONArray();
		if (status.equals("ok")) {
			deptList = (JSONArray) resultBody.get("data");
			
			for (int i = 0; i < deptList.size(); i++) {
				JSONObject dept =  (JSONObject) deptList.get(i);
				if (dept.get("isComp").equals("comp")) {
					dept.put("icon", "icon-company");
				} else{
					dept.put("icon", "icon-dept");
				}
				if (dept.get("myDept").equals("yes")) {
					JSONObject state = new JSONObject();
					state.put("opened", "true");
					state.put("selected", "true");
					dept.put("state", state);
				}
			}
		}
		return deptList;
	}
	
	/**
	 * 조직도 회사변경시마다 근태유형 변경.
	 */
	@RequestMapping(value = "/ezStatistics/attitudeTypeList.do")
	@ResponseBody
	public JSONArray getAttitudeTypeList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{

		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String companyId = request.getParameter("companyId");
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/companies/" + companyId + "/attitudetypes";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userInfo.getId())
				.queryParam("statistics", "statistics");
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		JSONArray typeList = new JSONArray();
		if (status.equals("ok")) {		
			typeList = (JSONArray) resultBody.get("data");
		}
		
		return typeList;
	}
	
	/**
	 * 개인별 통계 현황 데이터 반환 함수
	 */
	@RequestMapping(value="/ezStatistics/getAttitudeUser.do",method=RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String getAttitudeUser(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
        //관리자 권한체크
		LoginVO user = commonUtil.checkAdmin(loginCookie);
		
		if (user == null) {
			return "cmm/error/adminDenied";
		}
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String selectUserId = request.getParameter("userId");
		String year = request.getParameter("year");
		String typeId = request.getParameter("typeId");
		String startDate = year + "-01-01";//2018-01-01
		String endDate = year + "-12-31";//2018-12-31
		String offset = userInfo.getOffset();

		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");	
		String url = gwServerUrl + "/rest/ezattitude/users/"+selectUserId+"/attitudetypes/"+typeId+"/attitude-count";
									
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("offset", offset)
				.queryParam("startDate", startDate)
				.queryParam("endDate", endDate)
				.queryParam("userId", userInfo.getId());
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
				
		String status = resultBody.get("status").toString();
		
		/*
		Document doc = commonUtil.convertStringToDocument(bodyData);
		String sDate = doc.getElementsByTagName("SDATE").item(0).getTextContent();
		String eDate = doc.getElementsByTagName("EDATE").item(0).getTextContent();
		
		String tenantIdParam = "tenantId=" + user.getTenantId();
		String searchIdParam = "searchId=" + userId;
		String typeParam = "type=3";
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
					sb.append(commonUtil.cleanValue(colValue));
					sb.append("</" + colName + ">");
				}
				
				sb.append("</ROW>");
			}
		}
		
		sb.append("</DATA>");
		
		String returnData = sb.toString();
		
		return returnData;	
		*/
		return "**********************************************************************************************************************************";
	}
}
