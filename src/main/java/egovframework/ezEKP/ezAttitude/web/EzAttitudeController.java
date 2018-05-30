package egovframework.ezEKP.ezAttitude.web;

import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.ibm.icu.text.SimpleDateFormat;
import com.ibm.icu.util.Calendar;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzAttitudeController {
	private static final Logger LOGGER = LoggerFactory.getLogger(EzAttitudeController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name="crypto")
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name = "MOptionService")
	private MOptionService mOptionService;
	
	//내꺼
	
	/////////////////////////////////////////
	//니꺼
	
	/**
	 * 사용자 좌측메뉴
	 * 근태정보관리
	 * 근태입력관리 미입력자관리 관리내역
	 */
	@RequestMapping(value="/ezAttitude/attitudeManage.do")
	public String attitudeManage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		LOGGER.debug("attitudeManage started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String offset = userInfo.getOffset();
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		
		String localDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), offset, false).substring(0, 10);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		
		cal = Calendar.getInstance();
		cal.setTime(sdf.parse(localDate));
		cal.add(Calendar.DAY_OF_MONTH, -7);
		
		String searchStartDate = sdf.format(cal.getTime());
		String searchEndDate = localDate;
		
		String url = gwServerUrl + "/rest/ezattitude/users/" + userInfo.getId() + "/attitude-auth/hyo";

		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", userInfo.getCompanyID())
				.queryParam("listAuthType", "M");
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		JSONArray deptList = new JSONArray();

		if(status.equals("ok")){
			deptList = (JSONArray) resultBody.get("data");
		}

		if (deptList.size() < 1) {
			return "cmm/error/accessDenied";
		}
		
		model.addAttribute("deptList", deptList);		
		model.addAttribute("companyId", userInfo.getCompanyID());
		model.addAttribute("selectedDeptID", userInfo.getDeptID());
		model.addAttribute("searchStartDate", searchStartDate.substring(0, 10));
		model.addAttribute("searchEndDate", searchEndDate.substring(0, 10));
		
		LOGGER.debug("attitudeManage ended.");
		
		return "/ezAttitude/attitudeManage";
	}
	
}
