package egovframework.ezEKP.ezWebFolder.web;

import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.google.gson.Gson;

import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzWebFolderController_y {

	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	private static final Logger LOGGER = LoggerFactory.getLogger(EzWebFolderController_y.class);
	
	// getFolderList /ezwebfolder/users/{userId}/folder-list에 가는 메소드 
	@RequestMapping(value = "/ezWebFolder/folderList.do")
	public String getFolderList (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model )throws Exception {
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String gwServerUrl = config.getProperty("config.webFolderGWServerURL");
		
		String url = gwServerUrl + "/webfolder/users/" +userInfo.getId() + "/folder-list";
		
		// 이부분 모르겠어요 header를 만드는건데 거기에 Accept랑 x-user-host가 있는 이유를 모르겠어요 
		RestTemplate rest = new RestTemplate();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>( headers );
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
						
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject)jp.parse(result.getBody());
		LOGGER.debug(resultBody.get("status").toString());		
		LOGGER.debug(resultBody.get("id").toString());		
		LOGGER.debug(resultBody.get("test_GW").toString());		
		
		
//		JSONObject resultBody = result.getBody();
	
		String status = resultBody.get("status").toString();
		
		JSONObject test = new JSONObject();
		
		if (status.equals("ok")) {
			LOGGER.debug(resultBody.get("test_GW").toString());	
			test.put("test",resultBody.get("test_GW").toString());
			model.addAttribute("test", resultBody.get("test_GW").toString());
			
			
		}
		
		return "json";
		
	}
	
	
	
	
	
	
	
	/*
	
	get   folderList
	
	get  folderListDetail
	
	post  folderInsert
	
	
	put  folderUpdate
	
	put   folderMove
	
	
	post    folderCopy
	
	delete folderDelete
	
	get   fileList
	
	
	*/
	
}
